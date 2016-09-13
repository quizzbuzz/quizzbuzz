import socket from "../socket"
import React from 'react'
import Timer from './timer'
import Question from './question'
import Gameover from './gameover'
import Option from './option'

class Game extends React.Component {
  constructor (props) {
    super(props)
    this.state = {
      question: '',
      options: '',
      answer: '',
      time: 10,
      waiting: false,
      score: 0,
      gameEnd: false,
      channel: socket.channel(this.props.channel),
      user_id: (Math.floor(Math.random() * 10000) + 1).toString()
    }
  }
  configureChannel(channel) {
    channel.join()
      .receive("ok", (payload) => {
        console.log(`Succesfully joined the game room.`)
      })
      .receive("error", () => { console.log(`Unable to join the game room.`)}
    )
    channel.push("ready", {user_id: this.state.user_id })
    channel.on("new_question", payload => {
       this.setState({question: payload.question.body, options: payload.question.options, answer: payload.question.answer, waiting: false})
     })
    channel.on("waiting", payload => { this.setState( {waiting: true} ) })
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
      return <Gameover finalScore={this.state.score} />
    } else if (this.state.options) {
      return (
        <div>
          <Question question={this.state.question} />
          <Timer ref="timer" secondsRemaining={this.state.time} question={this.state.question} onZero={this.handleTimeOut.bind(this)}/>
          {this.state.options.map((option, index )=> {
            return <Option key={index} index={index} onClick={this.handleClick.bind(this)} option={option}/>
          })}
          <div className="score">Score: {this.state.score}</div>
        </div>
      )
    } else if(this.state.waiting) {

      return <div>Waiting for opponent</div>

    } else {

      return <div></div>
    }
  }

  componentWillUnmount() {
    this.state.channel.leave();
  }

}


export default Game
