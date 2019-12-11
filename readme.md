- This is a setup for running jenkins on top of kubernetes. You need this to enable jenkins scale up and down depending on builds done / load
- Inspired by : https://www.blazemeter.com/blog/how-to-setup-scalable-jenkins-on-top-of-a-kubernetes-cluster/

---
**procedure**
- `eval $(minikube docker-env)` // this enables you build your docker image right inside your Minikube virtual machine
- `docker build -t jenkinsnode:v1 ~/Desktop/projects/jenkinsDocker/`
- `kubectl apply -f master-jenkins-deployment.yaml` // deploy to minikube

---
**executing shell commands on kubernetes**
- `kubectl get pods` // to get pod name
- `kubectl exec -it <pod-name> ls /`

---
**new learnings on deployment**
- `imagePullPolicy: Never` // this is when running on minikube to disable minikube from trying to download the image

---
**running as docker container without kubenetes**
- `docker run --name jenkinsnode -d -p 49001:8080 -v ~/jenkins:/var/jenkins_home:z -t jenkinsnode` // /var/jenkins_home from the container is mapped to jenkins/ directory from the current path on the host. Jenkins 8080 port is also exposed to the host as 49001

**executing shell commands in a docker container**
- `docker exec -it --user root jenkinsnode bash -c "ls"` // executing command inside docker container as root

**running mailhog as docker container**
- `docker run --restart unless-stopped --name mailhog -p 1025:1025 -p 8025:8025 -d mailhog/mailhog` // 1025 is the smtp port and 8025 the http port

---
**access jenkins**
- run `kubectl get services` to get the internal ip and port jenkins is running on
- run `minikube ip` to get minikube ip (public ip == minikube ip)
- access jenkins in browser by : minikubeIp:port e.g. http://192.168.64.2:30919/

**jenkins slaves configuration**
- get master url => `kubectl cluster-info | grep master` to get kubernetes master ip and port
- get jenkins pod name => `kubectl get pods | grep jenkins`
- get jenkins pod url/ip => `kubectl describe pod <pod-name>` //e.g. IP:172.17.0.5
- navigate to 'Manage Jenkins -> Configure System -> Cloud -> Kubernetes' and setup things up, visit https://www.blazemeter.com/blog/how-to-setup-scalable-jenkins-on-top-of-a-kubernetes-cluster/ for more instructions