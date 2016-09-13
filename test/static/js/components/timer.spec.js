import React from 'react';
import { mount, shallow } from 'enzyme'
import sinon from 'sinon'
import TestUtils from 'react-addons-test-utils'

import Timer from '../../../../web/static/js/components/timer';

describe("Timer", () => {


  const timer = mount(<Timer secondsRemaining="10"/>);
  it("displays the seconds remaining", () => {
    expect(timer.find("div").text()).to.be.equal("10")
  })

  console.log(timer.debug());

  // TODO check the tick method works


})
