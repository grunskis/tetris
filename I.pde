class I extends Piece {
  I() {
    super();
    
    piece = new byte[][][] {
      {
        {1, 1, 1, 1}
      },
      {
        {1},
        {1},
        {1},
        {1}
      },
      {
        {1, 1, 1, 1}
      },
      {
        {1},
        {1},
        {1},
        {1}
      }
    };
  }
  
  int getWidth() {
    int width = 0;
    
    switch (angle) {
      case ANGLE_0:
      case ANGLE_180:
        width = 4;
        break;
      case ANGLE_90:
      case ANGLE_270:
        width = 1;
        break;
    }
    
    return width;
  }
  
  int getHeight() {
    int height = 0;
    
    switch (angle) {
      case ANGLE_0:
      case ANGLE_180:
        height = 1;
        break;
      case ANGLE_90:
      case ANGLE_270:
        height = 4;
        break;
    }
    
    return height;
  }
  
  int getSpawnPosition() {
    return 3;
  }
}

