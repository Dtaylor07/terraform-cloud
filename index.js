const AWS = require('aws-sdk');
const dynamodb = new AWS.DynamoDB.DocumentClient();

exports.handler = async (event) => {
  switch (event.httpMethod) {
    case 'GET':
      if (event.pathParameters && event.pathParameters.id) {
        return getTodo(event.pathParameters.id); // Use event.pathParameters.id
      } else {
        return getAllTodos();
      }
    case 'POST':
      return createTodo(JSON.parse(event.body)); // Parse the body
    case 'PUT':
      if (event.pathParameters && event.pathParameters.id) {
        return updateTodo(event.pathParameters.id, JSON.parse(event.body)); // Use event.pathParameters.id
      }
      return { statusCode: 400, body: JSON.stringify({ message: "ID is required" }) }; // Handle missing ID
    case 'DELETE':
      if (event.pathParameters && event.pathParameters.id) {
        return deleteTodo(event.pathParameters.id); // Use event.pathParameters.id
      }
      return { statusCode: 400, body: JSON.stringify({ message: "ID is required" }) }; // Handle missing ID
    default:
      return { statusCode: 405 }; // Method Not Allowed
  }
};

const getAllTodos = async () => {
  const params = {
    TableName: 'todos',
  };
  const data = await dynamodb.scan(params).promise();
  return { statusCode: 200, body: JSON.stringify(data.Items) };
};

const getTodo = async (id) => {
  const params = {
    TableName: 'todos',
    Key: { id },
  };
  const data = await dynamodb.get(params).promise();
  return { statusCode: 200, body: JSON.stringify(data.Item) };
};

const createTodo = async (todo) => {
  const params = {
    TableName: 'todos',
    Item: todo,
  };
  await dynamodb.put(params).promise();
  return { statusCode: 201 };
};

const updateTodo = async (id, todo) => {
  const params = {
    TableName: 'todos',
    Key: { id },
    UpdateExpression: 'set #name = :name, #description = :description',
    ExpressionAttributeNames: {
      '#name': 'name',
      '#description': 'description',
    },
    ExpressionAttributeValues: {
      ':name': todo.name,
      ':description': todo.description,
    },
  };
  await dynamodb.update(params).promise();
  return { statusCode: 200 };
};

const deleteTodo = async (id) => {
  const params = {
    TableName: 'todos',
    Key: { id },
  };
  await dynamodb.delete(params).promise();
  return { statusCode: 204 };
};
