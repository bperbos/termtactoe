# frozen_string_literal: true

class Box
  attr_reader :x, :y
  attr_accessor :owner, :in_winning_row

  def initialize(x:, y:, win:)
    @x = x
    @y = y
    @owner = nil
    @in_winning_row = false
    @win = win
  end

  def draw(selected:)
    if selected
      @win.attron(A_BOLD | (@owner.nil? ? color_pair(1) : color_pair(4))) do
        draw_box('@', '@')
      end
    elsif @in_winning_row
      @win.attron(@owner.color_p) { draw_box }
    else
      draw_box
    end

    return unless @owner

    fill(@owner.color_p)
  end

  private

  def draw_box(x_char = HCHAR, y_char = VCHAR)
    @win.setpos(@y, @x)
    draw_hline(Game::BOX_X, x_char)

    @win.setpos(@y, @x)
    draw_vline(Game::BOX_Y, y_char)

    @win.setpos(@y, @x + Game::BOX_X)
    draw_vline(Game::BOX_Y, y_char)

    @win.setpos(@y + Game::BOX_Y, @x)
    draw_hline(Game::BOX_X, x_char)
  end

  def draw_hline(n, char = HCHAR)
    @win.addstr(char * (n + 1))
  end

  def draw_vline(n, char = VCHAR)
    y = @win.cury + 1
    x = @win.curx

    (n - 1).times do |i|
      @win.setpos(y + i, x)
      @win << char
    end

    @win.setpos(y, x)
  end

  def fill(attrs)
    @win.attron(attrs) do
      (@y + 2).upto(@y + Game::BOX_Y - 2) do |index_y|
        (@x + 2).upto(@x + Game::BOX_X - 2) do |index_x|
          @win.setpos(index_y, index_x)
          @win << ' '
        end
      end
    end
  end
end
