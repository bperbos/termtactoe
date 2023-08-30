# frozen_string_literal: true

require 'minitest/autorun'
require 'minitest/unit'
require 'mocha/minitest'

require_relative '../lib/box'
require_relative '../lib/players'
require_relative 'test_helper'

describe Box do
  before do
    @win = mock
    @player = Player.new('player1', Minitest::Mock.new)
    @box = Box.new(1, 1, @win)
    @box.stubs(:color_pair).returns(2)
    @owner = mock
    @owner.stubs(:color_p).returns(2)
  end

  describe '#draw' do
    it 'nominal case' do
      @box.expects(:draw_box).once
      @win.expects(:attron).never

      @box.draw(selected: false)
    end

    describe 'when the box is the current one selected' do
      it 'draws a colored, bold outlined box' do
        @win.expects(:attron).yields(mock).once.with(3) # 1 | 2
        @box.expects(:draw_box).once.with('@', '@')
        @box.draw(selected: true)
      end
    end

    describe 'with an owner' do
      before { @box.owner = @owner }

      it 'fills the box' do
        @win.expects(:attron).once.with(3)
        @box.expects(:fill).once.with(2)
        @box.draw(selected: true)
      end

      describe 'when the box is in the winning row' do
        before do
          @box.in_winning_row = true
          @box.stubs(:fill)
        end

        it 'draws a colored outlined box' do
          @win.stubs(:attron).yields(mock).once.with(2)
          @box.expects(:draw_box).once
          @box.draw(selected: false)
        end
      end
    end
  end
end
