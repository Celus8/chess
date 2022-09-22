# whites are associated to 1, blacks to -1

# frozen_string_literal: true

class Pawn
  attr_reader :moves

  def initialize(pos, color = 1)
    @moves = []
    @color = color
    @pos = pos
    @in_initial_pos = in_initial_pos?
    create_moves
  end

  def create_moves
    @moves.push([@pos[0], @pos[1] + @color]) unless @pos[1] + 1 > 7 || @pos[1] - 1 < 0
    @moves.push([@pos[0], @pos[1] + 2 * @color]) if @in_initial_pos
  end

  def in_initial_pos?
    @color == 1 ? @pos[1] == 1 : @pos[1] == 6
  end
end

class King
  attr_reader :moves

  def initialize(pos, color = 1)
    @moves = []
    @color = color
    @pos = pos
    create_moves
  end

  def create_moves
    (-1..1).each do |i|
      (-1..1).each do |j|
        illegal = @pos[0] + i > 7 || @pos[1] + j > 7 || @pos[0] + i < 0 || @pos[1] + j < 0
        @moves.push([@pos[0] + i, @pos[1] + j]) unless illegal
      end
    end
  end
end

class Queen
  attr_reader :moves

  def initialize(pos, color = 1)
    @moves = []
    @color = color
    @pos = pos
    create_moves
  end

  def create_moves; end
end

class Rook
  attr_reader :moves

  def initialize(pos, color = 1)
    @moves = []
    @color = color
    @pos = pos
    create_moves
  end

  def create_moves; end
end

class Bishop
  attr_reader :moves

  def initialize(pos, color = 1)
    @moves = []
    @color = color
    @pos = pos
    create_moves
  end

  def create_moves; end
end

class Knight
  attr_reader :moves

  def initialize(pos, color = 1)
    @moves = []
    @color = color
    @pos = pos
    create_moves
  end

  def create_moves
    (1..2).each do |i|
      (1..2).each do |j|
        skip if i == j

        unless @pos[0] + i > 7
          @moves.push([@pos[0] + i, @pos[1] + j]) unless @pos[1] + j > 7
          @moves.push([@pos[0] + i, @pos[1] - j]) unless @pos[1] - j < 0
        end
        unless @pos[0] - i < 0
          @moves.push([@pos[0] - i, @pos[1] + j]) unless @pos[1] + j > 7
          @moves.push([@pos[0] - i, @pos[1] - j]) unless @pos[1] - j < 0
        end
      end
    end
  end
end
