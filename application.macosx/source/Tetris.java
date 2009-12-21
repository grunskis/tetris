import processing.core.*; 
import processing.xml.*; 

import java.applet.*; 
import java.awt.*; 
import java.awt.image.*; 
import java.awt.event.*; 
import java.io.*; 
import java.net.*; 
import java.text.*; 
import java.util.*; 
import java.util.zip.*; 
import java.util.regex.*; 

public class Tetris extends PApplet {

Piece currentPiece;

Grid grid;

float before, now;

boolean stepKey; // DEBUG

int speed;

boolean GAMEOVER;

int score;

public void setup() {
  size(201, 301);
  
  grid = new Grid(10, 15);
  
  currentPiece = randomPiece();
  
  speed = 500; // default speed
  
  GAMEOVER = false;

  score = 0;
  
  before = 0;
}

public void draw() {
  background(0);
  
  if (GAMEOVER) {
    fill(255);
    textFont(createFont("Helvetica", 24));
    text("GAME OVER", 30, 50);
    text("SCORE: " + score, 40, 100);
    return;
  }
  
  if (currentPiece.isDead()) {
    currentPiece = randomPiece();
  }

  if (grid.place(currentPiece) == false) {
      GAMEOVER = true;
  }
  grid.draw();
  
  if (step()) {
    grid.clear();
    
    if (grid.canFall(currentPiece)) {
      currentPiece.fall();
    } else {
      grid.die(currentPiece);
    }
    
    score += grid.removeDeadLines();
  }
}

public void play() {
}

public void keyPressed() {
  if (GAMEOVER) {
    return;
  }
  
  if (key == CODED) {
    switch (keyCode) {
      case RIGHT:
        if (grid.canMoveRight(currentPiece)) {
          currentPiece.right();
        }
        break;
        
      case LEFT:
        if (grid.canMoveLeft(currentPiece)) {
          currentPiece.left();
        }
        break;
        
      case CONTROL:
        if (grid.canRotate(currentPiece)) {
          currentPiece.rotate();
        }
        break;
        
      case DOWN:
        stepKey = true; // DEBUG
        speed = 50;
        break;
    }
    
    grid.clear();
  }
}

public void keyReleased() {
  speed = 500;
}

public boolean step() {
  now = millis();
  
  if (now - before > speed) {
    before = now;
    
    return true;
  }
  
  return false;
}

// DEBUG
public boolean stepKey() {
  if (stepKey) {
    stepKey = false;
    
    return true;
  }
  
  return false;
}

public Piece randomPiece() {
  int piece = round(random(6));
  
  switch (piece) {
    case 0:
      return new I();
    case 1:
      return new J();
    case 2:
      return new L();
    case 3:
      return new O();
    case 4:
      return new S();
    case 5:
      return new T();
    case 6:
      return new Z();
  }
  
  return null;
}
class Cell {
  float x, y;
  float w, h;

  boolean on, permanent;

  Cell(float x, float y, float w, float h, boolean on) {
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
    this.on = on;
    this.permanent = false;
  }
  
  public void turnOn() {
    this.on = true;
  }

  public void turnOff() {
    this.on = false;
    this.permanent = false;
  }
  
  public boolean isPermanent() {
    return this.permanent;
  }
  
  public void setPermanent(boolean flag) {
    this.permanent = flag;
  }
  
  public void display() {
    stroke(255);

    if (permanent) {
      fill(128);
    } else {
      if (this.on) {
        fill(255);
      } else {
        fill(0);
      }
    }
    
    rect(x,y,w,h); 
  }
}
class Grid {
  Cell[][] cells;
  
  int rows, cols;
  
  Grid(int cols, int rows) {
    cells = new Cell[cols][rows];
    
    for (int i = 0; i < cols; i++) {
      for (int j = 0; j < rows; j++) {
        cells[i][j] = new Cell(i*20, j*20, 20, 20, false);
      }
    }
    
    this.rows = rows;
    this.cols = cols;
  }
  
  public void draw() {
    for (int i = 0; i < cols; i++) {
      for (int j = 0; j < rows; j++) {
        cells[i][j].display();
      }
    }
  }
  
  public boolean place(Piece piece) {
    for (int h = 0; h < piece.getHeight(); h++) {
      for (int w = 0; w < piece.getWidth(); w++) { 
        if (piece.at(h, w)) {
          int row = piece.line + h;
          int col = piece.position + w;
          
          if (cells[col][row].isPermanent()) {
            // GAME OVER
            return false;
          }
          
          //if (cells[col][row].isPermanent() == false) {
            cells[col][row].turnOn();
          //}
        }
      }
    }
    
    return true;
  }
  
