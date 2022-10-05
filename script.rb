# Commit often
# TDD as much as I can

# Gameplay loop: The board is shown. The first player is whites. Which player needs to play is shown by a message. A player then inputs letter to show in what square the piece he is going to move is. The piece is highlighted in red. Then the player will select a row, and then a column. If the move is illegal, a warning sign will appear and clicking enter will do nothing. If it is legal, clicking enter will move the piece.
# Every piece is an object, which has an array of legal moves. When the player moves, unless the move he choses is in that array, a warning will appear.

# Steps:

# 1.
# Implement saving and loading of games

# 3.
# Make a method that returns either @black_pieces or @white_pieces depending on what's been given, same with @white_king and @black_king, and delete duplicate methods
# Highlight piece when selected making it blue. When possible moves include an enemy piece to eat, make the piece color red and don't put a square over it.
# Make pawn promotion. If pawn position is in the last row, pawn is dead and a message displays what to replace it with. The player writes what to replace it with and a new piece is created with the same pos.
# Make castling. If the king hasn't moved yet and isn't in check (and will not be in check during the passage) it can castle, and the rook moves at the same time.
# Make draw in case 2 kings are left
# Implement AI that makes random moves

# BUGS TO FIX:

# frozen_string_literal: true

require 'pry-byebug'
require './pieces'

WP = '♙'
WK = '♔'
WQ = '♕'
WR = '♖'
WB = '♗'
WN = '♘'
BP = '♟'
BK = '♚'
BQ = '♛'
BR = '♜'
BB = '♝'
BN = '♞'
SQUARE = '·'
SELECTED_SQUARE = 'x'
LETTERS = %w[a b c d e f g h]

