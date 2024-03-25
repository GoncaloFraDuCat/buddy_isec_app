// app/views/messages/create.js.erb
var message = "<%= j render(@message) %>";
$('#messages').append(message);
