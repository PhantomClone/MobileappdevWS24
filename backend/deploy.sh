#!/bin/bash

set -e

IMAGE_TAG=$(./gradlew -q printVersion)

APP_NAME="quarkus-backend"
DOCKER_IMAGE="localhost:5000/meinuser/$APP_NAME:$IMAGE_TAG"
K8S_NAMESPACE="default"
NODE_PORT=30080

echo "📦 Bauen des Quarkus-Projekts..."
./gradlew build -x test

echo "🐳 Erstellen des Docker-Images..."
docker build -f src/main/docker/Dockerfile.jvm -t $DOCKER_IMAGE .


echo "🐳 Push des Docker-Images..."
docker push $DOCKER_IMAGE

echo "🗄️ PostgreSQL Deployment erstellen..."
microk8s kubectl apply -f postgresql-deployment.yaml

echo "🚀 Kubernetes Deployment und Service erstellen..."
cat <<EOF | microk8s kubectl apply -f -
apiVersion: apps/v1
kind: Deployment
metadata:
  name: $APP_NAME
  labels:
    app: $APP_NAME
spec:
  replicas: 2
  selector:
    matchLabels:
      app: $APP_NAME
  template:
    metadata:
      labels:
        app: $APP_NAME
    spec:
      containers:
      - name: $APP_NAME
        image: $DOCKER_IMAGE
        ports:
        - containerPort: 8080
        env:
        - name: JAVA_OPTS_APPEND
          value: "-Dquarkus.http.host=0.0.0.0"
        - name: DB_HOST
          value: "postgresql"
        - name: DB_PORT
          value: "5432"
        - name: DB_NAME
          value: "quarkusdb"
        - name: DB_USER
          value: "quarkususer"
        - name: DB_PASSWORD
          value: "quarkuspassword"
        resources:
          requests:
            memory: "512Mi"
            cpu: "500m"
          limits:
            memory: "1Gi"
            cpu: "1000m"
EOF

cat <<EOF | microk8s kubectl apply -f -
apiVersion: v1
kind: Service
metadata:
  name: $APP_NAME
  labels:
    app: $APP_NAME
spec:
  selector:
    app: $APP_NAME
  ports:
  - protocol: TCP
    port: 8080
    targetPort: 8080
    nodePort: $NODE_PORT
  type: NodePort
EOF

echo "🕒 Warten, bis die Pods starten..."
microk8s kubectl rollout status deployment/$APP_NAME

NODE_IP=$(microk8s kubectl get nodes -o jsonpath='{.items[0].status.addresses[?(@.type=="InternalIP")].address}')

echo "✅ Deployment abgeschlossen!"
echo "🌐 Anwendung verfügbar unter: http://$NODE_IP:$NODE_PORT"
