
# this file just exposes some functions, `source` it.

function dirname() {
  print "$(basename $(git rev-parse --show-toplevel))"
}

function preinstall_tools_mac() {
  brew install k3d 
  brew install kubectl
  brew install argocd
}

function local_cluster_install() {
  k3d cluster create $(dirname)
}

function install_argo_cd() {
  kubectl create namespace argocd
  kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

  clustername=$(kubectl config get-contexts -o name | grep $(dirname))

  argocd cluster add $clustername
}

function local_argocd_login(){
  echo_argocd_credentials
  argocd login --port-forward-namespace argocd localhost:8080 # TODO non-localhost
}

function local_port_forwrading(){
  kubectl port-forward svc/argocd-server -n argocd 8080:443
}

function echo_argocd_credentials() {
  echo "username/password:" 
  echo -n "admin/"
  kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d; echo
}

function bootstrap_argo_to_track_own_repo() {
  # assumed to be public
  repoURL=$(gh repo view --json url --jq .url)

  
}