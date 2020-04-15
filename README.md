# AWS Infrastructure

# Kubernetes Dashboard
```
kubectl config use-contexts eks-staging
kubectl proxy
http://localhost:8001/api/v1/namespaces/kube-system/services/http:kubernetes-dashboard:http/proxy
```
