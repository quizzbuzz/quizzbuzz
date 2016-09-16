import socket from "../socket"
import React from 'react'
import Timer from './timer'
import Question from './question'
import Gameover from './multiGameover'
import Option from './option'
import Chat from './chat'

class Game extends React.Component {
  constructor (props) {
    super(props)
    this.state = {
      question: '',
      options: '',
      answer: '',
      time: 10,
      messages: [],
      waiting: false,
      score: 0,
      chatVisible: false,
      gameEnd: false,
      outcome: '',
      username: this.props.username,
      channel: socket.channel(this.props.channel),
    }
  }
  configureChannel(channel) {
    channel.join()
    channel.push("ready")
    channel.on("new_question", payload => {
       this.setState({question: payload.question.body, options: payload.question.options, answer: payload.question.answer, waiting: false})
     })
    channel.on("waiting", payload => {
      this.setState( {waiting: true} )
    })
    channel.on("message", payload => {
      this.setState({messages: this.state.messages.concat([payload.body])})
    })
    channel.on("end_game", payload => {
      this.setState({gameEnd: true, options: false, outcome: payload.result});
     })
    channel.on("user_left", payload => {
      this.setState({userLeft: payload.deserter, options: false});
    })
  }

  componentWillMount() {
    this.configureChannel(this.state.channel)
  }

  handleClick(event) {
    this.setState({options: '', waiting: true})
    const answer = event.currentTarget.textContent
    this.checkAnswer(answer)
    this.state.channel.push("answer", {score: this.state.score})
  }

  checkAnswer(answer) {
    if (this.state.answer === answer) {
      this.state.score += this.refs.timer.state.secondsRemaining
    }
  }

  toggleChat() {
    this.setState({chatVisible: !this.state.chatVisible});
  }

  handleTimeOut() {
    this.state.channel.push("answer", {score: this.state.score})
  }

  sendMessage(message) {
    this.state.channel.push("message", {body: message})
  }

  render() {
    if (this.state.gameEnd === true) {
      return (
        <div>
          <Gameover finalScore={this.state.score} outcome={this.state.outcome} />
          <div id="chat">
            <div className="chat-button" onClick={this.toggleChat.bind(this)}>Chat</div>
            {this.state.chatVisible ? <Chat username={this.state.username} messages={this.state.messages} onSendMessage={this.sendMessage.bind(this)}/> : null }
          </div>
        </div>
      )
    } else if (this.state.userLeft) {
      return (
        <div>
          <div id="sorry" className="sub-title"><p>Sorry, {this.state.userLeft} has left the game</p>
          <form action="/game">
            <button id="play" className="sizing">Play Again</button>
          </form>
          </div>
        </div>
      )
    } else if (this.state.options) {

      return (
        <div className="gamepage">
          <div className="question-pane"><Question question={this.state.question} /></div>

          <div className="timerandscore">

          <Timer ref="timer" secondsRemaining={this.state.time} question={this.state.question} onZero={this.handleTimeOut.bind(this)}/>

          <div className="score">Score: {this.state.score}</div>

          </div>

          <div className="options">

          {this.state.options.map((option, index )=> {
            return <Option key={index} index={index} onClick={this.handleClick.bind(this)} option={option}/>
          })}
          </div>
          <div id="chat">
            <div className="chat-button" onClick={this.toggleChat.bind(this)}>Chat</div>
            {this.state.chatVisible ? <Chat username={this.state.username} messages={this.state.messages} onSendMessage={this.sendMessage.bind(this)}/> : null }
          </div>
        </div>
      )
    } else if(this.state.waiting) {

      return (
        <div>
        <div id="wait">Waiting for Opponent
        <img src={'http://www.mytreedb.com/uploads/mytreedb/loader/ajax_loader_red_256.gif'} /></div>
          <div id="chat">
            <div className="chat-button" onClick={this.toggleChat.bind(this)}>Chat</div>
            {this.state.chatVisible ? <Chat username={this.state.username} messages={this.state.messages} onSendMessage={this.sendMessage.bind(this)}/> : null }
          </div>
        </div>
      )

    }  else {
      return <div></div>
    }
  }

  componentWillUnmount() {
    this.state.channel.leave();
  }

}


export default Game
