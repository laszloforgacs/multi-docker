docker build -t laszloforgacs/multi-client:latest -t laszloforgacs/multi-client:$SHA -f ./client/Dockerfile ./client
docker build -t laszloforgacs/multi-server -t laszloforgacs/multi-server:$SHA -f ./server/Dockerfile ./server
docker build -t laszloforgacs/multi-worker -t laszloforgacs/multi-worker:$SHA -f ./worker/Dockerfile ./worker
docker push laszloforgacs/multi-client:latest
docker push laszloforgacs/multi-server:latest
docker push laszloforgacs/multi-worker:latest

docker push laszloforgacs/multi-client:$SHA
docker push laszloforgacs/multi-server:$SHA
docker push laszloforgacs/multi-worker:$SHA

kubectl apply -f k8s
kubectl set image deployments/server-deployment server-deployment server=laszloforgacs/multi-server:$SHA
kubectl set image deployments/client-deployment client-deployment client=laszloforgacs/multi-client:$SHA
kubectl set image deployments/worker-deployment worker-deployment worker=laszloforgacs/multi-worker:$SHA