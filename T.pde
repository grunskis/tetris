class T extends Piece {
 /*
    0  90 180 270
  --- --- --- ---
  111  10 010  01
  010  11 111  11
       10      01 
 */
  
  T() {
    super();
    
    piece = new byte[][] {{1, 1, 1}, {0, 1, 0}};
    piece90 = new byte[][] {{1, 0}, {1, 1}, {1, 0}};
    piece180 = new byte[][] {{0, 1, 0}, {1, 1, 1}};
    piece270 = new byte[][] {{0, 1}, {1, 1}, {0, 1}};
  }
}
