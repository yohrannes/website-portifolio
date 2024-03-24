# This website is fully public for comunity, and can be deployed in any kubernetes services.
---
## To deploy this website you can do it following these steps bellow:
### Obs: The steps may vary depending on the cloud provider.

Get and install the ingress-nginx provider.
```
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v<vnum>/deploy/static/provider/cloud/deploy.yaml
```
- ```<vnum>``` is the number of the most recent version of the ingres-nginx controller, to find out the most recent version of the script, consult the [kubernetes/ingress-nginx on github](https://github.com/kubernetes/ingress-nginx).

Verify if the service was installed and wait for de external ip be provided.
```
kubectl get svc -n ingress-nginx
```
Apply the service and the deployment.
```
kubectl apply -f deploy+service.yaml
```
Install cert-manager on the kubernetes cluster.
```
kubectl apply -f https://github.com/cert-manager/cert-manager/releases/download/v1.13.2/cert-manager.yaml
```
Apply the cluster issuer, for activate the ssl too.
```
kubectl apply -f cluster-issuer.yaml
```
Install ingress.
```
kubectl apply -f ingress.yaml
```
