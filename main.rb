#!/usr/bin/env ruby
# frozen_string_literal: true

require 'curses'
require_relative 'lib/game'

include Curses

init_screen
start_color

init_pair(1, 2, 0) # green on black
init_pair(2, 1, 1) # red on red
init_pair(3, 2, 2) # green on green
init_pair(4, 1, 0) # red on black

curs_set(0)
noecho

begin
  game = Game.new(Curses.lines, Curses.cols)

  loop do
    game.refresh
  end
ensure
  close_screen
end
