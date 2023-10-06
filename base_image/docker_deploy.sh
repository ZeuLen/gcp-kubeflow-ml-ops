$image_name = "kubeflow-ml-ops"
$registry_url = "eu.gcr.io/hdci-media-scale-sandbox/ml-ops"

docker build --no-cache  -t $image_name .
docker tag $image_name $registry_url/$image_name
docker push $registry_url/$image_name