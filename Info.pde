class InfoLayer extends PLayer {

  Grid grid; // grid for next piece
  
  Piece nextPiece;

  InfoLayer(PApplet parent) {
    super(parent); // This is necessary!
  }

  void setup() {
    clipX = 0;
    clipY = 0;
    clipWidth = 100; 
    clipHeight = height;

    grid = new Grid(4, 2, 10, 320);
  }

  void draw() {  
    background(0, 0); // clear the background every time, but be transparent
    
    stroke(128);
    line(99, 0, 99, height);
    
    textFont(smallFont);
    fill(128);
    text("LEVEL", 10, 40);
    fill(255);
    text(level, 10, 70);
    
    fill(128);
    text("SCORE", 10, 110);
    fill(255);
    text(score, 10, 140);
    
    fill(128);
    text("TOP", 10, 180);
    fill(255);
    text(top, 10, 210);
    
    if (!GAMEOVER) {
      fill(128);
      text("NEXT", 10, 300);
  
      grid.clear();
      grid.place(nextPiece);
      grid.draw();
    }
  }
  
  void setNextPiece(Piece piece) {
    piece.column = 0;
    this.nextPiece = piece;
  }
}
