class TetrisInstance extends Instance{
  private boolean blocks[][];
  private Block b;
  private int[][] curBlock;
  private int[] nextBlock;
  private int red,green,blue;
  private int blockXPos, blockYPos;
  private int linesCleared, score;
  private boolean pieceThere, lost;
  private double dropTime, maxDropTime;
  private int layer;
  private double dropMul;
  TetrisInstance(int l){
    super();
    red = (int)random(0,255);
    green = (int)random(0,255);
    blue = (int)random(0,255);
    linesCleared = 0;
    control = true;
    blocks = new boolean[24][12];
    dropMul = 1/sqrt(l);
    dropTime = 1*dropMul;
    maxDropTime = 1*dropMul;
    b = new Block();
    curBlock = b.createBlock((int)(random(0,7)));
    repositionBlock();
    nextBlock = new int[3];
    lost = false;
    for (int i = 0; i < nextBlock.length; i++){
      nextBlock[i] = (int)(random(0,7));
    }
    pieceThere = true;
    layer = l;
  }
  
  private void repositionBlock(){
    blockXPos = blocks[0].length/2;
    blockYPos = 0;
    if (blocks[blockYPos][blockXPos]){
      lost = true;
      return; // Lost Tetris... :(
    }
    int rotations = 0;
    boolean keepGoing = true;
    while (keepGoing && rotations < 4){
      keepGoing = false;
      for (int i = 0; i < curBlock.length; i++){
        if (blockXPos+curBlock[i][0] >= 0 && blockYPos+curBlock[i][1] >= 0){
          if (blocks[blockYPos+curBlock[i][1]][blockXPos+curBlock[i][0]]){
            keepGoing = true;
            curBlock = b.rotate(curBlock, true);
            rotations += 1;
            break;
          }
        }
      }
    }
    lost = (rotations >= 4);
  }
  
  public void update(float deltaTime){
    super.update(deltaTime);
    dropTime -= deltaTime;
    // print(kHeld[down]+"\n");
    if (dropTime < 0 || (kHeld[down] && pieceThere)){
      boolean deadBlock = false;
      for (int i = 0; i < curBlock.length; i++){
        if (blockYPos+curBlock[i][1]+1 >= blocks.length) deadBlock = true;
        else if (blockYPos+curBlock[i][1] >= 0 && blocks[blockYPos+curBlock[i][1]+1][blockXPos+curBlock[i][0]]) 
          deadBlock = true;
      }
      if (deadBlock){
        pieceThere = false;
        for (int i = 0; i < curBlock.length; i++){
          if (blockYPos+curBlock[i][1] >= 0){
            blocks[blockYPos+curBlock[i][1]][blockXPos+curBlock[i][0]] = true;
          }
        }
        checkRows();
        nextBlock();
      } else blockYPos += 1;
      dropTime = maxDropTime;
    }
    // Move Piece
    int prospX = blockXPos;
    if (kPress[left] && !kPress[right]){
      prospX -= 1;
    } else if (kPress[right] && !kPress[left]){
      prospX += 1;
    }
    // Rotate Piece
    int[][] prospBlock = new int[4][2];
    arrayCopy(curBlock, prospBlock);
    if (kPress[actionA] && !kPress[actionB]) prospBlock = b.rotate(prospBlock, false);
    else if (kPress[actionB] && !kPress[actionA]) prospBlock = b.rotate(prospBlock, true);
    // Check if pieces can be moved to those locations.
    boolean safe = true;
    for (int i = 0; i < prospBlock.length; i++){
      int bX = prospX+prospBlock[i][0];
      int bY = blockYPos+prospBlock[i][1];
      if (bY > blocks.length || bX < 0 || bX >= blocks[0].length 
          || (bY >= 0 && blocks[bY][bX])){
        safe = false;
      }
    }
    
    if (safe){ 
      curBlock = prospBlock;
      blockXPos = prospX;
    }
    
    if (!kHeld[down]) pieceThere = true;
  }
  
  private void nextBlock(){
    curBlock = b.createBlock(nextBlock[0]);
    for (int i = 0; i < nextBlock.length-1; i++){
      nextBlock[i] = nextBlock[i+1];
    }
    nextBlock[nextBlock.length-1] = (int)(random(0,7));
    repositionBlock();
  }
  
