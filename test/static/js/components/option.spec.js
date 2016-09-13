import React from 'react';
import { mount, shallow } from 'enzyme'
import sinon from 'sinon'
import TestUtils from 'react-addons-test-utils'

import Option from '../../../../web/static/js/components/option';

describe("Option", () => {

  const handleClick = sinon.spy();
  const option = shallow(<Option key="1" option="Answer A" onClick={handleClick}/>);

  it("Allows the user to choose an answer option", () => {
    expect(option.find("button").text()).to.be.equal("Answer A")
  });

  it('should call handleClick on a button click', () => {
    option.find('button').simulate('click')
    expect(handleClick.calledOnce).to.be.true
  });

});
