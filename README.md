# PHPBack - Docker, docker-compose and Kubernetes Helm chart

## Building

### Building and pushing the Docker image

It may not work this for you, unless you have my DockerHub credentials :)

```sh
docker build -t scretu/phpback:latest . && docker push scretu/phpback:latest
```

## Run locally

You can use Docker compose for this. Just run

```sh
docker-compose up
```

Visit <http://localhost>

### Building the Helm chart

```sh
helm dependency update ./phpback && helm package --version `grep version phpback/Chart.yaml | awk '{print $2}'` ./phpback
```

## Deploy it in minikube

### Start minikube (with k8s version 1.13.0 for example)

```sh
minikube --memory 12228 --cpus 2 --kubernetes-version=1.13.0 start
```

### Prepare Helm and deploy

```sh
helm upgrade --install phpback phpback-`grep version phpback/Chart.yaml | awk '{print $2}'`.tgz
minikube service phpback
```

Enjoy!
