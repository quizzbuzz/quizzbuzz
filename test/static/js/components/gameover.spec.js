import React from 'react';
import { mount, shallow } from 'enzyme'
import sinon from 'sinon'
import TestUtils from 'react-addons-test-utils'

import Gameover from '../../../../web/static/js/components/gameover';

describe('Gameover', () => {

  const wrapper = shallow(<Gameover finalScore="90"/>);

  it('tells the user that the game has finished', () => {
    expect(wrapper.contains("Game Over!")).to.be.true;
  })

  it('tells the user their score', () => {
    expect(wrapper.find("h4").text()).to.be.equal("Final Score: 90 / 100");
  })

  it('gives the user the option to play again', () => {
    expect(wrapper.find("form").text()).to.be.equal("Play");
  })

  // TODO Would like to add a check to make sure that clicking Play takes the user back to the play again page


})
