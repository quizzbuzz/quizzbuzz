import React from 'react';
import { mount, shallow } from 'enzyme'
import sinon from 'sinon'
import TestUtils from 'react-addons-test-utils'

import SingleGameover from '../../../../web/static/js/components/singleGameover';

describe('Gameover', () => {

  const singleGameover = shallow(<SingleGameover finalScore="90"/>);

  it('tells the user that the game has finished', () => {
    expect(singleGameover.contains("Game Over!")).to.be.true;
  })

  it('tells the user their score', () => {
    expect(singleGameover.find("h4").text()).to.be.equal("Final Score: 90 / 100");
  })

  it('gives the user the option to play again', () => {
    expect(singleGameover.find("form").text()).to.be.equal("Play Again");
  })

  it('returns the user to the game route when Play is clicked', () => {
    expect(singleGameover.find("form").prop("action")).to.be.equal("/game");
  });

})
