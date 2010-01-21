class Grid {
  Cell[][] cells;
  
  int rows, cols;
  
  Grid(int cols, int rows, int xoffset, int yoffset) {
    cells = new Cell[cols][rows];
    
    for (int i = 0; i < cols; i++) {
      for (int j = 0; j < rows; j++) {
        cells[i][j] = new Cell(xoffset + i*20, yoffset + j*20, 20, 20);
      }
    }
    
    this.rows = rows;
    this.cols = cols;
  }
  
  void draw() {
    for (int i = 0; i < cols; i++) {
      for (int j = 0; j < rows; j++) {
        cells[i][j].display();
      }
    }
  }
  
  boolean place(Piece piece) {
    for (int h = 0; h < piece.getHeight(); h++) {
      for (int w = 0; w < piece.getWidth(); w++) { 
        if (piece.at(h, w)) {
          int row = piece.row + h;
          int col = piece.column + w;
          
          if (cells[col][row].isPermanent()) {
            // GAME OVER
            return false;
          }
          
          cells[col][row].turnOn();
        }
      }
    }
    
    return true;
  }
  
  void die(Piece piece) {
    piece.die();
    
    for (int row = piece.getHeight()-1; row >= 0; row--) {
      for (int col = 0; col < piece.getWidth(); col++) {
        if (piece.at(row, col)) {
          int position = col + piece.column;
          
          cells[position][row + piece.row].setPermanent(true);
        }
      }
    }
  }
  
  void clear() {
    for (int i = 0; i < cols; i++) {
      for (int j = 0; j < rows; j++) {
        if (cells[i][j].isPermanent() == false) {
          cells[i][j].turnOff();
        }
      }
    }
  }
  
  void clearRow(int row) {
    for (int col = 0; col < this.cols; col++) {
      cells[col][row].turnOff();
    }
  }
  
  int removeDeadLines() {
    ArrayList linesCleared = new ArrayList();
    
    for (int row = 0; row < this.rows; row++) {
      boolean dead = true;
      
      for (int col = 0; col < this.cols; col++) {
        if (!cells[col][row].isPermanent()) {
          dead = false;
          break;
        }
      }
      
      if (dead) {
        clearRow(row);
        
        linesCleared.add(row);
      }
    }

    for (int j = 0; j < linesCleared.size(); j++) {
      int row = (Integer)linesCleared.get(j);
      
      // move all cells above cleared line down one row
      for (int i = row - 1; i >= 0; i--) {
        for (int col = 0; col < this.cols; col++) {
          if (cells[col][i].isPermanent()) {
            cells[col][i].turnOff();
            cells[col][i+1].setPermanent(true);
          }
        }
      }
    }
    
    return linesCleared.size();
  }
  
  boolean canMoveDown(Piece piece) {
    int row = piece.row;
    
    piece.moveDown();
    
    boolean can = grid.positionValid(piece);
    
    piece.row = row;
    return can;
  } 
 
  boolean canMoveRight(Piece piece) {
    int position = piece.column;
    
    piece.moveRight();
    
    boolean can = grid.positionValid(piece);
    
    piece.column = position;
    return can;
  }
 
  boolean canMoveLeft(Piece piece) {
    int position = piece.column;
    
    piece.moveLeft();
    
    boolean can = grid.positionValid(piece);
    
    piece.column = position;
    return can;
  }

  boolean canRotate(Piece piece) {
    int angle = piece.angle; // save piece angle
    
    piece.rotate();
    
    // check if current position is valid
    boolean valid = positionValid(piece);
    
    piece.setAngle(angle); // restore old angle
    return valid;
  }
  
  boolean positionValid(Piece piece) {
    for (int h = 0; h < piece.getHeight(); h++) {
      for (int w = 0; w < piece.getWidth(); w++) {
        if (piece.at(h, w)) {
          int row = piece.row + h;
          int col = piece.column + w;
          
          if (col < 0 || col >= this.cols || row >= this.rows || cells[col][row].isPermanent()) {
            return false; // piece position is not valid
          }
        }
      }
    }
    
    // piece position is valid
    return true;
  }
  
  void drop(Piece piece) {
    for (int row = 0; row < this.rows; row++) {
      piece.row = row;

      if (!positionValid(piece)) {
        piece.row--;
        return;
      }
    }
  }
}
