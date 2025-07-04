#!/bin/bash
# Создание ключей и CSR для пользователей
openssl genrsa -out dev-user.key 2048
openssl req -new -key dev-user.key -out dev-user.csr -subj "/CN=dev-user/O=developers"

openssl genrsa -out manager-user.key 2048
openssl req -new -key manager-user.key -out manager-user.csr -subj "/CN=manager-user/O=managers"

# Подпись CSR
openssl x509 -req -in dev-user.csr -CA ~/.minikube/ca.crt -CAkey ~/.minikube/ca.key -CAcreateserial -out dev-user.crt -days 365
openssl x509 -req -in manager-user.csr -CA ~/.minikube/ca.crt -CAkey ~/.minikube/ca.key -CAcreateserial -out manager-user.crt -days 365

# Добавление в kubeconfig
kubectl config set-credentials dev-user --client-certificate=dev-user.crt --client-key=dev-user.key
kubectl config set-credentials manager-user --client-certificate=manager-user.crt --client-key=manager-user.key
