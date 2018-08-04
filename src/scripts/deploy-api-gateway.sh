rm -rf ./build/api-gateway && \
cp -r ./src/resources/api-gateway ./build/api-gateway && \
sam package \
  --template-file ./build/api-gateway/template.yaml \
  --s3-bucket <bucket> \
  --output-template-file ./build/api-gateway/packaged.yaml && \
sam deploy \
  --template-file ./build/api-gateway/packaged.yaml \
  --stack-name development-stack-api-gateway \
  --capabilities CAPABILITY_IAM && \
rm -rf ./build/api-gateway