class J extends Piece {  
 /*
    0  90 180 270
  --- --- --- ---
  111  11 100  01
  001  10 111  01
       10      11 
 */
  
  J() {
    super();
    
    piece = new byte[][] {{1, 1, 1}, {0, 0, 1}};
    piece90 = new byte[][] {{1, 1}, {1, 0}, {1, 0}};
    piece180 = new byte[][] {{1, 0, 0}, {1, 1, 1}};
    piece270 = new byte[][] {{0, 1}, {0, 1}, {1, 1}};
  }
}
