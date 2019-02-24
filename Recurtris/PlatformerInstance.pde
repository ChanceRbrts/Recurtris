class Gravity_Instance extends Instance{
  void update(float deltaTime){
    super.update(deltaTime);
    dY += 12*deltaTime;
    if (dY > 16) dY = 16;
  }
}