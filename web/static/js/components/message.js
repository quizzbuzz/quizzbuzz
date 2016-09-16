import React from 'react'

class Message extends React.Component {
  render() {
    return (
      <div>
        <div className="chat-messages"><b>{this.props.data.username}</b>: {this.props.data.text}</div>
      </div>
    )
  }
}

export default Message
