#My Notes for atest

## Platform choice
decided to try minikube for kubernetes cluster. Probably could have used GCP, but as components there cost money when running etc and I wanted to have something more compact yet still offering kubernetes capabilities.

## Platform preparation
created new linux wsl
forked the repo
connected wsl to docker desktop
installed minikube
installed kubectl
started minikube with --driver=docker
enabled some addons for minikube: dashboard, metrics-server, ingress