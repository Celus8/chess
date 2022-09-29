# whites are associated to 1, blacks to -1

# frozen_string_literal: true

class Pawn
  attr_reader :icon
  attr_accessor :pos, :moves

  def initialize(pos, color = 1)
    @moves = []
    @color = color
    @pos = pos
    @in_initial_pos = in_initial_pos?
    create_moves
    @icon = color == 1 ? '♙' : '♟'
  end

  def create_moves
    @moves.push([@pos[0], @pos[1] + @color]) unless @pos[1] + 1 > 7 || @pos[1] - 1 < 0
    @moves.push([@pos[0], @pos[1] + 2 * @color]) if @in_initial_pos
  end

  def in_initial_pos?
    @color == 1 ? @pos[1] == 1 : @pos[1] == 6
  end

  def kill
    @pos = 'dead'
  end
end

class King
  attr_reader :icon
  attr_accessor :pos, :moves

  def initialize(pos, color = 1)
    @moves = []
    @color = color
    @pos = pos
    create_moves
    @icon = color == 1 ? '♔' : '♚'
  end

  def create_moves
    (-1..1).each do |i|
      (-1..1).each do |j|
        illegal = @pos[0] + i > 7 || @pos[1] + j > 7 || @pos[0] + i < 0 || @pos[1] + j < 0
        @moves.push([@pos[0] + i, @pos[1] + j]) unless illegal
      end
    end
  end

  def kill
    @pos = 'dead'
  end
end

class Queen
  attr_reader :icon
  attr_accessor :pos, :moves

  def initialize(pos, color = 1)
    @moves = []
    @color = color
    @pos = pos
    create_moves
    @icon = color == 1 ? '♕' : '♛'
  end

  def create_moves
    (-7..7).each do |i|
      (-7..7).each do |j|
        illegal = @pos[0] + i > 7 || @pos[1] + j > 7 || @pos[0] + i < 0 || @pos[1] + j < 0 || (i.abs != j.abs && i != 0 && j != 0)
        @moves.push([@pos[0] + i, @pos[1] + j]) unless illegal
      end
    end
  end

  def kill
    @pos = 'dead'
  end
end

class Rook
  attr_reader :icon
  attr_accessor :pos, :moves

  def initialize(pos, color = 1)
    @moves = []
    @color = color
    @pos = pos
    create_moves
    @icon = color == 1 ? '♖' : '♜'
  end

  def create_moves
    (-7..7).each do |i|
      illegal = @pos[0] + i > 7 || @pos[0] + i < 0
      @moves.push([@pos[0] + i, @pos[1]]) unless illegal
    end
    (-7..7).each do |i|
      illegal = @pos[1] + i > 7 || @pos[1] + i < 0
      @moves.push([@pos[0], @pos[1] + i]) unless illegal
    end
  end

  def kill
    @pos = 'dead'
  end
end

class Bishop
  attr_reader :icon
  attr_accessor :pos, :moves

  def initialize(pos, color = 1)
    @moves = []
    @color = color
    @pos = pos
    create_moves
    @icon = color == 1 ? '♗' : '♝'
  end

  def create_moves
    (-7..7).each do |i|
      (-7..7).each do |j|
        illegal = @pos[0] + i > 7 || @pos[1] + j > 7 || @pos[0] + i < 0 || @pos[1] + j < 0 || i.abs != j.abs
        @moves.push([@pos[0] + i, @pos[1] + j]) unless illegal
      end
    end
  end

  def kill
    @pos = 'dead'
  end
end

class Knight
  attr_reader :icon
  attr_accessor :pos, :moves

  def initialize(pos, color = 1)
    @moves = []
    @color = color
    @pos = pos
    create_moves
    @icon = color == 1 ? '♘' : '♞'
  end

  def create_moves
    (1..2).each do |i|
      (1..2).each do |j|
        illegal = @pos[0] + i > 7 || @pos[1] + j > 7 || @pos[0] + i < 0 || @pos[1] + j < 0 || i == j
        next if illegal

        @moves.push([@pos[0] + i, @pos[1] + j])
        @moves.push([@pos[0] + i, @pos[1] - j])
        @moves.push([@pos[0] - i, @pos[1] + j])
        @moves.push([@pos[0] - i, @pos[1] - j])
      end
    end
  end

  def kill
    @pos = 'dead'
  end
end
