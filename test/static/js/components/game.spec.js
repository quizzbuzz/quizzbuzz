import React from 'react';
import Game from '../../../../web/static/js/components/game';
import { shallow } from 'enzyme'
import { stub } from 'sinon'
import TestUtils from 'react-addons-test-utils'

describe('(Component) Game', () => {
  // const wrapper = shallow(<Game />)
  // stub(Game, "componentWillMount").returns({true});

  const Game = TestUtils.renderIntoDocument(<Game />);

    Game.setState({question: '1 + 1'});
    Game.componentWillMount();

    expect(Game.state.question).to.equal('1 + 1');


});
