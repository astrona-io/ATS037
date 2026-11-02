---
draft: true
exam_objectives:
  - Administration
---
# Declarative Changes And Deletion

The `scout` Deployment should have three replicas. In declarative management, an author records the intended resource configuration and submits it to Kubernetes. The apply operation creates or updates the object toward that recorded intent. The controller then works toward the requested runtime state.

Imperative management asks for a particular action, such as creating an object or scaling a workload. Both styles can be useful, but changes made only as manual actions are harder to reproduce unless recorded. A versioned configuration provides a reviewable description of the state a team intends to maintain.

Applying a Deployment does not apply every dependency it mentions. A referenced Secret, image or storage claim must exist or become available through another process. Successful validation also does not prove that the referenced application starts. The distinction between valid configuration and achievable behavior remains important after every change.

Deleting a controller and deleting its Pod have different consequences. Deleting a managed Pod can cause its controller to create a replacement. To stop a Deployment-managed application, change the controller's desired state or remove the controller according to the intended lifecycle. Repeatedly deleting Pods while keeping a positive replica count asks the controller to keep undoing the deletion.

Object deletion may take time. Graceful termination lets processes stop safely, and finalizers can defer object removal until a responsible component finishes cleanup. A deletion request therefore does not always mean the object immediately disappears. External data and storage also have their own retention rules.

Reason through a change using intent, ownership and dependencies. Identify the object that owns the desired value, preserve a reviewable record of the change, and check observed behavior after reconciliation. That approach avoids treating a transient Pod as the source of application configuration.

## Desired Configuration And Field Ownership

A declarative file records that `scout` should use three replicas and a particular image. Applying it asks Kubernetes to create or update the corresponding resource. It does not synchronously run all necessary processes, and the author should still inspect progress and behavior after the API accepts the change.

Several tools can modify one object. Server-side apply tracks field management so incompatible changes from different managers can produce a conflict instead of silently overwriting another manager's intent. This makes ownership of a setting important: a human replica edit may conflict with an autoscaler or delivery controller that also manages it. Resolving the conflict requires deciding which source should own the desired value.

Declarative management is not a substitute for careful review. A mistaken namespace can apply a valid resource to the wrong location. An updated Pod template can create a new rollout even if the intended change was only a label. The actual object diff matters more than whether the operation is described as declarative.

## Deletion Is A Lifecycle Operation

Deleting one Pod affects a disposable instance. Deleting its Deployment removes the controller intent for that workload and can affect owned resources according to garbage collection behavior. Deleting a storage claim affects a different lifecycle and can trigger backing storage reclamation. These are not interchangeable ways to “clean up an application.”

A finalizer is a metadata mechanism that prevents completed object removal until its cleanup condition is handled. An object can have a deletion timestamp while still being present. Removing finalizers without understanding the responsible cleanup can leave external resources or data in an inconsistent state.

Choose the object that owns the desired outcome and examine its relationships before changing or deleting it. The result should be reproducible in the intended configuration source, and verification should include dependent resources and user-facing behavior rather than only whether one API request succeeded.

## Common pitfalls

> [!WARNING]
> Deleting one managed Pod usually does not stop its application. The controller can replace it because the desired replica count has not changed.
