import com.nootropic.processing.layers.*;

PAppletLayers layers;

Piece currentPiece, nextPiece;

Grid grid;

float before, now;

int speed;

boolean GAMEOVER;
boolean mustDie;

int piecesPlayed;

int score, level, top;

PFont largeFont, smallFont;

void setup() {
  size(301, 401);

  layers = new PAppletLayers(this);

  grid = new Grid(10, 20, 100, 0);

  currentPiece = randomPiece();
  nextPiece = randomPiece();
 
  InfoLayer m = new InfoLayer(this);
  layers.addLayer(m);
  
  m.setNextPiece(nextPiece);

  smallFont = createFont("Silkscreen", 24);
  largeFont = createFont("Silkscreen", 48);

  speed = 500; // level1 speed

  GAMEOVER = false;

  score = 0;
  piecesPlayed = 1;
  level = 1;
  
  byte topscores[] = loadBytes("lib/topscore.dat");
  if (topscores == null) {
    top = 0;
  } else {
    top = topscores[0];
  }

  before = 0;
}

void draw() {
  background(0);

  if (GAMEOVER) {
    fill(255);
    textFont(largeFont);
    text("GAME", 130, 100);
    text("OVER", 130, 160);
    
    if (score > top) {
      byte[] topscore = { (byte)score }; 
      saveBytes("lib/topscore.dat", topscore);
    }
    
    return;
  }

  grid.clear();
  if (grid.place(currentPiece) == false) {
    GAMEOVER = true;
  }
  grid.draw();

  if (step()) {
    if (grid.canMoveDown(currentPiece)) {
      currentPiece.moveDown();
    } 
    else {
      mustDie = true;
    }
  }

  if (mustDie) {
    grid.die(currentPiece);

    int cleared = grid.removeDeadLines();
    score += cleared;
    
    if (cleared > 0) {
      level = 1 + (score / 5);
      
      speed = 500 - ((level-1) * 20);
    }

    mustDie = false;
  }

  if (currentPiece.isDead()) {
    nextPiece.column = nextPiece.getSpawnPosition();
    currentPiece = nextPiece;
    nextPiece = randomPiece();
    
    InfoLayer info = (InfoLayer) layers.getLayer(0);
    info.setNextPiece(nextPiece);

    piecesPlayed++;
  }
}

void paint() {
  // This method MUST be present in your sketch for layers to be rendered!
  if (layers != null) {
    layers.paint(this);
  } else {
    super.paint();
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
        currentPiece.moveRight();
      }
      break;

    case LEFT:
      if (grid.canMoveLeft(currentPiece)) {
        currentPiece.moveLeft();
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
  speed = 500 - ((level-1) * 20);
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


