import React from 'react';
import Game from '../../../../web/static/js/components/multiGame';
import { mount, shallow } from 'enzyme'
import sinon from 'sinon'
import TestUtils from 'react-addons-test-utils'
import Option from '../../../../web/static/js/components/option'

describe('Mulitplayer Game', () => {
    const componentWillMount = sinon.spy(Game.prototype, "componentWillMount")
    const configureChannel = sinon.spy(Game.prototype, "configureChannel")
    const wrapper = shallow(<Game channel="one-player"/>)

  it('should render an empty div if no states have been set', () => {
    expect(wrapper.find('div').text()).to.be.empty
  })

  it('should call componentWillMount', () => {
    expect(componentWillMount.calledOnce).to.be.true
  })

  it('should call configureChannel on componentWillMount', () => {
    expect(configureChannel.calledOnce).to.be.true
    // expect(configureChannel.calledWith(socket.channel("one-player"))).to.be.true
  })

  describe('Game ends', () => {
    it('should render SingleGameover', () => {
      wrapper.setState({gameEnd: true})
      expect(wrapper.children('Gameover')).to.have.length(1)
    })
  })

  describe('Waiting for opponent', () => {
    it('should render "Waiting for opponent"', () => {
      wrapper.setState({gameEnd: false, waiting: true})
      expect(wrapper.find('#wait')).to.have.length(1)
      expect(wrapper.find('#wait').text()).to.equal('Waiting for opponents')
    })

    it('should render the chat-button', () => {
      wrapper.setState({gameEnd: false, waiting: true})
      expect(wrapper.find('.chat-button')).to.have.length(1)
    })

    it('should render a chat box when chat-button is clicked', () => {
      wrapper.find('.chat-button').simulate('click')
      expect(wrapper.find('Chat')).to.have.length(1)
      wrapper.find('.chat-button').simulate('click')
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
      expect(wrapper.find('Question')).to.have.length(1)
    })

    it('should render a four options when options are set', () => {
      expect(wrapper.find('Option')).to.have.length(4)
    })

    it('should render a timer when options are set', () => {
      expect(wrapper.find('Timer')).to.have.length(1)
    })

    it('should render a chat button when options are set', () => {
      expect(wrapper.find('.chat-button')).to.have.length(1)
    })

    it('should render a chat box when chat-button is clicked', () => {
      wrapper.find('.chat-button').simulate('click')
      expect(wrapper.find('Chat')).to.have.length(1)
    })

    it('when chat-button is clicked toggleChat is called', () => {
      const toggelChat = sinon.spy(Game.prototype, "toggleChat")
      const mountedGame = mount(<Game />)
      mountedGame.setState({options: ["A", "B", "C", "D"]})
      mountedGame.find('.chat-button').simulate('click')
      expect(toggelChat.calledOnce).to.be.true
    })

    it('when option is clicked handleClick is called', () => {
      const handleClick = sinon.spy(Game.prototype, "handleClick")
      const mountedGame = mount(<Game />)
      mountedGame.setState({options: ["A", "B", "C", "D"]})
      mountedGame.find('button').at(0).simulate('click')
      expect(handleClick.calledOnce).to.be.true
    })

    it('when right answer is clicked score should not be zero', () => {
      const mountedGame = mount(<Game />)
      mountedGame.setState({options: ["A", "B", "C", "D"], answer: "A"})
      mountedGame.find('button').at(0).simulate('click')
      expect(mountedGame.state('score')).not.equal(0)
      expect(mountedGame.state('score')).to.equal(10)
    })

    it('onMessage should call sendMessage function', () => {
      const sendMessage = sinon.spy(Game.prototype, "sendMessage")
      const mountedGame = mount(<Game />)
      mountedGame.setState({options: ["A", "B", "C", "D"]})
      mountedGame.find('.chat-button').simulate('click')
      mountedGame.find('form').simulate('submit')
      expect(sendMessage.calledOnce).to.be.true
    })

    // it('onZero of timer function handleTimeOut is called', () => {
    //   const handleTimeOut = sinon.spy(Game.prototype, "handleTimeOut")
    //   const mountedGame = mount(<Game />)
    //   mountedGame.setState({time: 0, options: ["A", "B", "C", "D"]})
    //   expect(handleTimeOut.calledOnce).to.be.true
    // })

  })

  describe('Opponent has left the game', () => {

    beforeEach(() => {
      wrapper.setState({gameEnd: false, userLeft: "aga"})
    })

    it('should inform the user that an opponent has left the game', () => {
      expect(wrapper.find('.sorry').text()).to.equal("Sorry, aga has left the game")
    })

    it('should render a button to play again', () => {
      expect(wrapper.find('button').text()).to.equal("Play Again")
    })

    it('the button action should send to /game', () => {
      expect(wrapper.find('form').prop('action')).to.equal("/game")
    })

  })

});
