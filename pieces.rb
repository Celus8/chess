# frozen_string_literal: true

class Pawn; end
class King; end
class Queen; end
class Rook; end
class Bishop; end

class Knight
  def initialize(pos)
    @moves = []
    @pos = pos
  end

  def create_moves
    (1..2).each do |i|
      (1..2).each do |j|
        skip if i == j

        unless @pos[0] + i > 7
          @moves.push(Position.new([@pos[0] + i, @pos[1] + j], self)) unless @pos[1] + j > 7
          @moves.push(Position.new([@pos[0] + i, @pos[1] - j], self)) unless @pos[1] - j < 0
        end
        unless @pos[0] - i < 0
          @moves.push(Position.new([@pos[0] - i, @pos[1] + j], self)) unless @pos[1] + j > 7
          @moves.push(Position.new([@pos[0] - i, @pos[1] - j], self)) unless @pos[1] - j < 0
        end
      end
    end
  end
end