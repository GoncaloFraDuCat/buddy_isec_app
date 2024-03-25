// app/javascript/channels/chat_channel.js
App.chat = App.cable.subscriptions.create({ channel: "ChatChannel", chatroom_id: 1 }, {
  received: function(data) {
     // Update the chat UI with the new message

     var chatBox = document.getElementById('chat-box');
     chatBox.innerHTML += '<p>' + data.message + '</p>';
  }
 });
