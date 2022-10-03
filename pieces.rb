# whites are associated to 1, blacks to -1

# frozen_string_literal: true

class Pawn
  attr_reader :icon
  attr_accessor :pos, :moves

  def initialize(pos, color = 1)
    @moves = []
    @color = color
    @pos = pos
    create_moves
    @icon = color == 1 ? '♙' : '♟'
  end

  def create_moves
    @moves = []
    @moves.push([@pos[0], @pos[1] + @color]) unless @pos[1] + 1 > 7 || @pos[1] - 1 < 0
    @moves.push([@pos[0], @pos[1] + 2 * @color]) if in_initial_pos?
  end

  # In this case, it also creates moves (diagonal killing)
  def delete_moves(allied_piece, enemy_piece)
    apos = allied_piece.pos
    epos = enemy_piece.pos
    @moves.delete(apos)
    @moves.delete(epos)
    @moves.push(epos) if (epos[1] == @pos[1] + @color) && (epos[0] == @pos[0] + 1 || epos[0] == @pos[0] - 1)
    if @color == 1
      @moves.delete([epos[0], epos[1] + 1]) if in_initial_pos? && @pos[1] < epos[1]
      @moves.delete([apos[0], apos[1] + 1]) if in_initial_pos? && @pos[1] < apos[1]
    end
    if @color == -1
      @moves.delete([epos[0], epos[1] - 1]) if in_initial_pos? && @pos[1] > epos[1]
      @moves.delete([apos[0], apos[1] - 1]) if in_initial_pos? && @pos[1] > apos[1]
    end
  end

  def in_initial_pos?
    @color == 1 ? @pos[1] == 1 : @pos[1] == 6
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
    @moves = []
    (-1..1).each do |i|
      (-1..1).each do |j|
        illegal = @pos[0] + i > 7 || @pos[1] + j > 7 || @pos[0] + i < 0 || @pos[1] + j < 0
        @moves.push([@pos[0] + i, @pos[1] + j]) unless illegal
      end
    end
  end

  def delete_moves(allied_piece, enemy_piece)
    @moves.delete(allied_piece.pos)
    @moves.delete(enemy_piece.pos) if enemy_piece.is_a?(King)
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
    @moves = []
    (-7..7).each do |i|
      (-7..7).each do |j|
        illegal = @pos[0] + i > 7 || @pos[1] + j > 7 || @pos[0] + i < 0 || @pos[1] + j < 0 || (i.abs != j.abs && i != 0 && j != 0)
        @moves.push([@pos[0] + i, @pos[1] + j]) unless illegal
      end
    end
  end

  def delete_moves(allied_piece, enemy_piece)
    apos = allied_piece.pos
    epos = enemy_piece.pos
    @moves.delete(apos)
    @moves.delete(epos) if enemy_piece.is_a?(King)
    delete_positions(apos)
    delete_positions(epos)
  end

  def delete_positions(pos)
    if (@pos[0] - pos[0]).zero?
      (7 - pos[1]).times { |i| @moves.delete([pos[0], pos[1] + i + 1]) } if @pos[1] < pos[1]
      (pos[1]).times { |i| @moves.delete([pos[0], pos[1] - i - 1]) } if @pos[1] > pos[1]
    end
    if (@pos[1] - pos[1]).zero?
      (7 - pos[0]).times { |i| @moves.delete([pos[0] + i + 1, pos[1]]) } if @pos[0] < pos[0]
      (pos[0]).times { |i| @moves.delete([pos[0] - i - 1, pos[1]]) } if @pos[0] > pos[0]
    end
    if @pos[0] - pos[0] == @pos[1] - pos[1]
      7.times { |i| @moves.delete([pos[0] - i - 1, pos[1] - i - 1]) } if (@pos[0] - pos[0]).positive?
      7.times { |i| @moves.delete([pos[0] + i + 1, pos[1] + i + 1]) } if (@pos[0] - pos[0]).negative?
    end
    if @pos[0] - pos[0] == -1 * (@pos[1] - pos[1])
      7.times { |i| @moves.delete([pos[0] - i - 1, pos[1] + i + 1]) } if (@pos[0] - pos[0]).positive?
      7.times { |i| @moves.delete([pos[0] + i + 1, pos[1] - i - 1]) } if (@pos[0] - pos[0]).negative?
    end
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
    @moves = []
    (-7..7).each do |i|
      illegal = @pos[0] + i > 7 || @pos[0] + i < 0
      @moves.push([@pos[0] + i, @pos[1]]) unless illegal
    end
    (-7..7).each do |i|
      illegal = @pos[1] + i > 7 || @pos[1] + i < 0
      @moves.push([@pos[0], @pos[1] + i]) unless illegal
    end
  end

  def delete_moves(allied_piece, enemy_piece)
    apos = allied_piece.pos
    epos = enemy_piece.pos
    @moves.delete(apos)
    @moves.delete(epos) if enemy_piece.is_a?(King)
    delete_positions(apos)
    delete_positions(epos)
  end

  def delete_positions(pos)
    if (@pos[0] - pos[0]).zero?
      (7 - pos[1]).times { |i| @moves.delete([pos[0], pos[1] + i + 1]) } if @pos[1] < pos[1]
      (pos[1]).times { |i| @moves.delete([pos[0], pos[1] - i - 1]) } if @pos[1] > pos[1]
    end
    if (@pos[1] - pos[1]).zero?
      (7 - pos[0]).times { |i| @moves.delete([pos[0] + i + 1, pos[1]]) } if @pos[0] < pos[0]
      (pos[0]).times { |i| @moves.delete([pos[0] - i - 1, pos[1]]) } if @pos[0] > pos[0]
    end
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
    @moves = []
    (-7..7).each do |i|
      (-7..7).each do |j|
        illegal = @pos[0] + i > 7 || @pos[1] + j > 7 || @pos[0] + i < 0 || @pos[1] + j < 0 || i.abs != j.abs
        @moves.push([@pos[0] + i, @pos[1] + j]) unless illegal
      end
    end
  end

  def delete_moves(allied_piece, enemy_piece)
    apos = allied_piece.pos
    epos = enemy_piece.pos
    @moves.delete(apos)
    @moves.delete(epos) if enemy_piece.is_a?(King)
    delete_positions(apos)
    delete_positions(epos)
  end

  def delete_positions(pos)
    if @pos[0] - pos[0] == @pos[1] - pos[1]
      7.times { |i| @moves.delete([pos[0] - i - 1, pos[1] - i - 1]) } if (@pos[0] - pos[0]).positive?
      7.times { |i| @moves.delete([pos[0] + i + 1, pos[1] + i + 1]) } if (@pos[0] - pos[0]).negative?
    end
    if @pos[0] - pos[0] == -1 * (@pos[1] - pos[1])
      7.times { |i| @moves.delete([pos[0] - i - 1, pos[1] + i + 1]) } if (@pos[0] - pos[0]).positive?
      7.times { |i| @moves.delete([pos[0] + i + 1, pos[1] - i - 1]) } if (@pos[0] - pos[0]).negative?
    end
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
    @moves = []
    (1..2).each do |i|
      (1..2).each do |j|
        next if i == j

        @moves.push([@pos[0] + i, @pos[1] + j]) unless @pos[0] + i > 7 || @pos[1] + j > 7
        @moves.push([@pos[0] + i, @pos[1] - j]) unless @pos[0] + i > 7 || @pos[1] - j < 0
        @moves.push([@pos[0] - i, @pos[1] + j]) unless @pos[0] - i < 0 || @pos[1] + j > 7
        @moves.push([@pos[0] - i, @pos[1] - j]) unless @pos[0] - i < 0 || @pos[1] - j < 0
      end
    end
  end

  def delete_moves(allied_piece, enemy_piece)
    @moves.delete(enemy_piece.pos) if enemy_piece.is_a?(King)
    @moves.delete(allied_piece.pos)
  end
end
