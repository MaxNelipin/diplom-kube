# diplom-kube

- Получаем kubeconfig для кластера
yc managed-kubernetes cluster get-credentials diplom-test --external --kubeconfig ~/.kube/config_diplom-test

- Авторизационные данные сервисных аккаунтов
yc iam key create --service-account-name sadiplom -o ~/.yckey/sadiplom-key.json

yc iam key create --service-account-name kube-admin -o ~/.yckey/kube-admin.json

yc iam key create   --service-account-name ingress-admin --output ~/.yckey/ingress-admin.json

- Секреты для Atlantis
kubectl -n stage create secret generic yc-sadiplom-key --from-file=sadiplom-key.json=/home/maxn/.yckey/sadiplom-key.json
kubectl -n stage create secret generic ssh-for-vm --from-file=id_rsa.pub=/home/maxn/.ssh/id_rsa.pub
kubectl -n stage create secret generic aws-sanetology-cred --from-file=credentials=/home/maxn/.aws/credentials
kubectl -n stage apply -f vendor/atlantis/charts/secrets.yaml


- Установка ingress
export HELM_EXPERIMENTAL_OCI=1 && \
cat ~/.yckey/ingress-admin.json | helm registry login cr.yandex --username 'json_key' --password-stdin && \
helm pull oci://cr.yandex/yc/yc-alb-ingress-controller-chart \
  --version=v0.1.0 \
  --untar && \
KUBECONFIG=/home/maxn/.kube/config_diplom-test helm install   --namespace yc-alb-ingress  --set folderId=b1gcetfa5k75tcn9b9lr   --set clusterId=cat10f0l4401vt8bq5ec   --set-file saKeySecretKey=/home/maxn/.yckey/ingress-admin.json yc-alb-ingress-controller ./yc-alb-ingress-controller-chart/


- Jenkins: SA, namecpace, секреты

kubectl create namespace devops-tools

kubectl apply -f jenkins/service-account.yaml

SECRET_NAME=$(kubectl get serviceaccount jenkins-admin  -o=jsonpath='{.secrets[0].name}' -n devops-tools)

kubectl get secrets $SECRET_NAME  -o=jsonpath='{.data.token}' -n devops-tools --kubeconfig /home/maxn/.kube/config_diplom-test | base64 -d

- Jenkins: необходимые компонеты для агента

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
   
  
