rm -rf ./build/dynamodb && \
cp -r ./src/resources/dynamodb ./build/dynamodb && \
sam package \
  --template-file ./build/dynamodb/template.yaml \
  --s3-bucket <bucket> \
  --output-template-file ./build/dynamodb/packaged.yaml && \
sam deploy \
  --template-file ./build/dynamodb/packaged.yaml \
  --stack-name development-stack-dynamodb \
  --capabilities CAPABILITY_IAM && \
rm -rf ./build/dynamodb