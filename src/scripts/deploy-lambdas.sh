for name in $(ls ./src/lambdas) ; do
  rm -rf ./build/$name-lambda.zip && \
  cp -r ./src/lambdas/$name ./build && \
  cp -r ./node_modules ./build/$name/node_modules && \
  cd ./build/$name && \
  zip -q -r ../$name-lambda.zip ./* && \
  cd ../.. && \
  aws s3 cp ./build/$name-lambda.zip s3://<bucket>/ && \
  sam package \
    --template-file ./build/$name/template.yaml \
    --s3-bucket <bucket> \
    --output-template-file ./build/$name/packaged.yaml && \
  sam deploy \
    --template-file ./build/$name/packaged.yaml \
    --stack-name development-stack-lambda-$name \
    --capabilities CAPABILITY_IAM || true && \
  rm -rf ./build/$name && \
  rm -rf ./src/resources/$name/packaged.yaml
done;