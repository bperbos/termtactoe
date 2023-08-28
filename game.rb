# frozen_string_literal: true

require_relative 'map'
require_relative 'header'
require_relative 'controls'
require_relative 'players'

class Game
  def initialize(rows, cols)
    Game.const_set('BOX_Y', rows / 6)
    Game.const_set('BOX_X', cols / 6)

    margin = 1
    height = 3 * Game::BOX_Y + margin
    width = 3 * Game::BOX_X + margin

    @header = Header.new(rows, cols)
    @win = Curses::Window.new(height, width, (rows / 2 - height / 2) + @header.height / 2, cols / 2 - width / 2)
    @win.keypad(true)

    @players = Players.new
    @map = Map.new(@win, @players)
    @controls = Controls.new(@map, @players)
  end

  def refresh
    @header.refresh(@players, @map.game_status)
    @map.refresh
    @win.refresh

    @controls.listen(@win)
    @map.set_status
  end
end
