# diplom-kube

kubectl -n stage create secret generic yc-sadiplom-key --from-file=sadiplom-key.json=/home/maxn/.yckey/sadiplom-key.json
 kubectl -n stage create secret generic ssh-for-vm --from-file=id_rsa.pub=/home/maxn/.ssh/id_rsa.pub
yc managed-kubernetes cluster get-credentials diplom-test --external --kubeconfig ~/.kube/config_diplom-test

kubectl create namespace devops-tools

kubectl apply -f jenkins/service-account.yaml

SECRET_NAME=$(kubectl get serviceaccount jenkins-admin  -o=jsonpath='{.secrets[0].name}' -n devops-tools)


 sudo apt update
      sudo apt-get install docker-ce docker-ce-cli containerd.io docker-compose-plugin
      sudo apt-get install     ca-certificates     curl     gnupg     lsb-release
      sudo mkdir -p /etc/apt/keyrings
      echo   "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
       $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
     sudo apt-get install docker-ce docker-ce-cli containerd.io docker-compose-plugin
     sudo apt update
    sudo apt-get install docker-ce docker-ce-cli containerd.io docker-compose-plugin
     sudo usermod jenkins -aG docker
   
   20  sudo reboot
   
   22  curl -LO https://storage.googleapis.com/kubernetes-release/release/v1.20.11/bin/linux/amd64/kubectl
   23  chmod +x ./kubectl
   24  sudo mv ./kubectl /usr/local/bin/kubectl
   
  
