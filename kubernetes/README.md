# This repository contains all the files needed for implementation of the website yohrannes.com in ArgoCD and/or K8s Service


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
