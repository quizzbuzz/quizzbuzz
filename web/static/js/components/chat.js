import React from 'react'
import socket from "../socket"
import Message from "./message"
import MessageInput from "./messageInput"

class Chat extends React.Component {
  handleMessageSubmit(message) {
    console.log(message);
    this.props.onSendMessage(message)
  }
  render() {
    return (
      <div className="chat">
        <div className="messages">
          {this.props.messages.map(message => {
            return <Message username={this.props.username} data={message} />
          })}
        </div>
        <MessageInput username={this.props.username} onMessageSubmit={this.handleMessageSubmit.bind(this)}/>
      </div>
    )
  }
}

export default Chat
