// Control Stuff
boolean keyPress[] = new boolean[10];
boolean keyHeld[] = new boolean[10];
// Probably best if I don't do this, but whatever... :(
int up = 0;
int down = 1;
int left = 2;
int right = 3;
int actionA = 4;
int actionB = 5;
int pause = 6;
int escape = 7;
int forward = 8;
double endTime, deltaTime, currentTime;

RoomMan r;

void setup(){
  surface.setTitle("Recurtris");
  size(640, 480);
  deltaTime = 0;
  r = new RoomMan();
}

void draw(){
  currentTime = System.nanoTime()/1000000000.0;
  if (endTime > 0) deltaTime = currentTime-endTime;
  if (deltaTime > 0){
    if (r.gameOver > 0 && keyPress[pause]){
      r = new RoomMan();
      keyPress[pause] = false;
    }
    r.update((float)deltaTime, keyPress, keyHeld);
    for (int i = 0; i < keyPress.length; i++){
      keyPress[i] = false;
    }
    r.toDraw();
  }
  endTime = currentTime;
}

void keyPressed(){
  if (keyCode == UP || key == 'W' || key == 'w'){
    if (!keyHeld[up]){
      keyPress[up] = true;
      keyHeld[up] = true;
    }
  } else if (keyCode == DOWN || key == 'S' || key == 's'){
    if (!keyHeld[down]){
      keyPress[down] = true;
      keyHeld[down] = true;
    }
  } else if (keyCode == LEFT || key == 'A' || key == 'a'){
    if (!keyHeld[left]){
      keyPress[left] = true;
      keyHeld[left] = true;
    }
  } else if (keyCode == RIGHT || key == 'D' || key == 'd'){
    if (!keyHeld[right]){
      keyPress[right] = true;
      keyHeld[right] = true;
    }
  } else if (key == 'Q' || key == 'q'){
    if (!keyHeld[actionA]){
      keyPress[actionA] = true;
      keyHeld[actionA] = true;
    }
  } else if (key == 'E' || key == 'e'){
    if (!keyHeld[actionB]){
      keyPress[actionB] = true;
      keyHeld[actionB] = true;
    }
  } else if (keyCode == ESC){
    key = 0;
    if (!keyHeld[escape]){
      keyPress[escape] = true;
      keyHeld[escape] = true;
    }
  } else if (keyCode == ENTER || keyCode == RETURN){
    if (!keyHeld[pause]){
      keyPress[pause] = true;
      keyHeld[pause] = true;
    }
  } else if (key == ' '){
    if (!keyHeld[forward]){
      keyPress[forward] = true;
      keyHeld[forward] = true;
    }
  }
}

void keyReleased(){
  if (keyCode == UP || key == 'W' || key == 'w'){
    keyHeld[up] = false;
  } else if (keyCode == DOWN || key == 'S' || key == 's'){
    keyHeld[down] = false;
  } else if (keyCode == LEFT || key == 'A' || key == 'a'){
    keyHeld[left] = false;
  } else if (keyCode == RIGHT || key == 'D' || key == 'd'){
    keyHeld[right] = false;
  } else if (key == 'Q' || key == 'q'){
    keyHeld[actionA] = false;
  } else if (key == 'E' || key == 'e'){
    keyHeld[actionB] = false;
  } else if (keyCode == ESC){
    key = 0;
    keyHeld[escape] = false;
  } else if (keyCode == ENTER || keyCode == RETURN){
    keyHeld[pause] = false;
  } else if (key == ' '){
    keyHeld[forward] = false;
  }
}