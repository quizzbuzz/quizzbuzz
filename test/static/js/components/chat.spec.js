import React from 'react';

import { mount, shallow } from 'enzyme'
import sinon from 'sinon'
import TestUtils from 'react-addons-test-utils'

import Chat from '../../../../web/static/js/components/chat';

describe('Chat', () => {

  it("returns a blank chat window if no messages have been sent", () =>  {
    const chat = shallow(<Chat messages={[{text: "", username: ""}]}/>);
    expect(chat.find('Message')).to.have.length(1);
  });

  it("returns a message in chat window if a message has been sent", () =>  {
    const chat = mount(<Chat messages={[{text: "This is the first message", username: "test1"}]}/>);
    expect(chat.find('Message').text()).to.be.equal("test1: This is the first message");
  });

  it('assigns any message input to the current user', () => {
    const chat = mount(<Chat messages={[{text: "This is the first message", username: "test1"},]} username="test2"/>);
    expect(chat.find("MessageInput").prop("username")).to.be.equal("test2");
  });


})
