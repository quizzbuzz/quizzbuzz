import React from 'react'

class Gameover extends React.Component {

  render() {
    return (
      <div>
        <h3 className="gameOver">Game Over!</h3>
        <h3 className="outcome">{this.props.outcome}</h3>
        <h4 className="finalScore">Your Score: {this.props.finalScore} / 100</h4>
        <form action="/game">
          <button id="play" className="sizing">Play Again</button>
        </form>
      </div>
    )
  }

}

export default Gameover
