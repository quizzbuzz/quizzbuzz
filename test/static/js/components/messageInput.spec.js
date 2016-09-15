import React from 'react';

import { mount, shallow } from 'enzyme'
import sinon from 'sinon'
import TestUtils from 'react-addons-test-utils'

import MessageInput from '../../../../web/static/js/components/messageInput';

describe('messageInput', () => {

  const messageInput = shallow(<MessageInput />)


  it('renders the chat input field', () => {
    expect(messageInput).to.have.length(1);
  })

})
