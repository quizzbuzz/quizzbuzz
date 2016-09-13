import React from 'react';
import Game from '../../../../web/static/js/components/game';
import { mount, shallow } from 'enzyme'
import sinon from 'sinon'
import TestUtils from 'react-addons-test-utils'
import Option from '../../../../web/static/js/components/option'

describe('Game', () => {
    const wrapper = mount(<Game />)

  it('should render an empty div if no states have been set', () => {
    expect(wrapper.find('div').text()).to.be.empty
  })

  describe('states have been set', () => {
    beforeEach(() => {
      wrapper.setState({options: ["A", "B", "C", "D"], question: 'this is a question', answer: "A"})
    })

    it('should render a question component when question is set', () => {
      expect(wrapper.find('Question').prop('question')).to.equal('this is a question')
    })

    it('should render a question when options are set', () => {
      expect(wrapper.children('Question')).to.have.length(1)
    })

    it('should render a four options when options are set', () => {
      expect(wrapper.children('Option')).to.have.length(4)
    })

    it('should render a timer when options are set', () => {
      expect(wrapper.children('Timer')).to.have.length(1)
    })

    it('when right answer is clicked score should not be zero', () => {
      wrapper.find('button').at(0).simulate('click')
      expect(wrapper.state('score')).not.equal(0)
      expect(wrapper.state('score')).to.equal(10)
    })

  })

});
