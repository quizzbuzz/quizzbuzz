import React from 'react';
import { mount, shallow } from 'enzyme'
import sinon from 'sinon'
import TestUtils from 'react-addons-test-utils'

import Lobby from '../../../../web/static/js/components/lobby';

describe("Lobby", () => {

  const componentWillMount = sinon.spy(Lobby.prototype, "componentWillMount")
  const configureChannel = sinon.spy(Lobby.prototype, "configureChannel")
  const lobby = shallow(<Lobby />);
  lobby.setState({username: "test1"});

  it('should call componentWillMount', () => {
    expect(componentWillMount.calledOnce).to.be.true;
  })

  it('should call configureChannel on componentWillMount', () => {
    expect(configureChannel.calledOnce).to.be.true;
  })


  it('Should give the user the single player option', () => {
    expect(lobby.contains("Single Player Game")).to.be.true;
  });

  it('Should give the user the 2 player option', () => {
    expect(lobby.contains("Two Player Game")).to.be.true
  });

  it('Should give the user the multiplayer option', () => {
    expect(lobby.contains("Quizz Party")).to.be.true
  });

  it('Should give the user the option to chat with other players', () => {
    expect(lobby.contains("Chat")).to.be.true
  });

  it("Shows the chat room when the 'Chat' button is clicked", () => {
    lobby.find('div.chat-button').simulate('click')
    expect(lobby.find("Chat")).to.have.length(1);
  });

  it('Renders the Game object when Single Player is chosen', () => {
    lobby.setState({channel: "one_player"});
    expect(lobby.find("SingleGame").prop("channel")).to.be.equal("one_player")
  })

  it('Renders the Game object when Two Player is chosen', () => {
    lobby.setState({channel: "two_player"});
    expect(lobby.find("Game").prop("channel")).to.be.equal("two_player")
  })

  it('Renders the Game object when Multiplayer is chosen', () => {
    lobby.setState({channel: "multiplayer"});
    expect(lobby.find("Game").prop("channel")).to.be.equal("multiplayer")
  })

  it('shows waiting for opponent when multiplayer is selected', () => {
    const mountedLobby = mount(<Lobby />);
    mountedLobby.setState({username: "test1", gameChoice:"multiplayer"});
    expect(mountedLobby.text()).to.equal("Waiting for Opponent");

  })

  const handleClick = sinon.spy(Lobby.prototype, "handleClick")

  it('onMessage should call sendMessage function', () => {
    const sendMessage = sinon.spy(Lobby.prototype, "sendMessage")
    const mountedLobby = mount(<Lobby />)
    mountedLobby.find('.chat-button').simulate('click')
    mountedLobby.find('form').simulate('submit')
    expect(sendMessage.calledOnce).to.be.true
  })

  it('onClick Single Player should call handleClick function', () => {
    const mountedLobby = mount(<Lobby />)
    mountedLobby.find('#single').simulate('click')
    expect(handleClick.called).to.be.true
  })

  it('onClick Two Player should call handleClick function', () => {
    const mountedLobby = mount(<Lobby />)
    mountedLobby.find('#two').simulate('click')
    expect(handleClick.called).to.be.true
  })

  it('onClick Quiz Party should call handleClick function', () => {
    const mountedLobby = mount(<Lobby />)
    mountedLobby.find('#multi').simulate('click')
    expect(handleClick.called).to.be.true
  })

  it('when chat-button is clicked toggleChast is called', () => {
    const toggelChat = sinon.spy(Lobby.prototype, "toggleChat")
    const mountedLobby = mount(<Lobby />)
    mountedLobby.find('.chat-button').simulate('click')
    expect(toggelChat.calledOnce).to.be.true
  })


})
