import React from 'react';
import Game from '../../../../web/static/js/components/game';
import { mount, shallow } from 'enzyme'
import sinon from 'sinon'
import TestUtils from 'react-addons-test-utils'
import Button from '../../../../web/static/js/components/option'

describe('Game', () => {
  // const wrapper = shallow(<Game />)
  // stub(Game, "componentWillMount").returns({true});
  // const handleClick = sinon.spy();

//   const button = wrapper.find('div').childAt(3).simulate('click')
//   expect(handleClick.calledOnce).to.be.true;

  // const stub = sinon.stub(Game.prototype, "componentWillMount", function () {Game.setState(question: 'this is a question')})
// const wrapper = shallow(<Game />);
// sinon.stub(Game, 'configureChannel')
// expect(Game.prototype.componentWillMount().calledOnce).to.equal(true);
  const wrapper = mount(<Game />);
  //
  // it('should have four option buttons', () => {
  //   wrapper.setState({options: ["A", "B", "C", "D"]})
  //   expect(wrapper.children('button')).to.have.length(4);
  // });
  //
  // it('should have one question', () => {
  //   wrapper.setState({question: "this is a question"})
  //   expect(wrapper.children('div.question')).to.have.length(1);
  // });
  //
  it('should call handleClick on a button click', () => {
    // const game = TestUtils.renderIntoDocument(<Game />)
    wrapper.setState({options: ["A", "B", "C", "D"]})
    // const event = sinon.mock({
    //   currentTarget: {
    //     textContent: "C"
    //   }
    // })
    // const button = TestUtils.renderIntoDocument(<Button option='A'/>)
    // console.log(wrapper.children('Option').at(2).simulate('click', {event: {
    //                                                   currentTarget : {
    //                                                     textContent: "C"
    //                                                   }}
  // }
// ));
    // button = TestUtils.findRenderedDOMComponentWithTag('button').getDOMNode()
    // TestUtils.Simulate.click(button)

    // expect()
    //
    const handleClick = sinon.spy(Game.prototype, "handleClick")
    const button = wrapper.children('button').at(2)
    //     console.log(button.props);
    // button.simulate('click')


    expect(handleClick.calledOnce).to.be.true;
  });

  // it('first button should be the option at index 0' , () => {
  //   expect(wrapper.children('button').at(0).text()).to.equal("A")
  // });
  //
  // it('first button should be the option at index 1' , () => {
  //   expect(wrapper.children('button').at(1).text()).to.equal("B")
  // });
  //
  // it('first button should be the option at index 2' , () => {
  //   expect(wrapper.children('button').at(2).text()).to.equal("C")
  // });
  //
  // it('first button should be the option at index 3' , () => {
  //   expect(wrapper.children('button').at(3).text()).to.equal("D")
  // });
  //
  // it('endGame should initialy be false', () => {
  //   expect(wrapper.state('endGame')).to.be.false
  // })
  //
  // it('if game ends expect score to show on the page', () => {
  //   wrapper.setState({endGame: true, score: 8})
  //
  //   expect(wrapper.contains(<h4 className="finalScore">Final Score: 8 / 10</h4>)).to.be.true
  //   expect(wrapper.children('.gameOver').text()).to.equal('Game Over!')
  // })


});
