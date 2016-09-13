import React from 'react';
import { mount, shallow } from 'enzyme'
import sinon from 'sinon'
import TestUtils from 'react-addons-test-utils'

import Option from '../../../../web/static/js/components/option';

describe("Option", () => {

  const wrapper = shallow(<Option key="1" option="Answer A"/>)

  it("Allows the user to choose an answer option", () => {
    expect(wrapper.find("button").text()).to.be.equal("Answer A")
  })


})
