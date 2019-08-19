
TF_SERVING_URL=$1

[[  -z "$TF_SERVING_URL" ]] && echo "Pass in the new TF_SERVING_URL value" && exit 1
echo "TF_SERVING_URL=$TF_SERVING_URL"
# '"$TF_SERVING_URL"'
sed -i '' 's,^ARG TF_URL=.*,'"ARG TF_URL=$TF_SERVING_URL"',' Dockerfile.centos7
sed -i '' 's,^ARG TF_URL=.*,'"ARG TF_URL=$TF_SERVING_URL"',' Dockerfile.ubi7
sed -i '' 's,^ARG TF_URL=.*,'"ARG TF_URL=$TF_SERVING_URL"',' Dockerfile.ubi8
sed -i '' 's,^ARG TF_URL=.*,'"ARG TF_URL=$TF_SERVING_URL"',' Dockerfile.fedora29
sed -i '' 's,^ARG TF_URL=.*,'"ARG TF_URL=$TF_SERVING_URL"',' Dockerfile.fedora30

