final int ROCKET_SIZE = 100;    // rocket size

int PADWIDTH = 40;
int PADHEIGHT = 10;
float PADPOS = random(-width-50, width-50);  // position of pad

float CRASHVEL = 0.5;  // threshold for crash velocity
final float TURN_VALUE = PI/50;    
boolean changed = false; 


final float CRASH_ANGLE = 0.18;  // angle away from vertical in radians to decide a crash

int lstatus = 0;

PImage img;
boolean thruster = false;           // value of thruster
boolean oldthruster = false;        // previous value of the thruster

boolean[] keys = new boolean[4];    // store the state of each key

// Setup the environement, runs one in setup
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

// draw the image of the rocket ship
void drawRocket() {
  if (thruster && changed) {
    changed = false;
    img = loadImage("rocket_flame.png");
    img.resize(ROCKET_SIZE, 0);
  } 
  else if (!thruster && changed) {
    changed = false;
    img = loadImage("rocket.png");
    img.resize(ROCKET_SIZE, 0);
  }
  pushMatrix();                  // push the matrix so the rocket rotates independently
  translate(x, y);               // (0, 0) point to center of rocket
  rotate(theta-OFFSET);          // rotate the canvas
  image(img, 0, 0);              // draw the rocket
  popMatrix();                   // back to normal mode
}

// Draw the ground and the pad
void landscape() {
  fill(0, 175, 0);
  noStroke();
  rect(-width/2, height/2-(PADHEIGHT), width, height/2);
  strokeWeight(5); 
  stroke(255, 0, 0); 
  fill(255);
  line(PADPOS-PADWIDTH, height/2-PADHEIGHT, PADPOS+PADWIDTH, height/2-PADHEIGHT);
}

// Runs every frame, main function that sets up what to display
// returns 0 as normal, 1 if game over
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
    } 
    else {
      fill(255);
      background(200, 0, 0);
      text("CRASHED! :( :(", 0, 0);
    }
    return 1;
  }
  return 0;
}

// Check if the rocket has landed
// returns 0 if normal, 1 if success, 2 if crashed
int landed() {
  float left_edge = PADPOS-PADWIDTH;
  float right_edge = PADPOS+PADWIDTH;

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
  return 0;
}

// Turn the rocket
void turns(float val) {
  theta += val;
  if (theta > 2*PI)
    theta -= 2*PI;
  else if (theta < 0)
    theta += 2*PI;
}

// Check if the keys have been pressed
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

// Check if the keys have been released
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

// Decide what to do based on the state of each key
void handleKeys() {
  oldthruster = thruster;
  thruster = keys[0];               // thruster is on or off
  if (thruster != oldthruster) 
    changed = true;
  if (keys[1]) turns(-TURN_VALUE);  // LEFT
  if (keys[2]) turns(TURN_VALUE);   // RIGHT
}