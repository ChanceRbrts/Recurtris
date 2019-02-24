class Instance{
  boolean kPress[];
  boolean kHeld[];
  boolean control;
  float x,y,w,h,dX,dY;
  
  Instance(){
    control = false;
    x = 0;
    y = 0;
    w = 32;
    h = 32;
    dX = 0;
    dY = 0;
  }
  
  public void update(float deltaTime){
  }
  
  public void finishUpdate(float deltaTime){
  }
  
  public void getControls(boolean kP[], boolean kH[]){
    kPress = kP;
    kHeld = kH;
  }
  
  public void toDraw(){
  }
}