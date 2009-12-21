abstract class Piece {
  int line, position;
  
  byte[][] piece;
  byte[][] piece90;
  byte[][] piece180;
  byte[][] piece270;
  
  boolean alive;
  
  final int ANGLE_0   = 0;
  final int ANGLE_90  = 1;
  final int ANGLE_180 = 2;
  final int ANGLE_270 = 3;
  
  int angle;
  
  Piece() {
    line = 0;
    position = getSpawnPosition();
    alive = true;
    angle = ANGLE_0;
  }
  
  void fall() {
    if (alive) {
      line += 1;
    }
  }
  
  void left() {
    if (alive) {
      position -= 1;
    }
  }
  
  void right() {
    if (alive) {
       position += 1;
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
    switch (angle) {
      case ANGLE_0:
        return piece[row][col] == 1;
        
      case ANGLE_90:
        return piece90[row][col] == 1;

      case ANGLE_180:
        return piece180[row][col] == 1;
        
      case ANGLE_270:
        return piece270[row][col] == 1;
    }   
 
    return false;
  }
}
