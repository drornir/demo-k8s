kubectl create namespace argocd
kubectl apply --kustomize argocd
echo "username: admin"
echo -n "password: "
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d; echo