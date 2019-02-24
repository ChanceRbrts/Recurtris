class Room{
  ArrayList<Instance> in;
  int layer;
  boolean paused;
  boolean[] kPress;
  boolean[] kHeld;
  Room(int l){
    layer = l;
  }
  
  public void control(boolean[] kePress, boolean[] keHeld){
    kPress = kePress;
    kHeld = keHeld;
  }
  
  public int getScore(){
    return 0;
  }
  
  public boolean getLost(){
    return false;
  }
   
  public void update(float deltaTime){
    if (!paused){
      for (int i = 0; i < in.size(); i++){
        Instance ins = in.get(i);
        if (ins.control) ins.getControls(kPress, kHeld);
        in.get(i).update(deltaTime);
      }
      /*for (int i = 0; i < in.size(); i++){
        in.get(i).finishUpdate(deltaTime);
      }*/
    }
    if (kPress[pause]) paused = !paused;
  }
   
  public void toDraw(){
    for (int i = 0; i < in.size(); i++){
      in.get(i).toDraw();
    }
  }
  
  public boolean addNewLayer(){
    return false;
  }
}

class TetrisRoom extends Room{
  TetrisInstance tetGame;
  TetrisRoom(int l){
    super(l);
    in = new ArrayList<Instance>();
    tetGame = new TetrisInstance(l);
    in.add(tetGame);
  }
  
  public int getScore(){
    return tetGame.score;
  }
  
  public boolean addNewLayer(){
    return tetGame.getLinesCleared() >= 5;
  }
  
  public boolean getLost(){
    return tetGame.getLost();
  }
}

class RoomList{
  Room r;
  RoomList prev;
  RoomList next;
  
  RoomList(Room R){
    r = R;
    next = null;
  }
  
  void update(float deltaTime){
      r.update(deltaTime);
      if (!r.paused){
        if (next != null) next.update(deltaTime);    
      }
  }
  
  void toDraw(int layer){
    if (layer < 4){ 
      r.toDraw();
      if (prev != null){
        fill(150,150,150);
        noStroke();
        rect(236,276,168,148);
        fill(0,0,0);
        textAlign(LEFT, TOP);
        textSize(16);
        text("Prev: (Esc)", 240,280);
        pushMatrix();
        translate(240,300);
        scale(0.25);
        prev.toDraw(layer+1);
        popMatrix();
      } if (next != null){
        fill(150,150,150);
        noStroke();
        rect(436,276,168,148);
        fill(0,0,0);
        textAlign(LEFT, TOP);
        textSize(16);
        text("Next: (Space)", 440,280);
        pushMatrix();
        translate(440,300);
        scale(0.25);
        next.toDraw(layer+1);
        popMatrix();
      }
      if (r.paused){
        noStroke();
        fill(255,255,255,100);
        rect(0,0,width,height);
        fill(0,0,0);
        textAlign(CENTER, CENTER);
        textSize(64);
        text("LAYER " + str(r.layer) + " PAUSED!", width/2, height/2);
      }
    }
    
  }
}

class RoomMan{
  int gameOver;
  int highScore, maxLayer;
  RoomList first;
  RoomList cur;
  RoomList last;
  boolean[] emptyArray;
  int score;
  RoomMan(){
    first = new RoomList(new TetrisRoom(1));
    cur = first;
    last = first;
    emptyArray = new boolean[10];
    gameOver = 0;
  }
  
  void update(float deltaTime, boolean[] kPress, boolean[] kHeld){
    if (gameOver == 0){
      for (RoomList l = first; l != null; l = l.next){
        if (l == cur) l.r.control(kPress,kHeld);
        else l.r.control(emptyArray, emptyArray);
        if (l.r.getLost()) gameOver = l.r.layer;
      }
      if (gameOver > 0){
        score = 0;
        for (RoomList l = first; l != null; l = l.next){
          score += l.r.getScore();
        }
      }
      // Check for a Game Over
      first.update(deltaTime);
      if (kPress[escape] && cur.prev != null) cur = cur.prev;
      if (kPress[forward] && cur.next != null && !cur.r.paused) cur = cur.next;
      if (last.r.addNewLayer())
        addLayer();
    }
  }
  
  void toDraw(){
    cur.toDraw(0);
    if (gameOver > 0){
      fill(255,0,0,100);
      rect(0,0,640,480);
      fill(255,255,255);
      textSize(64);
      textAlign(CENTER, CENTER);
      text("GAME OVER!", width/2, 80);
      textSize(48);
      text("Layer " + str(gameOver) + " has fallen. :(", width/2, 150);
      textSize(32);
      text("Layers Uncovered: " + str(last.r.layer) + ".", width/2, 270);
      text("Total Score: " + str(score) + ".", width/2, 320); 
      textSize(32);
      text("Press Enter to Start Again!", width/2, 400);
    }
  }
  
  void addLayer(){
    RoomList bLast = last;
    last = new RoomList(new TetrisRoom(bLast.r.layer+1));
    bLast.next = last;
    last.prev = bLast;
  }
}