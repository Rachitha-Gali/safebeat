var connection = new WebSocket('ws://127.0.0.1:5005');

connection.onopen = function () {
  connection.send('Ping'); // Send the message 'Ping' to the server
};
