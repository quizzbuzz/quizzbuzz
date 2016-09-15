import React from 'react';
import { mount, shallow } from 'enzyme'
import sinon from 'sinon'
import TestUtils from 'react-addons-test-utils'

import Timer from '../../../../web/static/js/components/timer';

describe("Timer", () => {

  const componentDidMount = sinon.spy(Timer.prototype, "componentDidMount");
  const componentWillUpdate = sinon.spy(Timer.prototype, "componentWillUpdate");

  const timer = mount(<Timer secondsRemaining="10"/>);

  it('should call componentDidMount', () => {
    expect(componentDidMount.called).to.be.true;
  })

  it('should call componentDidMount', () => {
    expect(componentWillUpdate.called).to.be.true;
  })


  it("displays the seconds remaining", () => {
    expect(timer.find("div").text()).to.be.equal("10")
  })

})