  public void die(Piece piece) {
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

  private int getPieceHeightAt(Piece piece, int col) {
    for (int i = piece.getHeight()-1; i >= 0; i--) {
      if (piece.at(i, col)) {
        return i;
      }
    }
    
    return 0;
  }
  
  public boolean canFall(Piece piece) {
    for (int w = 0; w < piece.getWidth(); w++) {
      int checkCol = piece.position + w;
      int checkLine = piece.line + getPieceHeightAt(piece, w) + 1;
      
      if (checkLine >= this.rows) {
        return false;
      }
      
      if (cells[checkCol][checkLine].isPermanent()) {
        return false;
      }
    }
    
    return true;
  }
  
  public void clear() {
    for (int i = 0; i < cols; i++) {
      for (int j = 0; j < rows; j++) {
        if (cells[i][j].isPermanent() == false) {
          cells[i][j].turnOff();
        }
      }
    }
  }
  
  public void clearRow(int row) {
    for (int col = 0; col < this.cols; col++) {
      cells[col][row].turnOff();
    }
  }
  
  public int removeDeadLines() {
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

  private int getPieceWidthAtFromRight(Piece piece, int row) {
    for (int i = piece.getWidth()-1; i >= 0; i--) {
      if (piece.at(row, i)) {
        return i;
      }
    }
    
    return 0;
  }
  
  public boolean canMoveRight(Piece piece) {
    if (cols - piece.getWidth() - piece.position <= 0) {
      return false;
    }
    
    for (int h = 0; h < piece.getHeight(); h++) {
      int checkRow = piece.line + h;
      int checkCol = piece.position + getPieceWidthAtFromRight(piece, h) + 1;
      
      if (cells[checkCol][checkRow].isPermanent()) {
        return false;
      }
    }
    
    return true;
  }

  private int getPieceWidthAtFromLeft(Piece piece, int row) {
    for (int i = 0; i < piece.getWidth(); i++) {
      if (piece.at(row, i)) {
        return i;
      }
    }
    
    return piece.getWidth()-1;
  }
  
  public boolean canMoveLeft(Piece piece) {
    if (piece.position <= 0) {
      return false;
    }  
  
    for (int h = 0; h < piece.getHeight(); h++) {
      int checkRow = piece.line + h;
      int checkCol = piece.position + getPieceWidthAtFromLeft(piece, h) - 1;
      
      if (cells[checkCol][checkRow].isPermanent()) {
        return false;
      }
    }
    
    return true;
  }
  
  public boolean canRotate(Piece piece) {
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
class I extends Piece {
 /*
       1
  1111 1
       1
       1
 */
  
  I() {
    super();
    
    piece = new byte[][] {{1, 1, 1, 1}};
    piece90 = new byte[][] {{1}, {1}, {1}, {1}};
    piece180 = piece;
    piece270 = piece90;
  }
  
  public int getWidth() {
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
  
  public int getHeight() {
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
}
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
  
  public int getWidth() {
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
  
  public int getHeight() {
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
class L extends Piece {
 /*
    0  90 180 270
  --- --- --- ---
  111  10 001  11
  100  10 111  01
       11      01
 */
  
  L() {
    super();
    
    piece = new byte[][] {{1, 1, 1}, {1, 0, 0}};
    piece90 = new byte[][] {{1, 0}, {1, 0}, {1, 1}};
    piece180 = new byte[][] {{0, 0, 1}, {1, 1, 1}};
    piece270 = new byte[][] {{1, 1}, {0, 1}, {0, 1}};
  }
  
  public int getWidth() {
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
  
  public int getHeight() {
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
  
  public int getWidth() {
    return 2;
  }
  
  public int getHeight() {
    return 2;
  }
  
  public char getType() {
    return 'O';
  }
}
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
  
  public void fall() {
    if (alive) {
      line += 1;
    }
  }
  
  public void left() {
    if (alive) {
      position -= 1;
    }
  }
  
  public void right() {
    if (alive) {
       position += 1;
    }
  }
  
  public boolean isDead() {
    return (alive == false);
  }
  
  public int getLine() {
    return line;
  }
  
  public void die() {
    alive = false;
  }
  
  public void rotate() {
    if (angle == ANGLE_270) {
      angle = ANGLE_0;
    } else {
      angle++;
    }
  }
  
  public void setAngle(int angle) {
    this.angle = angle;
  }
  
  public int preRotate() {
    if (angle == ANGLE_270) {
      return ANGLE_0;
    } else {
      return (angle + 1);
    }
  }
  
  public abstract int getWidth();
  public abstract int getHeight();
  
  public boolean at(int row, int col) {
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
  
  public boolean atAngle(int row, int col, int a) {
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
  
  public int getWidth() {
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
  
  public int getHeight() {
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
class T extends Piece {
 /*
    0  90 180 270
  --- --- --- ---
  111  10 010  01
  010  11 111  11
       10      01 
 */
  
  T() {
    super();
    
    piece = new byte[][] {{1, 1, 1}, {0, 1, 0}};
    piece90 = new byte[][] {{1, 0}, {1, 1}, {1, 0}};
    piece180 = new byte[][] {{0, 1, 0}, {1, 1, 1}};
    piece270 = new byte[][] {{0, 1}, {1, 1}, {0, 1}};
  }
  
  public int getWidth() {
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
  
  public int getHeight() {
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
  
  public int getWidth() {
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
  
  public int getHeight() {
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

  static public void main(String args[]) {
    PApplet.main(new String[] { "--bgcolor=#FFFFFF", "Tetris" });
  }
}
