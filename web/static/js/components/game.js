import socket from "../socket"
import React from 'react'

class Game extends React.Component {
  constructor () {
    super()
    this.state = {
      activeRoom: "single-player",
      question: '',
      options: '',
      answer: '',
      score: 0,
      channel: socket.channel("game:single-player")
    }
  }
  configureChannel(channel) {
    channel.join()
      .receive("ok", (payload) => {
        this.setState({question: payload.question.body, options: payload.question.options, answer: payload.question.answer})
        console.log(`Succesfully joined the ${this.state.activeRoom} game room.`)
      })
      .receive("error", () => { console.log(`Unable to join the ${this.state.activeRoom} game room.`)}
    )
    channel.push("ready", {user_id: Math.floor(Math.random() * 10000) + 1 })
    channel.on("new_question", payload => {
       this.setState({question: payload.question.body, options: payload.question.options, answer: payload.question.answer})
     })
  }
  componentWillMount() {
    this.configureChannel(this.state.channel)
  }
  handleClick(event) {
    const answer = event.currentTarget.textContent
    this.checkAnswer(answer)
    this.state.channel.push("answer", {body: answer})
    console.log("clicked " + answer);
  }
  checkAnswer(answer) {
    if (this.state.answer === answer) {
      this.state.score++
    }
    console.log(this.state.score);
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

  componentWillUnmount() {
    this.state.channel.leave();
  }

}

export default Game
