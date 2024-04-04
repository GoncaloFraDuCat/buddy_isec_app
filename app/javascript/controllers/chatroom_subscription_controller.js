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
    const temp1 = document.createElement("div");
    temp1.innerHTML = data;
    const dataHTML = temp1.childNodes[0];
    const firstMessageSent = document.querySelector(".sent-by-mentor");

    if (firstMessageSent.dataset.userId !== dataHTML.dataset.userId) {
      // remove sent-by-mentor class from dataHTML
      dataHTML.classList.remove("sent-by-mentor");
      dataHTML.classList.add("sent-by-non-mentor");

      data = dataHTML.outerHTML;
    }

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
