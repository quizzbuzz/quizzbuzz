import socket from "../socket"
import React from 'react'
import Game from './game'

class Lobby extends React.Component {
  constructor () {
    super()
    this.state = {
      channel: '',
    }
  }

  handleClick(event) {
    const room = event.currentTarget.attributes.getNamedItem('name').value
    this.setState({channel: room })
  }

  render() {
    if(this.state.channel) {

      return (
        <Game channel={this.state.channel} />
        )

    } else {

      return (
        <div>
          <button className="sizing" onClick={this.handleClick.bind(this)} name="single-player">Single Player</button>
          <button className="sizing" onClick={this.handleClick.bind(this)} name="multiplayer">Multiplayer</button>
        </div>
      )

    }
  }

}


export default Lobby
