# This repository contains all the files needed for implementation of the website yohrannes.com in ArgoCD and/or K8s Service

## Tricks if error with ArgoCD

if error
```
FATA[0002] rpc error: code = InvalidArgument desc = application spec for yohapp is invalid: InvalidSpecError: Unable to generate manifests in kubernetes: rpc error: code = Unknown desc = repository contains out-of-bounds symlinks. file: yoh-app/bin/python3
```

do this
```
unlink <file-linked>>
```

apply argo app
```
argocd app create yohapp \
  --repo https://github.com/yohrannes/website-portifolio.git \
  --path kubernetes \
  --dest-server <cluster-name(argocd cluster list)> \
  --dest-namespace yohapp
```
```
![CD completed!](argocd-notes/RUNNING(°-°)b.webp)
```

## GitLab Runner Management

### Local Installation & Registration
```bash
curl -L "https://packages.gitlab.com/install/repositories/runner/gitlab-runner/script.rpm.sh" | sudo bash
sudo apt-get install gitlab-runner
gitlab-runner register --url https://gitlab.com --token <REGISTRATION_TOKEN>
```

### Kubernetes (OKE) Runner Deployment
Manual steps (if not using pipeline):
```bash
helm repo add gitlab https://charts.gitlab.io
kubectl create ns gitlab-runner
kubectl create rolebinding --namespace=gitlab-runner gitlab-runner-binding --role=gitlab-runner --serviceaccount=gitlab-runner:default
helm install --namespace gitlab-runner gitlab-runner -f values-new.yaml gitlab/gitlab-runner
```

### Troubleshooting
Check runner pod image:
```bash
kubectl get po -n gitlab-runner <pod-name> -o jsonpath='{.spec.containers[0].image}'
```
