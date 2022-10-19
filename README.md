# chess
A game of chess, playable on the terminal. Done as part of The Odin Project curriculum.

The game works fine, although there may be some bugs I haven't had the time to test (I would be happy to know if you find one!), and there are some lacking features mentioned below.

Upcoming features:

  - Change the board to be a hash with keys being two-dimensional arrays showing coordinates and values being piece objects.
  
  Essential for the game to be considered finished:
  - Pawn promotion
  - Castling
  - Draw situations
  
  Optional to make the game more interesting:
  - Implement saving and loading of games
  - Implement AI that makes random moves.
  - Highlight piece when selected. When possible moves include an enemy piece to eat, make the piece color red and don't put a square over it.

  Performance and readability of code:
  - Optimize the method that checks if the game has been won (it takes a few seconds to do so currently, breaking the flow of the game)
  - Eliminate duplicate methods for black and white pieces to keep code DRY
