Piece currentPiece;

Grid grid;

float before, now;

boolean stepKey; // DEBUG

int speed;

boolean GAMEOVER;

int score;

void setup() {
  size(201, 401);
  
  grid = new Grid(10, 20);
  
  currentPiece = randomPiece();
  
  speed = 500; // default speed
  
  GAMEOVER = false;

  score = 0;
  
  before = 0;
}

void draw() {
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

void play() {
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
        
      case DOWN:
        stepKey = true; // DEBUG
        speed = 50;
        break;
    }
    
    grid.clear();
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

// DEBUG
boolean stepKey() {
  if (stepKey) {
    stepKey = false;
    
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
