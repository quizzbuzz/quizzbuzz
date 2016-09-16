import React from 'react';
import { mount, shallow } from 'enzyme'
import sinon from 'sinon'
import TestUtils from 'react-addons-test-utils'

import Timer from '../../../../web/static/js/components/timer';

describe("Timer", () => {
  const setState = sinon.spy(Timer.prototype, "setState")
  const updateTimer = sinon.spy(Timer.prototype, "updateTimer")
  const componentDidMount = sinon.spy(Timer.prototype, "componentDidMount");
  const componentWillUpdate = sinon.spy(Timer.prototype, "componentWillUpdate");

  const timer = mount(<Timer onZero="game function" question='this is a question' secondsRemaining="10"/>);

  it("displays the seconds remaining", () => {
    expect(timer.find("div").text()).to.be.equal("10")
  })

  it('should call componentDidMount', () => {
    expect(componentDidMount.called).to.be.true;
  })

  it('should call componentWillUpdate', () => {
    expect(componentWillUpdate.called).to.be.true;
  })

  it('should call timerUpdate on componentDidMount', () => {
    expect(updateTimer.called).to.be.true;
  })

  it('should call setState on updateTimer', () => {
    expect(setState.called).to.be.true;
  })

  it('should call componentWillUpdate with updateTimer', () => {
    timer.setProps({question: "this is another question" })
    expect(updateTimer.called).to.be.true;
  })

})
