# frozen_string_literal: true

require 'minitest/autorun'

require_relative '../lib/map'
require_relative '../lib/players'
require_relative 'test_helper'

describe Map do
  before do
    @win = Minitest::Mock.new
    @player1 = Player.new('player1', Minitest::Mock.new)
    @player2 = Player.new('player2', Minitest::Mock.new)
    @players = Players.new([@player1, @player2])

    @map = Map.new(@win, @players)
    @map_arr = @map.instance_variable_get(:@game_map)
  end

  describe 'initializing' do
    it 'sets starting values' do
      assert_equal Map::GameStatus::RUNNING, @map.game_status
      assert_equal [nil], @map_arr.flatten.map(&:owner).uniq
    end
  end

  describe 'end conditions' do
    it 'spots an horizontal win' do
      @map_arr[0].each { |box| box.owner = @player1 }

      assert_equal Map::GameStatus::RUNNING, @map.game_status
      @map.set_status
      assert_equal Map::GameStatus::WIN, @map.game_status
    end

    it 'spots a vertical win' do
      @map_arr.transpose[0].each { |box| box.owner = @player1 }

      assert_equal Map::GameStatus::RUNNING, @map.game_status
      @map.set_status
      assert_equal Map::GameStatus::WIN, @map.game_status
    end

    it 'spots a diagonal win' do
      3.times { |i| @map_arr[i][i].owner = @player1 }

      assert_equal Map::GameStatus::RUNNING, @map.game_status
      @map.set_status
      assert_equal Map::GameStatus::WIN, @map.game_status
    end

    it 'spots a draw' do
      # [x,o,x]
      # [x,o,x]
      # [o,x,o]
      2.times do |i|
        @map_arr[i][0].owner = @player1
        @map_arr[i][1].owner = @player2
        @map_arr[i][2].owner = @player1
      end
      @map_arr[2][0].owner = @player2
      @map_arr[2][1].owner = @player1
      @map_arr[2][2].owner = @player2

      assert_equal Map::GameStatus::RUNNING, @map.game_status
      @map.set_status
      assert_equal Map::GameStatus::DRAW, @map.game_status
    end
  end
end
