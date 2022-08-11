# diplom-kube

# Описание изменений:

## Atlantis
- Добавлены секреты для ssh ключа, yc sa для vpc, yc sa для s3 backend, ключи гитхаба
- terraformrc для обхода блокировок
- Серверный конфиг

## Ingress
- Установлен по инструкции Яндекса

## Kube-prometheus
- Добавлен ingress для grafana с адресом grafana.develug.ru


## Jenkins
- Сервисные аккаунты для разворачивания агентов и для разворачивания приложения.


# Ниже идут команды для справки 

## Получаем kubeconfig для кластера
```shell
yc managed-kubernetes cluster get-credentials diplom-test --external
```


## Авторизационные данные сервисных аккаунтов

```shell

kubectl create namespace devops-tools

kubectl create namespace stage

kubectl create namespace yc-alb-ingress

yc iam key create --service-account-name sadiplom -o ~/.yckey/sadiplom-key.json

yc iam key create --service-account-name kube-admin -o ~/.yckey/kube-admin.json

yc iam key create   --service-account-name ingress-admin --output ~/.yckey/ingress-admin.json
```


## Секреты для Atlantis

```shell
kubectl -n stage create secret generic yc-sadiplom-key --from-file=sadiplom-key.json=/home/maxn/.yckey/sadiplom-key.json
kubectl -n stage create secret generic ssh-for-vm --from-file=id_rsa.pub=/home/maxn/.ssh/id_rsa.pub
kubectl -n stage create secret generic aws-sanetology-cred --from-file=credentials=/home/maxn/.aws/credentials
echo -n "secret" | base64 -w 0
kubectl -n stage apply -f vendor/atlantis/secrets.yaml

```


## Установка ingress, atlantis, kube-prometheus
```shell
export HELM_EXPERIMENTAL_OCI=1 && \
cat ~/.yckey/ingress-admin.json | helm registry login cr.yandex --username 'json_key' --password-stdin && \
helm pull oci://cr.yandex/yc/yc-alb-ingress-controller-chart \
  --version=v0.1.0 \
  --untar && \
helm install   --namespace yc-alb-ingress  --set folderId=b1gcetfa5k75tcn9b9lr   --set clusterId=cat10f0l4401vt8bq5ec   --set-file saKeySecretKey=/home/maxn/.yckey/ingress-admin.json yc-alb-ingress-controller ./yc-alb-ingress-controller-chart/

qbec apply  stage

./build.sh kube-diplom.jsonnet
kubectl apply -f manifests/setup/
kubectl apply -f manifests/

```



## Jenkins: SA, секреты
```shell

kubectl apply -f jenkins/service-account.yaml

SECRET_NAME=$(kubectl get serviceaccount jenkins-admin  -o=jsonpath='{.secrets[0].name}' -n devops-tools)

kubectl get secrets $SECRET_NAME  -o=jsonpath='{.data.token}' -n devops-tools | base64 -d

SECRET_NAME=$(kubectl get serviceaccount jenkins-admin-stage  -o=jsonpath='{.secrets[0].name}' -n stage)   

kubectl get secrets $SECRET_NAME  -o=jsonpath='{.data.token}' -n stage | base64 -d

```
