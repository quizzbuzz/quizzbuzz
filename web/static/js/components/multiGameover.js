import React from 'react'

class Gameover extends React.Component {

  render() {
    return (
      <div>
        <h3 className="gameOver" id="title">Game Over!</h3>
        <h3 className="outcome" id="sub-title">{this.props.outcome}</h3>
        <h4 className="finalScore" id="sub-title">Your Score: {this.props.finalScore} / 100</h4>
        <form action="/game">
          <button id="play" className="sizing">Play Again</button>
        </form>
      </div>
    )
  }

}

export default Gameover
