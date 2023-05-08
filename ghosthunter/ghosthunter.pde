final int INIT_GHOST_NUM = 10; // # of ghosts at game start
final int INIT_BULLETS = 10;   // # of bullets at game start

final float W = 80;  // ghost width
final float H = 60;  // ghost height
final float MAX_SPEED = 5; // max movement speed of the ghost

int ghostKilled;  // # of ghost been killed
int ghostWho;     //哪一隻鬼
int bullets;      // # of bullets


float []ghostX = new float[INIT_GHOST_NUM];
float []ghostY = new float[INIT_GHOST_NUM];
float []ghostXSpeed = new float[INIT_GHOST_NUM];
float []ghostYSpeed = new float[INIT_GHOST_NUM];
boolean []ghostAlive = new boolean[INIT_GHOST_NUM];

int currentFrame = 0;
int numFrames = 5;
PImage []flame = new PImage[numFrames];
boolean playAnimation = false;

PImage ghost;
//PImage flame1, flame2, flame3, flame4, flame5;

PFont myFont;

void setup() {
  size(600, 600);
  ghost = loadImage("ghost.png");
  for (int i = 0; i < numFrames; i++) {
    flame[i] = loadImage("flame"+(i+1)+".png");
  }

  myFont = createFont("Georgia", 32);
  textFont(myFont);
  textAlign(CENTER, CENTER);

  ghostKilled = 0;
  bullets = INIT_BULLETS;


  // random position
  for (int i = 0; i < INIT_GHOST_NUM; i++) {
    ghostX[i] = random (0, width-W);
    ghostY[i] = random (0, height-H);
    ghostAlive[i] = true;

    // ensure the speed is not too low
    do {
      ghostXSpeed[i] = random(-MAX_SPEED, MAX_SPEED);
      ghostYSpeed[i] = random(-MAX_SPEED, MAX_SPEED);
    } while ( abs (ghostXSpeed[i]) < 1 || abs (ghostYSpeed[i]) < 1);
  }
}
void draw() {
  background(0);


  // show bullets
  noStroke();
  fill(255, 0, 0);
  for (int j=0; j < bullets; j++) {
    rect(j*10+10, 10, 5, 10);
  }

  // move ghost
  for (int i = 0; i < INIT_GHOST_NUM; i++) {
    ghostX[i] += ghostXSpeed[i];
    ghostY[i] += ghostYSpeed[i];
    //boundary bouncing
    if (ghostX[i] < 0 || ghostX[i]> width-W) {
      ghostXSpeed[i] *= -1;
    }
    if (ghostY[i] < 0 || ghostY[i] > height-H) {
      ghostYSpeed[i] *= -1;
    }
    // show ghost
    if (ghostAlive[i] == true) {
      image(ghost, ghostX[i], ghostY[i], W, H);
    }
  }

  // show number of kills
  text("Kills:"+ ghostKilled, 500, 16);

  // show game over
  if (bullets == 0 && ghostKilled != INIT_GHOST_NUM) {
    text("GAME OVER", width/2, height/2);
  }

  // kill all ghost
  if (ghostKilled == INIT_GHOST_NUM) {
    // restart the game
    setup();
  }

  if (playAnimation == true) {
    int number = (currentFrame++) % numFrames;
    image(flame[number], ghostX[ghostWho], ghostY[ghostWho], W, H);
    if (number == numFrames-1) {
      playAnimation = false;
      currentFrame = 0 ;
    }
  }
}

void keyPressed() {
  if (key == ENTER) {
    // restart the game
    setup();
  }
}

void mousePressed() {
  float d;
  for (int i = 0; i < INIT_GHOST_NUM; i++) {
    d = dist(mouseX, mouseY, ghostX[i]+W/2, ghostY[i]+H/2);
    if (bullets > 0 ) {
      // hit
      if (ghostAlive[i] == true) {
        if (d < W/2) {
          ghostKilled++;
          ghostWho = i;
          ghostAlive[i] = false;
          playAnimation = true;
        }
      }
    }
  }
  bullets--;
}
