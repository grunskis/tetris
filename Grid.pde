class Grid {
  Cell[][] cells;
  
  int rows, cols;
  
  Grid(int cols, int rows) {
    cells = new Cell[cols][rows];
    
    for (int i = 0; i < cols; i++) {
      for (int j = 0; j < rows; j++) {
        cells[i][j] = new Cell(i*20, j*20, 20, 20);
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
          int row = piece.line + h;
          int col = piece.position + w;
          
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
          int position = col + piece.position;
          
          cells[position][row + piece.line].setPermanent(true);
        }
      }
    }
  }
 
  boolean canFall(Piece piece) {
    for (int w = 0; w < piece.getWidth(); w++) {
      int checkCol = piece.position + w;
      int checkLine = piece.line + piece.getHeightAt(w) + 1;
      
      if (checkLine >= this.rows) {
        return false;
      }
      
      if (cells[checkCol][checkLine].isPermanent()) {
        return false;
      }
    }
    
    return true;
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
 
  boolean canMoveRight(Piece piece) {
    if (cols - piece.getWidth() - piece.position <= 0) {
      return false;
    }
    
    for (int h = 0; h < piece.getHeight(); h++) {
      int checkRow = piece.line + h;
      int checkCol = piece.position + piece.getWidthAtFromRight(h) + 1;
      
      if (cells[checkCol][checkRow].isPermanent()) {
        return false;
      }
    }
    
    return true;
  }
 
  boolean canMoveLeft(Piece piece) {
    if (piece.position <= 0) {
      return false;
    }  
  
    for (int h = 0; h < piece.getHeight(); h++) {
      int checkRow = piece.line + h;
      int checkCol = piece.position + piece.getWidthAtFromLeft(h) - 1;
      
      if (cells[checkCol][checkRow].isPermanent()) {
        return false;
      }
    }
    
    return true;
  }
  
  boolean canRotate(Piece piece) {
    int angle = piece.angle;
    
    piece.rotate();
    
    for (int h = 0; h < piece.getHeight(); h++) {
      for (int w = 0; w < piece.getWidth(); w++) {
        if (piece.at(h, w)) {
          int row = piece.line + h;
          int col = piece.position + w;
          
          if (col >= this.cols || row >= this.rows || cells[col][row].isPermanent()) {
            // rotation not possible
            piece.setAngle(angle); // restore old angle
            return false;
          }
        }
      }
    }
    
    piece.setAngle(angle); // restore old angle
    return true;
  }
}
