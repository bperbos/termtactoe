# frozen_string_literal: true

class Player
  attr_reader :val, :color_p

  def initialize(val, color_p)
    @val = val
    @color_p = color_p
  end
end

class Players
  def initialize
    @players = [
      Player.new('red', color_pair(2)),
      Player.new('green', color_pair(3))
    ]
    @current = 0
  end

  def next
    if @current == @players.size - 1
      @current = 0
      return
    end

    @current += 1
  end

  def current
    @players[@current]
  end

  def each(&block)
    @players.each(&block)
  end
end
