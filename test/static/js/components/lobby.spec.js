import React from 'react';
import { mount, shallow } from 'enzyme'
import sinon from 'sinon'
import TestUtils from 'react-addons-test-utils'

import Lobby from '../../../../web/static/js/components/lobby';

describe("Lobby", () => {

  const lobby = shallow(<Lobby />);


  it('Should give the user the single player option', () => {
    expect(lobby.contains("Single Player")).to.be.true
  });

  it('Should give the user the multiplayer option', () => {
    expect(lobby.contains("Multiplayer")).to.be.true
  });

  it('Renders the Game object when Single Player is chosen', () => {
    lobby.setState({channel: "single-player"});
    expect(lobby.find("Game").prop("channel")).to.be.equal("single-player")
  })

  it('Renders the Game object when Multiplayer is chosen', () => {
    lobby.setState({channel: "multiplayer"});
    expect(lobby.find("Game").prop("channel")).to.be.equal("multiplayer")
  })


  // TODO - Would like to test that when clicked the buttons then render the game element.

})
