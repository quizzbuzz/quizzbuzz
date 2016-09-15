import socket from "../socket"
import React from 'react'
import SingleGame from './singleGame'
import MultiGame from './multiGame'
import Chat from './chat'

class Lobby extends React.Component {
  constructor () {
    super()
    this.state = {
      gameChoice: '',
      channel: '',
      username: '',
      messages: [],
      chatVisible: false,
      lobby: socket.channel("game_lobby")
    }
  }
  toggleChat() {
    this.setState({chatVisible: !this.state.chatVisible});
  }
  handleClick(event) {
    const room = event.currentTarget.attributes.getNamedItem('name').value
    this.setState({gameChoice: room })
    this.state.lobby.push(room)
  }
  configureChannel(lobby) {
    lobby.join()
    lobby.on("username", (payload) => {
      this.setState({username: payload.username})
    })
    lobby.on("game_ready", payload => {
        this.setState({channel: payload.game_id})
      })
    lobby.on("message", payload => {
      this.setState({messages: this.state.messages.concat([payload.body])})
    })
  }
  sendMessage(message) {
    this.state.lobby.push("message", {body: message})
  }
  componentWillMount() {
    this.configureChannel(this.state.lobby)
  }

  render() {
    if(this.state.channel.includes("one_player")) {

      return (
        <SingleGame channel={this.state.channel} />
        )

    } else if(this.state.channel) {

      return (
        <MultiGame channel={this.state.channel} />
        )

    } else if(this.state.gameChoice) {
      return (
        <div id="wait">Waiting for Opponent</div>
      )

    } else {

      return (
        <div className="lobby">
          <div id="chat">
            <div className="chat-button" onClick={this.toggleChat.bind(this)}>Chat</div>
            {this.state.chatVisible ? <Chat username={this.state.username} messages={this.state.messages} onSendMessage={this.sendMessage.bind(this)}/> : null }
          </div>
          <div className="game-buttons">
            <button className="sizing c-position" onClick={this.handleClick.bind(this)} name="join_one_player_game">Single Player Game</button><br/>
            <button className="sizing c-position" onClick={this.handleClick.bind(this)} name="join_two_player_queue">Two Player Game</button><br/>
            <button className="sizing c-position" onClick={this.handleClick.bind(this)} name="join_twenty_player_queue">Quizz Party</button>
          </div>
        </div>
      )

    }
  }

}


export default Lobby
