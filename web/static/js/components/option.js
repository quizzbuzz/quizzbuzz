import React from 'react'

class Option extends React.Component {

  render() {
    return <button className="sizing" key={this.props.index} onClick={this.props.onClick}>{this.props.option}</button>
  }

}

export default Option
