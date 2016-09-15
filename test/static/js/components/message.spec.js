import React from 'react';

import { mount, shallow } from 'enzyme'
import sinon from 'sinon'
import TestUtils from 'react-addons-test-utils'

import Message from '../../../../web/static/js/components/message';

describe('Message', () => {

  const message = shallow(<Message data={{username: "test1", text:"This is a message"}} />);

  it('renders message text', () => {
    expect(message.text()).to.be.equal("test1: This is a message");
  })


})
