# Overview
This deploys a dummy app to eks, and when you curl it, it should return Hello, world!.
```hcl
curl http://k8s-default-helloapp-0a61f2990a-1930622708.us-west-1.elb.amazonaws.com/
```
or you can directly open in your browser: http://k8s-default-helloapp-0a61f2990a-1930622708.us-west-1.elb.amazonaws.com/

To build/deploy the app, you can build http://13.57.252.126:8080/job/build-app/job/main/, you can login with admin / 123456

# Development process
After code commit, you can trigger build to test environment: http://13.57.252.126:8080/job/build-app/job/develop/

Then you can check if you can see 'Hello, world!' from http://k8s-default-helloapp-5adbaed677-846255158.us-east-1.elb.amazonaws.com

# CICD pipeline
Jenkins pipeline is used for CICD purpose. A docker image is built and pushed to docker registry, and kustomize is used to generate cluster specific manifest for deployment.
