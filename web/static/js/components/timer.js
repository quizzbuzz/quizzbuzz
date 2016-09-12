import React from 'react'

class Timer extends React.Component {
  constructor() {
    super()
    this.state = {
      secondsRemaining: 0
    }
  }
  tick() {
    this.setState({secondsRemaining: this.state.secondsRemaining - 1});
    if (this.state.secondsRemaining <= 0) {
      clearInterval(this.interval);
    }
  }
  componentDidMount() {
    this.setState({ secondsRemaining: this.props.secondsRemaining });
    this.interval = setInterval(this.tick.bind(this), 1000);
  }
  componentWillUnmount() {
    clearInterval(this.interval);
  }
  render() {
    return (
      <div>{this.state.secondsRemaining}</div>
    );
  }
}

export default Timer
