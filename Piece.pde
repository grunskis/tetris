abstract class Piece {
  int row, column;
  
  byte[][][] piece;
  
  boolean alive;
  
  final int ANGLE_0   = 0;
  final int ANGLE_90  = 1;
  final int ANGLE_180 = 2;
  final int ANGLE_270 = 3;
  
  int angle;
  
  Piece() {
    row = 0;
    column = getSpawnPosition();
    alive = true;
    angle = ANGLE_0;
  }
  
  void moveDown() {
    if (alive) {
      row += 1;
    }
  }
  
  void moveLeft() {
    if (alive) {
      column -= 1;
    }
  }
  
  void moveRight() {
    if (alive) {
       column += 1;
    }
  }
  
  boolean isDead() {
    return (alive == false);
  }
  
  void die() {
    alive = false;
  }
  
  void rotate() {
    if (angle == ANGLE_270) {
      angle = ANGLE_0;
    } else {
      angle++;
    }
  }
  
  void setAngle(int angle) {
    this.angle = angle;
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
  
  int getSpawnPosition() {
    return 4;
  }
  
  boolean at(int row, int col) {
    return piece[angle][row][col] == 1;
  }
}
