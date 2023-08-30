# frozen_string_literal: true

class Controls
  def initialize(map, players)
    @map = map
    @players = players
  end

  def listen(win)
    key = win.getch

    in_game_action(key) if @map.game_status == Map::GameStatus::RUNNING
    exit 0 if key.to_s == 'q' || key == 27 # ESC
  end

  def in_game_action(key)
    case key
    when Curses::KEY_DOWN
      @map.incr_selected_index(0)
    when Curses::KEY_UP
      @map.decr_selected_index(0)
    when Curses::KEY_LEFT
      @map.decr_selected_index(1)
    when Curses::KEY_RIGHT
      @map.incr_selected_index(1)
    when 10 # Enter
      @map.set_selected_box_to_current_player if @map.selected_box.owner.nil?
    end
  end
end
