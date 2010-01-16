class O extends Piece {  
  O() {
    super();
    
    piece = new byte[][][] {
      {
        {1, 1}, 
        {1, 1}
      },
      {
        {1, 1}, 
        {1, 1}
      },
      {
        {1, 1}, 
        {1, 1}
      },
      {
        {1, 1}, 
        {1, 1}
      }
    };
  }
  
  int getWidth() {
    return 2;
  }
  
  int getHeight() {
    return 2;
  }
}
