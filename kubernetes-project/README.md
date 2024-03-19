kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v<vnum>/deploy/static/provider/cloud/deploy.yaml

kubectl get svc -n ingress-nginx

k apply -f deploy+service.yaml

kubectl apply -f https://github.com/cert-manager/cert-manager/releases/download/v1.13.2/cert-manager.yaml

k apply -f cluster-issuer.yaml

k apply -f ingress.yaml
