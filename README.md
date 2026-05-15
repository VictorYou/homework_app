# Overview
This deploys a dummy app to eks, and when you curl it, it should return Hello, world!.
```hcl
curl http://k8s-default-helloapp-0a61f2990a-1930622708.us-west-1.elb.amazonaws.com/
```
or you can directly open in your browser: http://k8s-default-helloapp-0a61f2990a-1930622708.us-west-1.elb.amazonaws.com/

To build/deploy the app, you can build http://13.57.252.126:8080/job/build-app/job/main/, you can login with admin / 123456

App is deployed to an eks cluster.

App source code is placed under hello-app folder.

<img width="519" height="428" alt="image" src="https://github.com/user-attachments/assets/f1703966-b91e-4acb-adf3-ce1c019230ce" />


# Infrastructure
postgresql is maintained under terraform folder. To maintain production postgresql.
```hcl
export AWS_REGION=us-west-1
cd terraform/us-west-1
terraform workspace select prod
```
To maintain development postgresql.
```hcl
export AWS_REGION=us-east-1
cd terraform/us-east-1
terraform workspace select dev
```
# Development process
After code commit to develop branch, you can trigger build http://13.57.252.126:8080/job/build-app/job/develop/, which builds the image and deploys it to the test eks cluster.

Then you can check if you can see 'Hello, world!' from http://k8s-default-helloapp-5adbaed677-846255158.us-east-1.elb.amazonaws.com

Then you can merge code to main branch and build http://13.57.252.126:8080/job/build-app/job/main/, which builds and deploys to production environment.

# CICD pipeline
Jenkins pipeline is used for CICD purpose. A docker image is built and pushed to docker registry, and kustomize is used to generate cluster specific manifest for deployment.
