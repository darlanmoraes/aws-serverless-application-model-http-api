# SAM Basic Application
This application is built on top of AWS SAM and runs over HTTP with AWS API Gateway, saving data to AWS DynamoDB. API's are defined using Swagger templates + AWS. For each resource, a Stack will be created(one for DynamoDB, one for Api Gateway, one for each function due a bug on CodeUri property o SAM).

To run this you will need a pair with AWS Access Key + AWS Access Key Id. To run it, you will need to replace the following values on code:

- ```<region>```
- ```<access_key>```
- ```<access_key_id>```
- ```<bucket>```
- ```<account_id>```

After it, you can run:
```
npm run deploy:dynamodb
npm run deploy:lambdas
npm run deploy:api-gateway
```

If you want to run a function locally, just execute as follows(I will try to simplify this):
```
rm -rf ./build/<function_folder>-run && \
mkdir -p ./build/<function_folder>-run/node_modules && \
cp -r ./src/lambdas/<function_folder>/* ./build/<function_folder>-run/ && \
cp -r ./node_modules/* ./build/<function_folder>-run/node_modules && \
echo '{}' | sam local invoke "CommentsLambda" --template ./build/<function_folder>-run/template.yaml && \
rm -rf ./build/<function_folder>-run
```

## Create Comment
```
curl -X POST -v \
-H 'Content-Type: application/json' \
-H 'Accept: application/json' \
-d "{
  \"comment\": \"Comment: $(uuid)\"
}" \
'https://hef048hujd.execute-api.<region>.amazonaws.com/development/comments'
```

## List Comments
```
curl -X GET -v \
-H 'Content-Type: application/json' \
-H 'Accept: application/json' \
'https://hef048hujd.execute-api.<region>.amazonaws.com/development/comments' | jq .
```

## Create Post
```
curl -X POST -v \
-H 'Content-Type: application/json' \
-H 'Accept: application/json' \
-d "{
  \"post\": \"Post: $(uuid)\"
}" \
'https://hef048hujd.execute-api.<region>.amazonaws.com/development/posts'
```

## List Posts
```
curl -X GET -v \
-H 'Content-Type: application/json' \
-H 'Accept: application/json' \
'https://hef048hujd.execute-api.<region>.amazonaws.com/development/posts' | jq .
```