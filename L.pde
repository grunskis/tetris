class L extends Piece {
 /*
    0  90 180 270
  --- --- --- ---
  111  10 001  11
  100  10 111  01
       11      01
 */
  
  L() {
    super();
    
    piece = new byte[][] {{1, 1, 1}, {1, 0, 0}};
    piece90 = new byte[][] {{1, 0}, {1, 0}, {1, 1}};
    piece180 = new byte[][] {{0, 0, 1}, {1, 1, 1}};
    piece270 = new byte[][] {{1, 1}, {0, 1}, {0, 1}};
  }
}
