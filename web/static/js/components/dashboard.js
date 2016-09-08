import React from 'react'
import socket from "../socket"

class Dashboard extends React.Components {
  getInitialState() {
    return ({
      activeRoom: "general",
      messages: [],
      channel: socket.channel("topic:general")
    })
  }
  handleRoomLinkClick(room) {
    const channel = socket.channel(`topic:${room}`)
    this.setState({activeRoom: room, messages: [], channel: channel})
    this.configureChannel(channel)
  }
  handleMessageSubmit(message) {
    this.state.channel.push("message", {body: message})
  }
  configureChannel(channel) {
    channel.join()
      .receive("ok", () => { console.log(`Succesfully joined the ${this.state.activeRoom} chat room.`) })
      .receive("error", () => { console.log(`Unable to join the ${this.state.activeRoom} chat room.`) })
    channel.on("message", payload => {
      this.setState({messages: this.state.messages.concat([payload.body])})
    })
  }
  componentDidMount() {
    this.configureChannel(this.state.channel)
  }
  render() {
    return (
      <div>
        <RoomList onRoomLinkClick={this.handleRoomLinkClick} rooms={rooms}/>
        <ActiveRoom room={this.state.activeRoom} messages={this.state.message} onMessageSubmit={this.handleMessageSubmit}/>
      </div>
    )
  }
}

const rooms = ["general", "mix", "ecto", "plug", "elixir", "erlang"]

class RoomList extends React.Components {
  render() {
    return (
      <div>
        {this.props.rooms.map(room => {
          return <span><RoomLink onClick={this.props.onRoomLinkClick} name={room} /> | </span>
        })}
      </div>
    )
  }
}

class  RoomLink extends React.Components {
  handleClick() {
    this.props.onClick(this.props.name)
  }
  render() {
    return (
      <a style={{cursor: "pointer"}} onClick={this.handleClick}>{this.props.name}</a>
    )
  }
}

class ActiveRoom extends React.Components {
  render() {
    return (
      <div>
      <span>Welcome to the {this.props.room} chat room!</span>
        <MessageInput onMessageSubmit={this.props.onMessageSubmit}/>
        <MessageList messages={this.props.messages}/>
      </div>
    )
  }
}

class MessageList extends React.Components{
  render() {
    return (
      <div>
        {this.props.messages.map(message => {
          return <Message data={message} />
        })}
      </div>
    )
  }
}

class Message extends React.Componets {
  render() {
    return (
      <div>
        <div>{this.props.data.text}</div>
        <div>{this.props.data.date}</div>
      </div>
    )
  }
}

class MessageInput extends React.Components{
  handleSubmit(e) {
    e.preventDefault()
    let text = React.findDOMNode(this.refs.text).value.trim()
    let date = (new Date()).toLocaleTimeString()
    React.findDOMNode(this.refs.text).value = ""
    this.props.onMessageSubmit({text: text, date: date})
  }
  render() {
    return (
      <form onSubmit={this.handleSubmit}>
        <input type="text" ref="text"/>
      </form>
    )
  }
}

export default Dashboard