class Game
  def initialize
    @all_moves = []
    @board_to_print = Array.new(9) { Array.new(9, SQUARE) }
    @white_king = King.new([4, 0])
    @black_king = King.new([4, 7], -1)
    populate_boards
    @white_pieces = []
    @black_pieces = []
    @selected_piece = Pawn.new([-1, -1])
    @quit = false
    create_pieces
    @current_player = 'white'
    @select_again = false
    @check_message = false
  end

  def play
    puts 'Welcome to chess! White player starts'
    update_board
    until @quit
      printings
      make_play
      if @select_again
        @select_again = false
        next
      end
      @current_player = @current_player == 'white' ? 'black' : 'white'
      update_board
    end
  end

  def make_play
    if check_win
      @quit = true
      return
    end
    puts 'Select a piece to move'
    @current_player == 'white' ? make_selection_white : make_selection_black
    update_moves
    show_moves
    return if @quit

    printings
    puts 'Select a place to move it'
    make_move
    if @select_again
      update_board
      printings
      return
    end
    return if @quit
  end

  def make_selection_white
    selection = gets.chomp
    if check_quit(selection)
      @quit = true
      return
    end
    if select_white_piece(input_to_move(selection))
      return
    end

    printings
    puts 'Select a valid position!'
    make_selection_white
  end

  def make_selection_black
    selection = gets.chomp
    if check_quit(selection)
      @quit = true
      return
    end
    if select_black_piece(input_to_move(selection))
      return
    end

    printings
    puts 'Select a valid position!'
    make_selection_black
  end

  def select_white_piece(move)
    @white_pieces.each do |piece|
      if move == piece.pos
        @selected_piece = piece
        return true
      end
    end
    false
  end

  def select_black_piece(move)
    @black_pieces.each do |piece|
      if move == piece.pos
        @selected_piece = piece
        return true
      end
    end
    false
  end

  def make_move
    move = gets.chomp
    if check_quit(move)
      @quit = true
      return
    end
    return if move_piece(input_to_move(move))

    printings
    if @check_message
      puts 'This puts your king in check!'
      @check_message = false
    end
    puts 'Select a valid move!'
    make_move
  end

  def check_quit(input)
    return true if input == 'quit' || input == 'exit'
    false
  end

  def input_to_move(move)
    input = move.split('')
    input[0] = LETTERS.index(input[0])
    input[1] = input[1].to_i - 1
    input
  end

  def move_piece(move)
    if move == @selected_piece.pos
      @select_again = true
      return true
    end
    if @selected_piece.moves.include?(move)
      last_pos = @selected_piece.pos
      @selected_piece.pos = move
      killed_piece = kill_piece(move)
      update_moves
      if check_allied_check
        @check_message = true
        @selected_piece.pos = last_pos
        revive_piece(killed_piece)
        update_moves
        return false
      end
      return true
    end
    false
  end

  def kill_piece(move) # Works fine. Returns the killed piece
    killed_piece = nil
    if @current_player == 'white'
      @black_pieces.each do |piece|
        killed_piece = piece if move == piece.pos
      end
      @black_pieces.delete(killed_piece)
    end
    if @current_player == 'black'
      @white_pieces.each do |piece|
        killed_piece = piece if move == piece.pos
      end
      @white_pieces.delete(killed_piece)
    end
    killed_piece
  end

  def revive_piece(piece)
    return if piece.nil?

    piece.color == 1 ? @white_pieces.push(piece) : @black_pieces.push(piece)
  end

  def check_enemy_check # Works fine
    return @white_king.in_check?(@black_pieces) if @current_player == 'black'
    return @black_king.in_check?(@white_pieces) if @current_player == 'white'
  end

  def check_allied_check # Works fine
    return @white_king.in_check?(@black_pieces) if @current_player == 'white'
    return @black_king.in_check?(@white_pieces) if @current_player == 'black'
  end

  def no_moves_white?
    no_moves = true
    @white_pieces.each do |piece|
      piece.moves.each do |move|
        last_pos = piece.pos
        piece.pos = move
        killed_piece = kill_piece(move)
        update_moves
        no_moves = false unless @white_king.in_check?(@black_pieces)
        piece.pos = last_pos
        revive_piece(killed_piece)
        update_moves
      end
    end
    no_moves
  end

  def no_moves_black?
    no_moves = true
    @black_pieces.each do |piece|
      piece.moves.each do |move|
        last_pos = piece.pos
        piece.pos = move
        killed_piece = kill_piece(move)
        update_moves
        no_moves = false unless @black_king.in_check?(@white_pieces)
        piece.pos = last_pos
        revive_piece(killed_piece)
        update_moves
      end
    end
    no_moves
  end

  def update_moves # Doesn't delete check moves
    @white_pieces.each do |wpiece1|
      wpiece1.create_moves
      @black_pieces.each do |bpiece1|
        bpiece1.create_moves
        @white_pieces.each do |wpiece2|
          wpiece1.delete_moves(wpiece2, bpiece1)
          @black_pieces.each do |bpiece2|
            bpiece1.delete_moves(bpiece2, wpiece1)
          end
        end
      end
    end
  end

  # def delete_moves_check
  #   if @current_player == 'white'
  #     @white_pieces.each do |piece|
  #       piece.moves.filter! { |move| puts_king_in_check?(piece, move, 'white') == false }
  #     end
  #   end
  #   if @current_player == 'black'
  #     @black_pieces.each do |piece|
  #       piece.moves.filter! { |move| puts_king_in_check?(piece, move, 'black') == false }
  #     end
  #   end
  # end

  # def puts_king_in_check?(piece, move, color)
  #   last_pos = piece.pos
  #   piece.pos = move
  #   killed_piece = kill_piece(move)
  #   update_moves
  #   if color == 'white'
  #     if @white_king.in_check?(@black_pieces)
  #       piece.pos = last_pos
  #       killed_piece.nil? || (killed_piece.color == 1 ? @white_pieces.push(killed_piece) : @black_pieces.push(killed_piece))
  #       update_moves
  #       return true
  #     end
  #   end
  #   if color == 'black'
  #     if @black_king.in_check?(@white_pieces)
  #       piece.pos = last_pos
  #       killed_piece.nil? || (killed_piece.color == 1 ? @white_pieces.push(killed_piece) : @black_pieces.push(killed_piece))
  #       update_moves
  #       return true
  #     end
  #   end
  #   false
  # end

  def check_win # Checks if the kings are in check and no_moves are true
    if @white_king.in_check?(@black_pieces) && no_moves_white?
      puts 'Black wins! Congratulations'
      return true
    end
    if @black_king.in_check?(@white_pieces) && no_moves_black?
      puts 'White wins! Congratulations'
      return true
    end
    false
  end

  def turn_message
    puts "It's #{@current_player} player's turn"
  end

  def printings
    print_board
    turn_message
    check_messages
  end

  def check_messages
    if @white_king.in_check?(@black_pieces)
      puts 'White king in check!'
    end
    if @black_king.in_check?(@white_pieces)
      puts 'Black king in check!'
    end
  end

  def show_moves
    @selected_piece.moves.each do |move|
      @board_to_print[7 - move[1]][move[0] + 1] = '■'
    end
  end

  def populate_boards
    8.times do |i|
      8.times do |j|
        @all_moves << [i, j]
      end
    end
    @board_to_print.each_with_index do |arr, i|
      next if i == 8
      arr[0] = 8 - i
    end
    8.times { |i| @board_to_print[8][i + 1] = LETTERS[i] }
    @board_to_print[8][0] = ' '
  end

  def update_board
    @all_moves.each do |square|
      empty = true
      @white_pieces.each do |piece|
        if piece.pos == square
          @board_to_print[7 - square[1]][square[0] + 1] = piece.icon
          empty = false
        end
      end
      @black_pieces.each do |piece|
        if piece.pos == square
          @board_to_print[7 - square[1]][square[0] + 1] = piece.icon
          empty = false
        end
      end
      @board_to_print[7 - square[1]][square[0] + 1] = SQUARE if empty
    end
  end

  def create_pieces
    create_white_pieces
    create_black_pieces
  end

  def create_white_pieces
    8.times do |i|
      @white_pieces.push(Pawn.new([i, 1]))
    end
    @white_pieces.push(@white_king)
    @white_pieces.push(Queen.new([3, 0]))
    @white_pieces.push(Rook.new([0, 0]))
    @white_pieces.push(Rook.new([7, 0]))
    @white_pieces.push(Bishop.new([2, 0]))
    @white_pieces.push(Bishop.new([5, 0]))
    @white_pieces.push(Knight.new([1, 0]))
    @white_pieces.push(Knight.new([6, 0]))
  end

  def create_black_pieces
    8.times do |i|
      @black_pieces.push(Pawn.new([i, 6], -1))
    end
    @black_pieces.push(@black_king)
    @black_pieces.push(Queen.new([3, 7], -1))
    @black_pieces.push(Rook.new([0, 7], -1))
    @black_pieces.push(Rook.new([7, 7], -1))
    @black_pieces.push(Bishop.new([2, 7], -1))
    @black_pieces.push(Bishop.new([5, 7], -1))
    @black_pieces.push(Knight.new([1, 7], -1))
    @black_pieces.push(Knight.new([6, 7], -1))
  end

  def print_board
    @board_to_print.each do |row|
      print "#{row.join(' ')}\n"
    end
  end
end

game = Game.new
game.play
