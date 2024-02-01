## Websockets

Websockets & API endpoints share the same JSON data structure.

### Notifications
Logged in users may subscribe to the `NotificationsChannel`. 

> Authenticate with API token
```javascript

let ws = new WebSocket('wss://api.tvtalk.app/websocket');

ws.onopen = function(){
  //Subscribe to the channel
  let identifier = {
    "channel": "NotificationsChannel",
    "token": localStorage.getItem('token')
  }
  let payload = {
    "command": "subscribe",
    "identifier": JSON.stringify(identifier)
  }
  ws.send(JSON.stringify(payload));
}

ws.onmessage = function(msg) {
  let json = JSON.parse(msg.data)
  console.log(json)
}

ws.onclose = function(msg) {
  let json = JSON.parse(msg.data)
  console.log(json)
}
```

---


## Comments and Message Threads
`Shows`, `Stories`, and `Comments` can be subscribed to through the `CommentsChannel`.

> `Shows`
```javascript
let ws = new WebSocket('wss://api.tvtalk.app/websocket');

ws.onopen = function(){
  //Subscribe to the channel
  let identifier = {
    "channel": "CommentsChannel",
    "tms_id": "EP007629560064"
  }
  let payload = {
    "command": "subscribe",
    "identifier": JSON.stringify(identifier)
  }
  ws.send(JSON.stringify(payload));
}

ws.onmessage = function(msg) {
  let json = JSON.parse(msg.data)
  console.log(json)
}

ws.onclose = function(msg) {
  let json = JSON.parse(msg.data)
  console.log(json)
}
```


> `Stories`
```javascript
let ws = new WebSocket('wss://api.tvtalk.app/websocket');

ws.onopen = function(){
  //Subscribe to the channel
  let identifier = {
    "channel": "CommentsChannel",
    "story_id": 849540
  }
  let payload = {
    "command": "subscribe",
    "identifier": JSON.stringify(identifier)
  }
  ws.send(JSON.stringify(payload));
}

ws.onmessage = function(msg) {
  let json = JSON.parse(msg.data)
  console.log(json)
}

ws.onclose = function(msg) {
  let json = JSON.parse(msg.data)
  console.log(json)
}
```

> `Message Threads (Comments & Sub Comments)`

```
  Comment <- SubComment <- SubComment
```
Always subscribe to the top-level `Comment`. You do not need to subscribe to individual `SubComments`. 

However you will need to ensure your `onmessage` callback can handle both `Comment` and `SubComment` data.

Look for the JSON attribute `"type"` which will have a value of `comment` or `sub_comment`.

```javascript
let ws = new WebSocket('wss://api.tvtalk.app/websocket');

ws.onopen = function(){
  //Subscribe to the channel
  let identifier = {
    "channel": "CommentsChannel",
    "comment_id": 123
  }
  let payload = {
    "command": "subscribe",
    "identifier": JSON.stringify(identifier)
  }
  ws.send(JSON.stringify(payload));
}

ws.onmessage = function(msg) {
  let json = JSON.parse(msg.data)
  console.log(json)
}

ws.onclose = function(msg) {
  let json = JSON.parse(msg.data)
  console.log(json)
}
```
