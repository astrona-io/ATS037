#!/usr/bin/env bash
# Applies the reference solution. Run only by `astrona test`.
set -euo pipefail

kubectl -n starfleet patch deployment beacon --type=json -p '[
  {"op":"replace","path":"/spec/template/spec/containers/0/livenessProbe/httpGet/path","value":"/healthz"},
  {"op":"replace","path":"/spec/template/spec/containers/0/livenessProbe/failureThreshold","value":3},
  {"op":"replace","path":"/spec/template/spec/containers/0/readinessProbe/httpGet/port","value":"http"},
  {"op":"add","path":"/spec/template/spec/containers/0/startupProbe","value":{"httpGet":{"path":"/healthz","port":"http"},"periodSeconds":2,"failureThreshold":30}}
]'
kubectl -n starfleet rollout status deployment beacon --timeout=180s

kubectl apply -f - <<'YAML'
apiVersion: v1
kind: Pod
metadata:
  name: exchange
  namespace: starfleet
spec:
  containers:
    - name: producer
      image: busybox:1.37.0
      command: ["sh", "-c", "while true; do date >> /data/log; sleep 5; done"]
      volumeMounts:
        - name: data
          mountPath: /data
    - name: consumer
      image: busybox:1.37.0
      command: ["sh", "-c", "touch /data/log; tail -f /data/log"]
      volumeMounts:
        - name: data
          mountPath: /data
  volumes:
    - name: data
      emptyDir: {}
YAML
kubectl -n starfleet wait --for=condition=Ready pod/exchange --timeout=120s
echo "[solution] Applied."
