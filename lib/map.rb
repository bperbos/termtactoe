# frozen_string_literal: true

require_relative 'box'

class Map
  attr_reader :game_status

  module GameStatus
    WIN = 'win'
    DRAW = 'draw'
    RUNNING = 'running'
  end

  def initialize(win, players)
    @game_map = init(win)
    @game_status = GameStatus::RUNNING
    @selected_indexes = [0, 0]
    @players = players
  end

  def set_status
    @game_status = current_status
  end

  def refresh
    ended = @game_status != Map::GameStatus::RUNNING

    each_box do |box|
      next if !ended && box == selected_box

      box.draw(selected: false)
    end

    selected_box.draw(selected: true) unless ended
    return unless ended

    each_box do |box|
      next unless box.in_winning_row

      box.draw(selected: false)
    end
  end

  def selected_box
    @game_map[@selected_indexes[0]][@selected_indexes[1]]
  end

  def set_selected_box_to_current_player
    selected_box.owner = @players.current

    set_status
    @players.next unless game_status != Map::GameStatus::RUNNING
  end

  def incr_selected_index(offset)
    @selected_indexes[offset] == 2 ? @selected_indexes[offset] = 0 : @selected_indexes[offset] += 1
  end

  def decr_selected_index(offset)
    @selected_indexes[offset] == 0 ? @selected_indexes[offset] = 2 : @selected_indexes[offset] -= 1
  end

  private

  def init(win)
    Array.new(3).map.with_index do |_, index_y|
      Array.new(3).map.with_index do |_, index_x|
        Box.new(index_y * Game::BOX_Y, index_x * Game::BOX_X, win)
      end
    end
  end

  def current_status
    # horizontal
    return GameStatus::WIN if horizontal_win?(@game_map)

    # vertical
    return GameStatus::WIN if horizontal_win?(@game_map.transpose)

    # diagonals
    return GameStatus::WIN if horizontal_win?(flatten_diagonals)

    # draw
    return GameStatus::DRAW unless @game_map.flatten.map { |box| box.owner }.uniq.include?(nil)

    GameStatus::RUNNING
  end

  def horizontal_win?(matrix)
    matrix.each do |row|
      content = row.map { |box| box.owner&.val }
      if ended?(content)
        row.each { |box| box.in_winning_row = true }
        return true
      end
    end

    false
  end

  def ended?(content)
    @players.each do |player|
      return true if content.all?(player.val)
    end

    false
  end

  def each_box(&block)
    @game_map.each do |row|
      row.each(&block)
    end
  end

  def flatten_diagonals
    diag_rev = []

    ptr = [0, @game_map.size - 1]
    3.times do
      diag_rev << @game_map[ptr[0]][ptr[1]]
      ptr[0] += 1
      ptr[1] -= 1
    end

    [
      (0..@game_map.size - 1).map { |i| @game_map[i][i] },
      diag_rev
    ]
  end
end
