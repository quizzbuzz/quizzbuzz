import socket from "../socket"
import React from 'react'

const rooms = ["general", "mix", "ecto", "plug", "elixir", "erlang"]

class Dashboard extends React.Component {
  constructor () {
    super()
    this.state = {
      activeRoom: "general",
      answers: [],
      channel: socket.channel("topic:general")
    }
  }
  handleRoomLinkClick(room) {
    const channel = socket.channel(`topic:${room}`)
    this.setState({activeRoom: room, answers: [], channel: channel})
    this.configureChannel(channel)
  }
  handleAnswerClick(answer) {
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
        <RoomList onRoomLinkClick={this.handleRoomLinkClick.bind(this)} rooms={rooms}/>
        <ActiveRoom room={this.state.activeRoom} answers={this.state.answers} onAnswerClick={this.handleAnswerClick.bind(this)}/>
      </div>
    )
  }
}


class RoomList extends React.Component {
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

class  RoomLink extends React.Component {
  handleClick() {
    this.props.onClick(this.props.name)
  }
  render() {
    return (
      <a style={{cursor: "pointer"}} onClick={this.handleClick.bind(this)}>{this.props.name}</a>
    )
  }
}

class ActiveRoom extends React.Component {
  render() {
    return (
      <div>
      <span>Welcome to the {this.props.room} game room!</span>
        <AnswerInput onAnswerClick={this.props.onAnswerClick}/>
        <AnswerList answers={this.props.answers}/>
      </div>
    )
  }
}

class AnswerList extends React.Component {
  render() {
    return (
      <div>
        {this.props.answers.map((answer, index) => {
          return <Answer key={index} data={answer} />
        })}
      </div>
    )
  }
}

class Answer extends React.Component {
  render() {
    return (
      <div>
        <div>{this.props.data.text}</div>
        <div>{this.props.data.date}</div>
      </div>
    )
  }
}

class AnswerInput extends React.Component {
  handleClick(event) {
    let answer = event.currentTarget.textContent
    let date = (new Date()).toLocaleTimeString()
    this.props.onAnswerClick({text: answer, date: date})
  }
  render() {
    return <div>
      <button onClick={this.handleClick.bind(this)}>A</button>
      <button onClick={this.handleClick.bind(this)}>B</button>
      <button onClick={this.handleClick.bind(this)}>C</button>
      <button onClick={this.handleClick.bind(this)}>D</button>
      </div>
  }
}

export default Dashboard
