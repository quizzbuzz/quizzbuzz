import socket from "../socket"
import React from 'react'

const rooms = ["general", "mix", "ecto", "plug", "elixir", "erlang"]

class Dashboard extends React.Components {
  constructor (props) {
    super(props)
    this.state = {
      activeRoom: "general",
      answer: [],
      channel: socket.channel("topic:general")
    }
  }
  handleRoomLinkClick(room) {
    const channel = socket.channel(`topic:${room}`)
    this.setState({activeRoom: room, answers: [], channel: channel})
    this.configureChannel(channel)
  }
  handleAnswerSubmit(answer) {
    this.state.channel.push("answer", {body: answer})
  }
  configureChannel(channel) {
    channel.join()
      .receive("ok", () => { console.log(`Succesfully joined the ${this.state.activeRoom} game room.`) })
      .receive("error", () => { console.log(`Unable to join the ${this.state.activeRoom} game room.`) })
    channel.on("answer", payload => {
      this.setState({answers: this.state.answers.concat([payload.body])})
    })
  }
  componentDidMount() {
    this.configureChannel(this.state.channel)
  }
  render() {
    return (
      <div>
        <RoomList onRoomLinkClick={this.handleRoomLinkClick} rooms={rooms}/>
        <ActiveRoom room={this.state.activeRoom} answers={this.state.answer} onAnswerSubmit={this.handleAnswerSubmit}/>
      </div>
    )
  }
}


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
      <span>Welcome to the {this.props.room} game room!</span>
        <AnswerInput onAnswerSubmit={this.props.onAnswerSubmit}/>
        <AnswerList answers={this.props.answers}/>
      </div>
    )
  }
}

class AnswerList extends React.Components {
  render() {
    return (
      <div>
        {this.props.answers.map(answer => {
          return <Answer data={answer} />
        })}
      </div>
    )
  }
}

class Answer extends React.Componets {
  render() {
    return (
      <div>
        <div>{this.props.data.text}</div>
        <div>{this.props.data.date}</div>
      </div>
    )
  }
}

class AnswerInput extends React.Components {
  handleSubmit(e) {
    e.preventDefault()
    let text = ReactDOM.findDOMNode(this.refs.text).value.trim()
    let date = (new Date()).toLocaleTimeString()
    ReactDOM.findDOMNode(this.refs.text).value = ""
    this.props.onAnswerSubmit({text: text, date: date})
  }
  render() {
    return <button ref="text" onSubmit={this.handleSubmit}>A</button>
  }
}

export default Dashboard
