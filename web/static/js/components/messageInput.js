import React from 'react'

class MessageInput extends React.Component {
  handleSubmit(event) {
    event.preventDefault()
    const text = this.refs.text.value.trim()
    const date =
    this.refs.text.value = ""
    this.props.onMessageSubmit({text: text, username: this.props.username})
  }
  render() {
    return (
      <form onSubmit={this.handleSubmit.bind(this)}>
        <input placeholder="Chit chat..." className="messageInput" type="text" ref="text"/>
      </form>
    )
  }
}

export default MessageInput
