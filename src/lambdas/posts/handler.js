const AWS = require('aws-sdk');
const bluebird = require('bluebird');
const {
  ENV_AWS_REGION,
  ENV_AWS_ACCESS_KEY_ID,
  ENV_AWS_SECRET_ACCESS_KEY
} = process.env;
const TableName = 'PostsTable';

AWS.config.setPromisesDependency(bluebird);
AWS.config.update({
  region: ENV_AWS_REGION,
  accessKeyId: ENV_AWS_ACCESS_KEY_ID,
  secretAccessKey: ENV_AWS_SECRET_ACCESS_KEY
});

const db = new AWS.DynamoDB.DocumentClient()

function newModelId(subId){
  return `${((((new Date().getTime() - 1300000000000) * 64) + subId) * 512) + ((Math.floor(Math.random() * 512)) % 512)}`;
}

function creating(event) {
  return event && event.httpMethod === 'POST';
}

async function search() {
  const request = await db.scan({
    TableName
  }).promise();
  if (request.Count) {
    return request.Items;
  }
  return [];
}

async function create(Item) {
  Item.id = newModelId(4);
  await db.put({
    TableName,
    Item
  }).promise();
  return Item;
}

function onSuccess(statusCode, message, callback) {
  callback(null, {
    statusCode,
    body: JSON.stringify({ message }),
    headers: {
      "Access-Control-Allow-Origin": "https://www.example.com"
    }
  });
}

exports.execute = async function (event, _context, callback) {
  if (creating(event)) {
    const entity = await create(JSON.parse(event.body));
    onSuccess('201', entity, callback);
  } else {
    onSuccess('200', await search(), callback);
  }
}