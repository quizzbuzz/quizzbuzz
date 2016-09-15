import React from 'react'

class Message extends React.Component {
  render() {
    return (
      <div>
        <div>{this.props.data.username}: {this.props.data.text}</div>
      </div>
    )
  }
}

export default Message
