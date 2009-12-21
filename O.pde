class O extends Piece {
 /*
  11 11
  11 11
 */
  
  O() {
    super();
    
    piece = new byte[][] {{1, 1}, {1, 1}};
    piece90 = piece;
    piece180 = piece;
    piece270 = piece;
  }
  
  int getWidth() {
    return 2;
  }
  
  int getHeight() {
    return 2;
  }
}
