# app/channels/chat_channel.rb
class ChatChannel < ApplicationCable::Channel
  def subscribed
     # Assuming you have a way to identify the chatroom, e.g., by its ID
     stream_from "chatroom_#{params[:chatroom_id]}"
  end

  def speak(data)
     # Broadcast the message to the chatroom
     ActionCable.server.broadcast("chatroom_#{params[:chatroom_id]}", message: data['message'])
  end
 end
