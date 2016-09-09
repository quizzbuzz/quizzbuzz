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
        console.log(`Succesfully joined the ${this.state.activeRoom} game room.`)
      })
      .receive("error", () => { console.log(`Unable to join the ${this.state.activeRoom} game room.`)})
    channel.on("new_question", payload => {
        this.setState({question: payload.question, options: payload.options})
      })
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
    if (this.state.options) {
      return (
        <div>
          <div>{this.state.question}</div>
          {this.state.options.map((option, index )=> {
            return <button key={index} onClick={this.handleClick.bind(this)}>{option}</button>
          })}
        </div>
      )
    }
    return <div></div>
  }

}

export default Game
