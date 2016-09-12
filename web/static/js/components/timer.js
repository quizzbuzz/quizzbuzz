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
      this.props.onZero()
      clearInterval(this.interval);
    }
  }
  componentDidMount() {
    this.updateTimer();
  }
  componentWillUnmount() {
    clearInterval(this.interval);
  }
  componentWillUpdate(nextProps, nextState) {
    if(this.props.question !== nextProps.question) {
    clearInterval(this.interval);
    this.updateTimer();
    }
  }

  updateTimer(){
    this.setState({ secondsRemaining: this.props.secondsRemaining })
    this.interval = setInterval(this.tick.bind(this), 1000)
  }

  render() {
    return (
      <div>{this.state.secondsRemaining}</div>
    );
  }
}

export default Timer
