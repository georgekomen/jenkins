This is a setup for running jenkins on top of kubernetes.

You would need to do that to eanble jenkins scale up and down depending on builds done


# eval $(minikube docker-env) // this enables you build your docker image right inside your Minikube virtual machine

# docker build -t jenkinsnode ~/Desktop/projects/jenkinsDocker/

# docker run --name jenkinsnode -d -p 49001:8080 -v ~/jenkins:/var/jenkins_home:z -t jenkinsnode // /var/jenkins_home from the container is mapped to jenkins/ directory from the current path on the host. Jenkins 8080 port is also exposed to the host as 49001

# docker exec -it --user root jenkinsnode bash -c "ls" // executing command inside docker container as root

# docker run --restart unless-stopped --name mailhog -p 1025:1025 -p 8025:8025 -d mailhog/mailhog // 1025 is the smtp port and 8025 the http port

# minikube kubectl apply -f master-jenkins-deployment.yaml // deploy to minikube 

- imagePullPolicy: Never // this is when running on minikube to disable minikube from trying to download the image