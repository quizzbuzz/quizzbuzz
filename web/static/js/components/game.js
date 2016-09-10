import socket from "../socket"
import React from 'react'

class Game extends React.Component {
  constructor () {
    super()
    this.state = {
      activeRoom: "single-player",
      question: '',
      options: '',
      channel: socket.channel("game:single-player")
    }
  }
  configureChannel(channel) {
    channel.join()
      .receive("ok", (payload) => {
        this.setState({question: payload.question.body, options: payload.question.options})
        console.log(`Succesfully joined the ${this.state.activeRoom} game room.`)
      })
      .receive("error", () => { console.log(`Unable to join the ${this.state.activeRoom} game room.`)}
    )
    channel.on("new_question", payload => {
       this.setState({question: payload.question.body, options: payload.question.options})
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
          <div className="question">{this.state.question}</div>
          {this.state.options.map((option, index )=> {
            return <button className="sizing" key={index} onClick={this.handleClick.bind(this)}>{option}</button>
          })}
        </div>
      )
    }
    return <div></div>
  }

}

export default Game
