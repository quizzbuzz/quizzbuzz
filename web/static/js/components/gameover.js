import React from 'react'

class Gameover extends React.Component {

  render() {
    return (
      <div>
        <h3 className="gameOver"> Game Over! </h3>
        <h4 className="finalScore">Final Score: {this.props.finalScore} / 100</h4>
        <form action="/game">
          <button id="play" className="sizing">Play</button>
        </form>
      </div>
    )
  }

}

export default Gameover
