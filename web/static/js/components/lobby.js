import socket from "../socket"
import React from 'react'
import Game from './game'
import Chat from './chat'

class Lobby extends React.Component {
  constructor () {
    super()
    this.state = {
      gameChoice: '',
      channel: '',
      messages: [],
      lobby: socket.channel("game_lobby")
    }
  }

  handleClick(event) {
    const room = event.currentTarget.attributes.getNamedItem('name').value
    this.setState({gameChoice: room })
    this.state.lobby.push(room)

  }
  configureChannel(lobby) {
    console.log(lobby);
    lobby.join()
      .receive("ok", (payload) => {
        console.log(`Succesfully joined the game lobby.`)
      })
      .receive("error", () => { console.log(`Unable to join the game lobby.`)
      })
      console.log(lobby);
    lobby.on("game_ready", payload => {
        this.setState({channel: payload.game_id})
        console.log(payload.game_id);
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
    if(this.state.channel) {

      return (
        <Game channel={this.state.channel} />
        )

    } else if(this.state.gameChoice) {
      return (
        <div>Waiting for Opponent</div>
      )

    } else {

      return (
        <div>
          <button className="sizing" onClick={this.handleClick.bind(this)} name="join_one_player_game">Single Player Game</button>
          <button className="sizing" onClick={this.handleClick.bind(this)} name="join_two_player_queue">Two Player Game</button>
          <button className="sizing" onClick={this.handleClick.bind(this)} name="join_twenty_player_queue">Quizz Party</button>
          <Chat messages={this.state.messages} onSendMessage={this.sendMessage.bind(this)}/>
        </div>
      )

    }
  }

}


export default Lobby
