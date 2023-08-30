# frozen_string_literal: true

class Header
  attr_reader :height

  def initialize(rows, cols)
    @height = rows / 4 - 1
    @width = cols - 1

    @win = Curses::Window.new(@height, @width, 1, 1)
    @win.setpos(1, 2)
    @win << 'Arrow keys to move around'
    @win.setpos(2, 2)
    @win << 'Enter to select'
    @win.setpos(3, 2)
    @win << 'q to quit'
  end

  def refresh(players, game_status)
    text =
      case game_status
      when Map::GameStatus::WIN
        "#{players.current.val.capitalize} player wins !"
      when Map::GameStatus::DRAW
        'Draw !'
      else
        "#{players.current.val.capitalize} player turn"
      end

    if game_status != Map::GameStatus::RUNNING
      @win.attron(A_BOLD | A_BLINK) { set_title(text) }
    else
      set_title(text)
    end

    @win.box('*', '*')
    @win.refresh
  end

  def set_title(text)
    adjust = @height.even? ? 1 : 0
    @win.setpos(@height / 2 - adjust, 1)
    @win.clrtoeol
    @win.setpos(@height / 2 - adjust, @width / 2 - text.size / 2)
    @win << text
  end
end
