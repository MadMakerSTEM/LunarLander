final int ROCKET_SIZE = 100;
final float GRAVITY = 0.016;
final float FRICTION = 0.99;
final float THRUST = 0.05;

int PADWIDTH = 40;
int PADHEIGHT = 10;
float PADPOS = random(-width-50, width-50);  // position of pad

float CRASHVEL = 0.5;  // threshold for crash velocity
final float TURN_VALUE = PI/50;
boolean changed = false;

final float OFFSET = 3*PI/2;
final float CRASH_ANGLE = 0.18;

int lstatus = 0;

PImage img;
boolean thruster = false;
boolean oldthruster = false;
float theta = OFFSET;
boolean[] keys = new boolean[4];

void setupEnvironment() {
  translate(width/2, height/2);
  imageMode(CENTER);
  img = loadImage("rocket.png");
  img.resize(ROCKET_SIZE, 0);
  if (PADPOS < 0 && PADPOS > -PADWIDTH) {
    PADPOS -=  PADWIDTH;
  } else if (PADPOS > 0 && PADPOS < PADWIDTH) {
    PADPOS +=  PADWIDTH;
  }  
}

void drawRocket() {
  if (thruster && changed) {
    changed = false;
    img = loadImage("rocket_flame.png");
    img.resize(ROCKET_SIZE, 0);
  } else if (!thruster && changed) {
    changed = false;
    img = loadImage("rocket.png");
    img.resize(ROCKET_SIZE, 0);
  }
  pushMatrix();
  translate(x, y);
  rotate(theta-OFFSET);
  image(img, 0, 0);
  popMatrix();
}

void landscape() {
  fill(0, 175, 0);
  noStroke();
  rect(-width/2, height/2-(PADHEIGHT), width, height/2);
  strokeWeight(5); 
  stroke(255, 0, 0); 
  fill(255);
  line(PADPOS-PADWIDTH, height/2-PADHEIGHT, PADPOS+PADWIDTH, height/2-PADHEIGHT);
}

int view() {
  background(200);

  translate(width/2, height/2);
  landscape();
  drawRocket();
  if ((lstatus = landed()) > 0) {
    textSize(40); 
    textAlign(CENTER, CENTER);
    if (lstatus == 1) {
      fill(0);
      background(0, 200, 0);
      text("Landed! YEAH! :D", 0, 0);
    } else {
      fill(255);
      background(200, 0, 0);
      text("CRASHED! :( :(", 0, 0);
    }
    return 1;
  }
  return 0;
}

int landed() {
  float left_edge = PADPOS-PADWIDTH;
  float right_edge = PADPOS+PADWIDTH;
  println(theta+PI/2, CRASH_ANGLE, (2*PI)-CRASH_ANGLE);

  if (y+(0.19*130) >= (height-2*PADHEIGHT)/2) {
    translate(0, 0);
    textAlign(CENTER, CENTER);
    fill(0);
    stroke(0);
    textSize(40);
    if (x_speed > CRASHVEL 
      || y_speed > CRASHVEL  
      || (theta+PI/2 > CRASH_ANGLE && theta+PI/2 < (2*PI)-CRASH_ANGLE)
      ||  x-(0.13*ROCKET_SIZE) < left_edge 
      ||  x+(0.13*ROCKET_SIZE) > right_edge) {
      text("YOU CRASHED! :(", width/2, height/2);
      return 2;
    }
    text("YOU LANDED! YAY! :D", width/2, height/2);
    return 1;
  }
  println("left: ", x, x-(0.1*ROCKET_SIZE), left_edge);
  println("right: ", x, x+(0.1*ROCKET_SIZE), right_edge);
  return 0;
}

void turns(float val) {
  theta += val;
  if (theta > 2*PI)
    theta -= 2*PI;
  else if (theta < 0)
    theta += 2*PI;
}

void keyPressed() {
  if (key == CODED) {
    switch (keyCode) {
    case UP:
      keys[0] = true; 
      break;
    case LEFT:
      keys[1] = true;  
      break;
    case RIGHT:
      keys[2] = true; 
      break;
    }
  }
}

void keyReleased() {
  if (key == CODED) {
    switch (keyCode) {
    case UP:
      keys[0] = false;
      if (changed) changed = true;
      break;
    case LEFT:
      keys[1] = false; 
      break;
    case RIGHT:
      keys[2] = false; 
      break;
    }
  }
}

void handleKeys() {
  oldthruster = thruster;
  thruster = keys[0];               // thruster is on or off
  if (thruster != oldthruster) 
    changed = true;
  if (keys[1]) turns(-TURN_VALUE);  // LEFT
  if (keys[2]) turns(TURN_VALUE);   // RIGHT
}