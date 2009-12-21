class Cell {
  float x, y;
  float w, h;

  boolean on, permanent;

  Cell(float x, float y, float w, float h) {
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
    this.on = false;
    this.permanent = false;
  }
  
  void turnOn() {
    this.on = true;
  }

  void turnOff() {
    this.on = false;
    this.permanent = false;
  }
  
  boolean isPermanent() {
    return this.permanent;
  }
  
  void setPermanent(boolean flag) {
    this.permanent = flag;
  }
  
  void display() {
    stroke(255);

    if (permanent) {
      fill(128);
    } else {
      if (on) {
        fill(255);
      } else {
        fill(0);
      }
    }
    
    rect(x, y, w, h); 
  }
}
