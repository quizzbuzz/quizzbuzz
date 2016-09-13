import socket from "../socket"
import React from 'react'
import Game from './game'

class Lobby extends React.Component {
  constructor () {
    super()
    this.state = {
      gameChoice: '',
      channel: '',
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
          <button className="sizing" onClick={this.handleClick.bind(this)} name="join_one_player_game">Single Player</button>
          <button className="sizing" onClick={this.handleClick.bind(this)} name="join_two_player_queue">Multiplayer</button>
        </div>
      )

    }
  }

}


export default Lobby
