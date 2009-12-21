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
  
  int getWidth() {
    int width = 0;
    
    switch (angle) {
      case ANGLE_0:
      case ANGLE_180:
        width = 3;
        break;
      case ANGLE_90:
      case ANGLE_270:
        width = 2;
        break;
    }
    
    return width;
  }
  
  int getHeight() {
    int height = 0;
    
    switch (angle) {
      case ANGLE_0:
      case ANGLE_180:
        height = 2;
        break;
      case ANGLE_90:
      case ANGLE_270:
        height = 3;
        break;
    }
    
    return height;
  }
}
