import socket from "../socket"
import React from 'react'

class Game extends React.Component {
  constructor () {
    super()
    this.state = {
      activeRoom: "single-player",
      question: '',
      options: '',
      channel: socket.channel("room:single-player")
    }
  }
  configureChannel(channel) {
    channel.join()
      .receive("ok", (payload) => {
        this.setState({question: payload.question, options: payload.options})
        console.log(`Succesfully joined the ${this.state.activeRoom} game room.`)
      })
      .receive("error", () => { console.log(`Unable to join the ${this.state.activeRoom} game room.`)}
    )
  }
  componentWillMount() {
    this.configureChannel(this.state.channel)
  }
  handleClick(event) {
    let answer = event.currentTarget.textContent
    this.state.channel.push("answer", {body: answer})
    console.log("clicked " + answer);
  }
  componentDidMount() {
    console.log(this.state.options);

  }
  render() {
    return (
      <div>
        <div>{this.state.question}</div>
        <button onClick={this.handleClick.bind(this)}>A</button>
        <button onClick={this.handleClick.bind(this)}>B</button>
        <button onClick={this.handleClick.bind(this)}>C</button>
        <button onClick={this.handleClick.bind(this)}>D</button>
      </div>
    )
  }

}

export default Game
