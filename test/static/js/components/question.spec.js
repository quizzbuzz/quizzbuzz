import React from 'react';
import { mount, shallow } from 'enzyme'
import sinon from 'sinon'
import TestUtils from 'react-addons-test-utils'

import Question from '../../../../web/static/js/components/question';

describe("Question", () => {

  const wrapper = shallow(<Question question="Is this test passing?"/>)

  it('presents a question to the user', () => {
    expect(wrapper.find("div").text()).to.be.equal("Is this test passing?");
  })

})
