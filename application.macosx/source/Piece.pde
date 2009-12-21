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
    position = 3; // this should be done by grid.place
    alive = true;
    angle = ANGLE_0;
  }
  
  Piece(int line, int position, int angle) {
    this.line = line;
    this.position = position;
    this.angle = angle;
    alive = true;
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
  
  int getLine() {
    return line;
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
  
  int preRotate() {
    if (angle == ANGLE_270) {
      return ANGLE_0;
    } else {
      return (angle + 1);
    }
  }
  
  abstract int getWidth();
  abstract int getHeight();
  
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
  
  boolean atAngle(int row, int col, int a) {
    switch (a) {
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
  
  //Piece copy() {
    //return new Piece(this.line, this.position, this.angle);
  //}
}
