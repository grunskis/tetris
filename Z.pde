class Z extends Piece {
 /*
    0  90
  --- ---
  110  01
  011  11
       10
 */
  
  Z() {
    super();
    
    piece = new byte[][] {{1, 1, 0}, {0, 1, 1}};
    piece90 = new byte[][] {{0, 1}, {1, 1}, {1, 0}};
    piece180 = piece;
    piece270 = piece90;
  }
}
