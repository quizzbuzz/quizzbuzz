import socket from "../socket"
import React from 'react'
import Timer from './timer'

class Game extends React.Component {
  constructor () {
    super()
    this.state = {
      activeRoom: "single-player",
      question: '',
      options: '',
      answer: '',
      time: 10,
      score: 0,
      gameEnd: false,
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
       this.setState({question: payload.question.body, options: payload.question.options, answer: payload.question.answer})
     })
    channel.on("end_game", payload => {
      this.setState({gameEnd: true, options: false});
     })
  }

  componentWillMount() {
    this.configureChannel(this.state.channel)
  }

  handleClick(event) {
    const answer = event.currentTarget.textContent
    this.checkAnswer(answer)
    this.state.channel.push("answer", {score: this.state.score, user_id: this.state.user_id})
  }

  checkAnswer(answer) {
    if (this.state.answer === answer) {
      this.state.score += this.refs.timer.state.secondsRemaining
    }
  }
  handleTimeOut() {
    console.log(this.state.score);
    this.state.channel.push("answer", {score: this.state.score, user_id: this.state.user_id})
  }

  render() {
    if (this.state.gameEnd === true) {
      return (
        <div>
          <h3 className="gameOver"> Game Over! </h3>
          <h4 className="finalScore">Final Score: {this.state.score} / 100</h4>
          <form action="/game">
            <button id="play" className="sizing">Play</button>
          </form>
        </div>
      )
    }
    if (this.state.options && this.state.gameEnd === false) {
      return (
        <div>
          <div className="question">{this.state.question}</div>
          <Timer ref="timer" secondsRemaining={this.state.time} question={this.state.question} onZero={this.handleTimeOut.bind(this)}/>
          {this.state.options.map((option, index )=> {
            return <button className="sizing" key={index} onClick={this.handleClick.bind(this)}>{option}</button>
          })}
          <div className="score">Score: {this.state.score}</div>
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
