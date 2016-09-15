import React from 'react';
import Game from '../../../../web/static/js/components/singleGame';
import { mount, shallow } from 'enzyme'
import sinon from 'sinon'
import TestUtils from 'react-addons-test-utils'
import Option from '../../../../web/static/js/components/option'

describe('Game', () => {
    const componentWillMount = sinon.spy(Game.prototype, "componentWillMount")
    const configureChannel = sinon.spy(Game.prototype, "configureChannel")
    const wrapper = shallow(<Game channel="one-player"/>)
    const socket = sinon.stub(channel, "on").withArgs("new_question")
    wrapper.setState({channel: socket})
    console.log(wrapper.state());

  it('should render an empty div if no states have been set', () => {
    expect(wrapper.find('div').text()).to.be.empty
  })

  it('should call componentWillMount', () => {
    expect(componentWillMount.calledOnce).to.be.true
  })

  it('should call configureChannel on componentWillMount', () => {
    expect(configureChannel.calledOnce).to.be.true
    expect(configureChannel.calledWith(socket.channel("one-player"))).to.be.true
  })

  describe('Game ends', () => {
    it('should render SingleGameover', () => {
      wrapper.setState({gameEnd: true})
      expect(wrapper.children('SingleGameover')).to.have.length(1)
    })
  })

  describe('Option and question state have been set', () => {
    beforeEach(() => {
      wrapper.setState({gameEnd: false, options: ["A", "B", "C", "D"], question: 'this is a question', answer: "A"})
    })

    it('should render a question component when question is set', () => {
      expect(wrapper.find('Question').prop('question')).to.equal('this is a question')
    })

    it('should render a question when options are set', () => {
      expect(wrapper.children('Question')).to.have.length(1)
    })

    it('should render a four options when options are set', () => {
      expect(wrapper.children('Option')).to.have.length(4)
    })

    it('should render a timer when options are set', () => {
      expect(wrapper.children('Timer')).to.have.length(1)
    })

    it('when option is clicked handleClick is called', () => {
      const handleClick = sinon.spy(Game.prototype, "handleClick")
      const mountedGame = mount(<Game />)
      mountedGame.setState({options: ["A", "B", "C", "D"], question: 'this is a question', answer: "A"})
      mountedGame.find('button').at(0).simulate('click')
      expect(handleClick.calledOnce).to.be.true
    })

    it('when right answer is clicked score should not be zero', () => {
      const mountedGame = mount(<Game />)
      mountedGame.setState({options: ["A", "B", "C", "D"], question: 'this is a question', answer: "A"})
      mountedGame.find('button').at(0).simulate('click')
      expect(mountedGame.state('score')).not.equal(0)
      expect(mountedGame.state('score')).to.equal(10)
    })

    // it('onZero of timer function handleTimeOut is called', () => {
    //   mountedGame.setState({channel: stub})
    //   sinon.stub(channel, on).given("new_question")
    //                    .yields(this.setState({question: "new question",
    //                                           options: ["A", "B", "C", "D"],
    //                                           answer: "A",
    //                                           waiting: false})
    //   // const channel = sinon.spy(channel, "push")
    //   // mountedGame.setState({channel: sinon.stub()})
    //   // const channel = sinon.stub(socket, "channel").yieldsTo("push",)
    //   const handleTimeOut = sinon.spy(Game.prototype, "handleTimeOut")
    //   const mountedGame = mount(<Game />)
    //   mountedGame.setState({time: 0, options: ["A", "B", "C", "D"], question: 'this is a question', answer: "A"})
    //   console.log(mountedGame.find('Timer').prop('onZero'))
    //   expect(handleTimeOut.calledOnce).to.be.true
    // })

  })
});
