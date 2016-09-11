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
      channel: socket.channel("game:single-player"),
      user_id: (Math.floor(Math.random() * 10000) + 1).toString()
    }
  }
  configureChannel(channel) {
    channel.join()
      .receive("ok", (payload) => {
        console.log(`Succesfully joined the ${this.state.activeRoom} game room.`)
      })
      .receive("error", () => { console.log(`Unable to join the ${this.state.activeRoom} game room.`)}
    )
    channel.push("ready", {user_id: this.state.user_id })
    channel.on("new_question", payload => {
      console.log(payload);
       this.setState({question: payload.question.body, options: payload.question.options, answer: payload.question.answer})
     })
    channel.on("end_game", payload => {
      document.write(this.state.score)
     })
  }
  componentWillMount() {
    this.configureChannel(this.state.channel)
  }
  handleClick(event) {
    const answer = event.currentTarget.textContent
    this.checkAnswer(answer)
    this.state.channel.push("answer", {body: answer, user_id: this.state.user_id})
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
