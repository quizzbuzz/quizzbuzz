import React from 'react'
import socket from "../socket"
import Message from "./message"
import MessageInput from "./messageInput"

class Chat extends React.Component {
  handleMessageSubmit(message) {
    this.props.onSendMessage(message)
  }
  render() {
    return (
      <div className="chat">
        <div ref="messagebox" className="messages">
          {this.props.messages.reverse().map((message, index) => {
            return <Message key={index} data={message} />
          })}
        </div>
        <MessageInput username={this.props.username} onMessageSubmit={this.handleMessageSubmit.bind(this)}/>
      </div>
    )
  }
}

export default Chat
