const express = require('express');
const WebSocket = require('ws');

const app = express();
const wss = new WebSocket.Server({ port: 8080 });

let currentMetadata = {}; // Store current metadata

// WebSocket connection handler
wss.on('connection', function connection(ws) {
  // Send current metadata to newly connected clients
  ws.send(JSON.stringify(currentMetadata));

  // No need to handle incoming messages for this example
});

// Update metadata endpoint
app.post('/metadata', (req, res) => {
  // Update current metadata when request is received
  currentMetadata = req.body;
  // Broadcast metadata updates to all connected clients
  wss.clients.forEach(client => {
    if (client.readyState === WebSocket.OPEN) {
      client.send(JSON.stringify(currentMetadata));
    }
  });
  
  res.send('Metadata updated');
});

app.listen(3000, () => {
  console.log('Server running on port 3000');
});
