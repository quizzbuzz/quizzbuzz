import React from 'react';
import { mount, shallow } from 'enzyme'
import sinon from 'sinon'
import TestUtils from 'react-addons-test-utils'

import Gameover from '../../../../web/static/js/components/singleGameover';

describe('Gameover', () => {

  const gameover = shallow(<Gameover finalScore="90"/>);

  it('tells the user that the game has finished', () => {
    expect(gameover.contains("Game Over!")).to.be.true;
  })

  it('tells the user their score', () => {
    expect(gameover.find("h4").text()).to.be.equal("Final Score: 90 / 100");
  })

  it('gives the user the option to play again', () => {
    expect(gameover.find("form").text()).to.be.equal("Play");
  })

  it('returns the user to the game route when Play is clicked', () => {
    expect(gameover.find("form").prop("action")).to.be.equal("/game");
  });

})
