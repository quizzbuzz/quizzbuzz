import React from 'react';
import { mount, shallow } from 'enzyme'
import sinon from 'sinon'
import TestUtils from 'react-addons-test-utils'

import MultiGameover from '../../../../web/static/js/components/multiGameover';

describe('Gameover', () => {

  const multiGameover = shallow(<MultiGameover finalScore="90"/>);

  it('tells the user that the game has finished', () => {
    expect(multiGameover.contains("Game Over!")).to.be.true;
  })

  it('tells the user their score', () => {
    expect(multiGameover.find("h4").text()).to.be.equal("Your Score: 90 / 100");
  })

  it('tells the user when they have won a multiplayer game', () => {
    const multiGameoverWin = shallow(<MultiGameover finalScore="90" outcome="You Win!"/>);
    expect(multiGameoverWin.contains("You Win!")).to.be.true

  })

  it('tells the user when they have lost a multiplayer game', () => {
    const multiGameoverLose = shallow(<MultiGameover finalScore="90" outcome="You Lose!"/>);
    expect(multiGameoverLose.contains("You Lose!")).to.be.true
  })

  it('gives the user the option to play again', () => {
    expect(multiGameover.find("form").text()).to.be.equal("Play Again");
  })

  it('returns the user to the game route when Play is clicked', () => {
    expect(multiGameover.find("form").prop("action")).to.be.equal("/game");
  });

})
