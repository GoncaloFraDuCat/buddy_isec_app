import { Controller } from "@hotwired/stimulus";
import { createConsumer } from "@rails/actioncable";

export default class extends Controller {
  static values = { chatroomId: Number };
  static targets = ["messages"];

  connect() {
    this.subscription = createConsumer().subscriptions.create(
      { channel: "ChatroomChannel", id: this.chatroomIdValue },
      {
        received: data => this.#insertMessageAndScrollDown(data),
      }
    );

    this.#scrollDown();
  }

  #insertMessageAndScrollDown(data) {
    this.messagesTarget.insertAdjacentHTML("beforeend", data);
    this.#scrollDown();
  }

  #scrollDown() {
    const chatroom = document.querySelector(".container.chatroom");
    chatroom.scrollTo(0, chatroom.scrollHeight);
  }
  resetForm(event) {
    event.target.reset();
  }
  disconnect() {
    console.log("Unsubscribed from the chatroom");
    this.subscription.unsubscribe();
  }
}
