import React from 'react'
import socket from "../socket"

class Chat extends React.Component {
  handleMessageSubmit(message) {
    this.props.onSendMessage(message)
  }
  render() {
    return (
      <div>
        <MessageInput onMessageSubmit={this.handleMessageSubmit.bind(this)}/>
        {this.props.messages.map(message => {
          return <Message data={message} />
        })}
      </div>
    )
  }
}


class Message extends React.Component {
  render() {
    return (
      <div>
        <div>{this.props.data.text}</div>
        <div>{this.props.data.date}</div>
      </div>
    )
  }
}

class MessageInput extends React.Component {
  handleSubmit(event) {
    event.preventDefault()
    const text = this.refs.text.value.trim()
    const date = new Date().toLocaleTimeString()
    this.refs.text.value = ""
    this.props.onMessageSubmit({text: text, date: date})
  }
  render() {
    return (
      <form onSubmit={this.handleSubmit.bind(this)}>
        <input type="text" ref="text"/>
      </form>
    )
  }
}

export default Chat
