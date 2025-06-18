# My Notes for atest

## Planning
I knew I wanted Linux to do the work in so that was 1st step
In order to deploy the application to kubernetes cluster I needed kubernetes cluster
As I have used yaml's for deployments previously, I decided to take that approach this time as well.
I wanted to deploy a webapp that would also use the database connection and actually display it is some visual way.


## My Starting point
As I wanted to actually see the aplication working I had to set up a kubernetes cluster, where the deployment could run. For that I wanted to create a clean Ubuntu wsl. 
As I had previously used docker desktop to offer docker functionality to my wsl linuxes I decided to use the same approach. 
I created ubuntu 22.04 wsl which did not have any issues.
I then let copilot analyze the task readme and give me summary and key points to compare it with the thoughts that I had after reading through it myself. My direction was quite similar. During that reviewing I noticed I had missed the part about not needing to do the actual CI/CD system. So I removed that from plan. 


## Platform choice
In past 5 years I have mostly used ready and working kubernetes clusters in GCP. As I only have free account there now, and I did not want to depend on any paid components, which GCP has many. I probably would have used GCP doing the thing in more official/work related way.
I needed to learn about some alternatives. To get more ideas about other options I used copilot to list me some compact/local alternatives. Results showed Minikube, k3d and few more. I then did short research about Minikube and k3d to get the differences etc. Minikube offered as Pros the best kubernetes experience (more like real kubernetes) as Cons high resource usage and slower startup times. As I had used minikube atleast once during some training years ago, I decided to try it out.  


## Webapp 
In the beginning I looked into deploying a simple nginx iamge based webapp that just shows Hello from container in the webpage.
First yaml examples were in cooperation with copilot. When going through the yamls I noticed that this version did not have any interaction with the database, so I decided to make it more interesting and have actual communication between the app and db. So the final result was webapp that logged webapp visits to database and read the total visits and last visits from the database and displayed the info on the webpage.


## Platform preparation
created new linux wsl - ubuntu 22.04
forked the repo
connected wsl to docker desktop
Created a script to set up the local kubernetes cluster by installing minikube and kubectl (started minikube with --driver=docker)
enabled some addons for minikube: dashboard, metrics-server, to get the minikube dashboard for nice kubernetes cluster visualisation.


## Things that could be improved
CI/CD is currently just a deployment script that deploys the db and webapp. In a fancier way I would have possibly used something like ArgoCD that would track a git branch and allow syncing of components or have even auto sync enabled to do that.
In current dev setup the application wants kubectl port forwarding to show the page. Nicer way would be probably through an actual domain and not directly to the service of the deployment.
In current setup the Persistant volume that mysql used remains after the deployments are purged via kubectl delete.
db credentials etc I would read from gcp secret manager not have them in the code.

