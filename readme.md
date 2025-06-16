## Design provisioning and deployment of a clusterized Kubernetes web app in the cloud.

Let's assume that there's a containerized application based on the nginx image from Docker Hub, deployed in a Kubernetes cluster. The application uses a MySQL database to store data.

The clusterized architecture looks like the following:

```mermaid
flowchart TD
	User[Browser] --> |https| Ingress[Kubernetes Ingress Controller]
	Ingress --> |http| Service[Kubernetes Service]
	Service --> |load balance| Pod1[Nginx Pod 1]
	Service --> |load balance| Pod2[Nginx Pod 2]
	Service --> |load balance| Pod3[Nginx Pod N...]
  
	Pod1 <--> DB[(Managed MySQL Database)]
	Pod2 <--> DB
	Pod3 <--> DB
  
	subgraph K8sCluster[Kubernetes Cluster]
		direction TB
		Ingress
		Service
		Pod1
		Pod2
		Pod3
		HPA[Horizontal Pod Autoscaler]
		HPA -.-> Pod1
		HPA -.-> Pod2
		HPA -.-> Pod3
	end

	subgraph WorkerNodes[Worker Nodes]
		direction LR
		Node1[Node 1]
		Node2[Node 2]
		Node3[Node N...]
	end

	K8sCluster --> WorkerNodes
```

Application and CI/CD flow:

```mermaid
flowchart TD
	Registry[Container Registry] --> |kubectl apply / helm deploy| K8s[Kubernetes Cluster]
	CI[CI Pipeline] --> |docker push| Registry
	K8s --> |schedule pods| Nodes[Worker Nodes]

	subgraph K8s[Kubernetes Cluster]
		direction TB
		Deploy[Deployment]
		SVC[Service]
		ING[Ingress]
		Deploy --> SVC
		SVC --> ING
	end
```

Infrastructure overview:

```mermaid
flowchart TD
	subgraph Cloud[Cloud Provider - AWS/GCP/Azure]
		subgraph VPC[Virtual Private Cloud]
			subgraph PublicSubnet[Public Subnet]
				LB[Load Balancer]
				NAT[NAT Gateway]
			end

			subgraph PrivateSubnet[Private Subnet]
				subgraph EKS[Managed Kubernetes Service]
					Master[Control Plane]
					Node1[Worker Node 1]
					Node2[Worker Node 2]
					Node3[Worker Node N...]
				end
				RDS[(Managed MySQL)]
			end
		end
	end

	Internet --> LB
	LB --> EKS
	EKS <--> RDS
	EKS --> NAT --> Internet
```

__Please create the infrastructure as code and Kubernetes manifests leaving out the actual CI and CD.__ You can pick the tools/languages and underlying cloud that you are most comfortable with. This is a practical task, so some IaC, Kubernetes YAML configs, and deployment scripts are required.

You are not expected to be thorough, but pick parts that make most sense to go into a code repository in your opinion. Making assumptions and cutting corners is fine. Please document the decision making related to that, especially around:
- Choice of managed Kubernetes service (EKS/GKE/AKS) or manual k8s installation
- Database deployment strategy (managed vs in-cluster)
- Networking and security approach
- Scaling and resource management
- Development vs production considerations

Using AI tools is fine, we can't really control it. But we would like to learn something about you from this experience, not about how AI solves the task. This is meant as a conversation starter and a chance for you to showcase something of your choice.

You can submit your code/comments as a pull request to this repository.
