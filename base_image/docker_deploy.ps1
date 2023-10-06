$image_name="kubeflow-base-image"
$registry_url="gcr.io/cdp-developers-developer-5/retailmedia-modeling"

docker build --no-cache  -t ${image_name} .
docker tag ${image_name} ${registry_url}/${image_name}
docker push ${registry_url}/${image_name}