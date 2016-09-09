import socket from "../socket"
import React from 'react'

class Gaming extends React.Component {
  constructor () {
    super()
    this.state = {
      activeRoom: "general",
      questions: [],
      channel: socket.channel("topic:general")
    }
  }
  configureChannel(channel) {
    channel.join()
      .receive("ok", () => { console.log(`Succesfully joined the ${this.state.activeRoom} game room.`) })
      .receive("error", () => { console.log(`Unable to join the ${this.state.activeRoom} game room.`) })
    channel.on("answer", payload => {
      this.setState({answers: this.state.answers.concat([payload.body])})
    })
  }
  componentDidMount() {
    this.configureChannel(this.state.channel)
  }
  render() {
    return (
      <div>
      Game
      </div>
    )
  }
}

export default Gaming
