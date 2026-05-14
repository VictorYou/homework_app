# Overview
This homework deploys a dummy app to eks, and when you curl it, it should return Hello, world!.
```hcl
curl http://k8s-default-helloapp-0a61f2990a-1930622708.us-west-1.elb.amazonaws.com/
```
or you can directly open in your browser: http://k8s-default-helloapp-0a61f2990a-1930622708.us-west-1.elb.amazonaws.com/

To build/deploy the app, you can build [https://homework-jenkins.ddns.net:30036/job/deploy_app/](http://13.57.252.126:8080/job/build-app/)
