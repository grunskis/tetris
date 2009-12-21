class S extends Piece {
 /*
    0  90 
  --- --- 
  011  10 
  110  11 
       01
 */
  
  S() {
    super();
    
    piece = new byte[][] {{0, 1, 1}, {1, 1, 0}};
    piece90 = new byte[][] {{1, 0}, {1, 1}, {0, 1}};
    piece180 = piece;
    piece270 = piece90;
  }
}