  private void checkRows(){
    int rowsInARow = 0;
    int rowDelta = 0;
    for (int i = blocks.length-1; i >= 0; i--){
      boolean fullRow = true;
      for (int j = 0; j < blocks[i].length; j++){
        if (!blocks[i][j]) fullRow = false;
        blocks[i+rowDelta][j] = blocks[i][j];
      }
      if (fullRow){
        rowDelta += 1;
        linesCleared += 1;
        rowsInARow += 1;
        score += 100*rowsInARow*sqrt(layer)*(float)(1/maxDropTime);
        for (int j = 0; j < blocks[i].length; j++) blocks[i][j] = false;
      }
    }
    maxDropTime = (1+3*floor(linesCleared/5))*dropMul;
  }
  
  public void toDraw(){
    noStroke();
    fill(10,10,10);
    rect(x,y,640,480);
    fill(150,150,150);
    rect(x+20,y+20,blocks[0].length*16,blocks.length*16);
    stroke(0,0,0);
    strokeWeight(4);
    fill(100,100,100);
    for (int i = 0; i < blocks.length; i++){
      for (int j = 0; j < blocks[i].length; j++){
        if (blocks[i][j]){
          rect(x+j*16+20, y+i*16+20, 16, 16);
        }
      }
    }
    fill(red,green,blue);
    for (int i = 0; i < curBlock.length; i++){
      int Y = curBlock[i][1]+blockYPos;
      int X = curBlock[i][0]+blockXPos;
      if (Y >= 0){
        rect(x+X*16+20,y+Y*16+20,16,16);
      }
    }
    fill(255,255,255);
    textAlign(LEFT, TOP);
    textSize(24);
    text("Layer " + str(layer), 320, 40);
    text("Lines Cleared: " + str(linesCleared), 320, 80);
    text("Next:", 320, 120);
    text("L" + str(layer) + " Score: " + str(score), 320, 220);
    fill(red,green,blue);
    stroke(0,0,0);
    strokeWeight(4);
    for (int i = 0; i < nextBlock.length; i++){
      int[][] nB = b.createBlock(nextBlock[i]);
      for (int j = 0; j < nB.length; j++){
        rect(364+i*64+nB[j][0]*16, 172+nB[j][1]*16,16,16);
      }
      rect(364+i*64, 172,16,16);
    }
  }
  
  public boolean getLost(){ 
    return lost; 
  }
  
  public int getLinesCleared(){
    return linesCleared;
  }
  
  public int getScore(){
    return score;
  }
}

class Block{
  int[][] createBlock(int shape){
    int blocks[][];
    if (shape == 0){ // Line
      blocks = new int[][]{new int[]{0,-1}, new int[]{0,1}, new int[]{0,2}};
    } else if (shape == 1){ // T-Shape
      blocks = new int[][]{new int[]{0,-1}, new int[]{-1,0}, new int[]{1,0}};
    } else if (shape == 2){ // L-Shape
      blocks = new int[][]{new int[]{0,-1}, new int[]{0,1},  new int[]{1,1}};
    } else if (shape == 3){ // J Shape
      blocks = new int[][]{new int[]{0, -1}, new int[]{0,1}, new int[]{-1,1}};
    } else if (shape == 4){ // S Shape
      blocks = new int[][]{new int[]{-1, 0}, new int[]{0,1}, new int[]{1,1}};
    } else if (shape == 5){ // Z Shape
      blocks = new int[][]{new int[]{1,0}, new int[]{0,1}, new int[]{-1,1}};
    } else { // Square
      blocks  = new int[][]{new int[]{-1,1}, new int[]{-1,0}, new int[]{0,1}};
    }
    return blocks;
  }
  
  public int[][] rotate(int[][] blocks, boolean right){
    for (int i = 0; i < blocks.length; i++){
      int newX = right ? -blocks[i][1] : blocks[i][1];
      int newY = right ? blocks[i][0] : -blocks[i][0];
      blocks[i] = new int[]{newX, newY};
    }
    return blocks;
  }
}