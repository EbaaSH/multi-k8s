#!/bin/bash
docker build -t ebaash/multi-client:latest -t ebaash/multi-client:$SHA -f ./client/Dockerfile.dev ./client
docker build -t ebaash/multi-server:latest -t ebaash/multi-server:$SHA -f ./server/Dockerfile.dev ./server
docker build -t ebaash/multi-worker:latest -t ebaash/multi-worker:$SHA -f ./worker/Dockerfile.dev ./worker
docker push ebaash/multi-client:latest
docker push ebaash/multi-client:$SHA
docker push ebaash/multi-server:latest
docker push ebaash/multi-server:$SHA
docker push ebaash/multi-worker:latest
docker push ebaash/multi-worker:$SHA
kubectl apply -f k8s
kubectl set image deployments/server-deployment server=ebaash/multi-server:$SHA
kubectl set image deployments/client-deployment client=ebaash/multi-client:$SHA
kubectl set image deployments/worker-deployment worker=ebaash/multi-worker:$SHA

# we define the two tag fo the images below:
# the SHA tag is for deploying the specific version of the image that was built in this build, and the latest tag is for deploying the latest version of the image that was built in this build. The latest tag is used for development purposes, while the SHA tag is used for production purposes.
# with SHA we can depug the errors if we have an error with the deployment, we can check the logs of the specific version of the image that was built in this build, and we can also rollback to a previous version of the image if needed.
# because SHA is the log of the current commit, we can use it to identify the specific version of the image that was built in this build. This is useful for debugging and for rolling back to a previous version of the image if needed.