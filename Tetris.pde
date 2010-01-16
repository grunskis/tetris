Piece currentPiece;

Grid grid;

float before, now;

int speed;

boolean GAMEOVER;
boolean mustDie;

int linesCleared, piecesPlayed;

void setup() {
  size(201, 401);
  
  grid = new Grid(10, 20);
  
  currentPiece = randomPiece();
  
  speed = 500; // default speed
  
  GAMEOVER = false;

  linesCleared = 0;
  piecesPlayed = 1;
  
  before = 0;
}

void draw() {
  background(0);
  
  if (GAMEOVER) {
    fill(255);
    textFont(createFont("Helvetica", 24));
    text("GAME OVER", 30, 50);
    textFont(createFont("Helvetica", 16));
    text("PIECES PLAYED: " + piecesPlayed, 30, 100);
    text("LINES CLEARED: " + linesCleared, 30, 130);
    return;
  }

  grid.clear();
  if (grid.place(currentPiece) == false) {
      GAMEOVER = true;
  }
  grid.draw();
  
  if (step()) {
    if (grid.canFall(currentPiece)) {
      currentPiece.fall();
    } else {
      mustDie = true;
    }
  }
  
  if (mustDie) {
    grid.die(currentPiece);
    
    linesCleared += grid.removeDeadLines();
    
    mustDie = false;
  }
  
  if (currentPiece.isDead()) {
    currentPiece = randomPiece();
    
    piecesPlayed++;
  }
}

void keyPressed() {
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
        
      case UP:
        // hard drop
        grid.drop(currentPiece);
        mustDie = true;
        break;
        
      case DOWN:
        // soft drop
        speed = 50;
        break;
    }
  }
}

void keyReleased() {
  speed = 500;
}

boolean step() {
  now = millis();
  
  if (now - before > speed) {
    before = now;
    
    return true;
  }
  
  return false;
}

Piece randomPiece() {
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
