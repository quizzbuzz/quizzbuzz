import React from 'react'

class SingleGameover extends React.Component {

  render() {
    return (
      <div>
        <h3 className="gameOver" id="title">Game Over!</h3>
        <h4 className="finalScore" id="sub-title">Final Score: {this.props.finalScore} / 100</h4>
        <form id="play-form" action="/game">
          <button id="play" className="sizing">Play Again</button>
        </form>
      </div>
    )
  }

}

export default SingleGameover
