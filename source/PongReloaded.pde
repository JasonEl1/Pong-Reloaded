/********************
 *PONG RELOADED     *
 *Game of pong      *
 *with menu and     *
 *added game modes  *
 *******************/


int ballSize = 50; //variable to store the size of the ball

int ballX; // variables to store the position of the ball
int ballY; //

int ballXspeed = 0; //variables to store the speed of the ball
int ballYspeed = 0; //

int state = 0; //variable to keep track of what screen is shown to player and what methods are run

static int paddleL = 100; //static variables to keep track of the x positions of both paddles
static int paddleR = 1300; //

int paddleSizeR = 200; //variables to keep track of the sizes of both paddles
int paddleSizeL = 200; //

int rRate = 8; //variables to store the max speed the paddles can move
int lRate = 8; //

int AIrate = 7; //variable to store the max speed the AI can move at

int paddleLY = 400; //variables to store the y positions of both paddles
int paddleRY = 400; //

boolean mouseIsClicked = false; //variable to store whether or not the mouse is clicked

int mouseXpos; //variables to store the position of the mouse
int mouseYpos; //

boolean spacePressed = false; //variable to store whether or not the spacebar is pressed

boolean wait = true; //variable to wait for the spacebar to be pressed after point is scored

boolean rPaddleUp = false; //boolean switches for paddle movement
boolean rPaddleDown = false; //
boolean lPaddleUp = false; //
boolean lPaddleDown = false; //

int scoreL = 0; //variables to keep track of score
int scoreR = 0; //

boolean leftScored = false; //variables to keep track of who has scored last
boolean rightScored = true; //

boolean gameOver = false; //variable to keep track of whether or not the game is over


int sliderStart = 500; // variables for ball speed slider in settings
int sliderEnd = 1000; //
int ballSpeedSlider = (sliderStart+sliderEnd)/2; //


int unscaledmouseX; //variables for the 'unscaled' coordinates of the mouse
int unscaledmouseY; //

int angle; //variable to store the angle (y speed ) of the ball after hitting the paddle

float yIntercept; //variables for AI
float xIntercept; //
float slope; //
float yPOI; //

boolean fastMode = false; //boolean variable for fast mode in arcade


void setup() {

  size(1400, 800); //sets size of window

  ballX = width/2; //sets the default ball position to be in the center of the screen
  ballY = height/2; //

  surface.setResizable(true); // makes the window scaleable

  background(#000000); //black
}


void draw() {

  if (state == 0) {

    homeScreen();
  }
  if (state == 1) {

    singleDifficulty();
  }
  if (state == 2) {

    doublePlayer();
  }
  if (state == 3) {

    arcade();
  }
  if (state == 4) {

    HTP();
  }
  if (state==5) {

    sett();
  }
  if (state == 6) {

    singleEasy();
  }
  if (state == 7) {

    singleMedium();
  }
  if (state == 8) {

    singleHard();
  }
  if (state==9) {

    smallPaddles();
  }
  if (state==10) {

    fastSpeed();
  }
  if (state==11) {

    largeBall();
  }
}




void drawBall(int ballX, int ballY) { //method to draw the ball

  fill(#FFFFFF); //white

  scaledEllipse(ballX, ballY, ballSize, ballSize);
}

void drawPaddles() { //method to draw the paddles

  fill(#FFFFFF); //white

  rectMode(CENTER); //sets the rectMode to CENTER

  scaledRect(paddleL, paddleLY, 20, paddleSizeL, 0);

  scaledRect(paddleR, paddleRY, 20, paddleSizeR, 0);

  rectMode(CORNER);
}

void movePaddleR() { //method to move right paddle

  if (rPaddleUp == true && paddleRY > paddleSizeR/2) {

    paddleRY = paddleRY - rRate;
  }
  if (rPaddleDown == true && paddleRY < 800-paddleSizeR/2) {

    paddleRY = paddleRY + rRate;
  }
}

void movePaddleL() { //method to move left paddle

  if (lPaddleUp == true && paddleLY > paddleSizeL/2) {

    paddleLY = paddleLY - lRate;
  }
  if (lPaddleDown == true && paddleLY < 800-paddleSizeL/2) {

    paddleLY = paddleLY + lRate;
  }
}


void moveBall() { //method to move the ball

  if (wait==false) {


    ballX = ballX + ballXspeed; //move ball

    ballY = ballY + ballYspeed; //


    if (ballX>1400 - ballSize/2) { //if ball hits right wall

      ballXspeed = abs(ballXspeed) * -1; //make ball x speed negative
    }


    if (ballX < 0 + ballSize/2) { //if ball hits left wall

      ballXspeed = abs(ballXspeed); //make ball x speed positive
    }


    if (ballY < 0 + ballSize/2) { //if ball hits 'ceiling', make ball y speed positive

      ballYspeed = abs(ballYspeed);
    }


    if (ballY > 800 - ballSize/2) { //if ball hits 'ground', make ball y speed negative

      ballYspeed = abs(ballYspeed) * -1;
    }
  }
}

void checkBallHitPaddleR() { //method to check if the ball hits the right paddle.

  int ballT = ballY - ballSize/2; //dummy variables
  int ballB = ballY + ballSize/2; //
  int ballR = ballX + ballSize/2; //

  int paddleRT = paddleRY - paddleSizeR/2; //
  int paddleRB = paddleRY + paddleSizeR/2; //
  int paddleRL = paddleR - 10; //
  int paddleRR = paddleR + 10; //

  if (ballR > paddleRL && ballR < paddleRR && ballB > paddleRT && ballT < paddleRB) {

    ballXspeed = abs(ballXspeed)*-1; //make ball x speed negative

    angle = abs(ballX-paddleRY)/50;

    ballYspeed = angle;
  }
}

void checkBallHitPaddleL() { //method to check if the ball hits the left paddle

  int ballT = ballY - ballSize/2; //dummy variables
  int ballB = ballY + ballSize/2; //
  int ballL = ballX - ballSize/2; //

  int paddleLT = paddleLY - paddleSizeL/2; //
  int paddleLB = paddleLY + paddleSizeL/2; //
  int paddleLR = paddleL + 10; //
  int paddleLL = paddleL -10;

  if (ballL < paddleLR && ballL > paddleLL && ballB > paddleLT && ballT < paddleLB) {

    ballXspeed = abs(ballXspeed); //make ball x speed positive
  }
}

void checkIfScored() { //method to check if anyone has scored

  if (ballX + ballSize/2 >= 1400) { //if the ball crosses the right border

    wait = true;

    scoreL ++; //left score increases by one

    ballX = 700; //resets variables to defaults
    ballY = 400; //
    ballXspeed = 0; //
    ballYspeed = 0; //

    paddleLY = height/2; //
    paddleRY = height/2; //

    leftScored = true; //
    rightScored = false; //
  }
  if (ballX - ballSize/2 <= 0) { //if the ball crosses the left border

    scoreR ++; //increase the right score by one

    ballX = width/2; //reset variables to defaults
    ballY = height/2; //
    ballXspeed = 0; //
    ballYspeed = 0; //

    rightScored = true;
    leftScored = false;
  }

  if ((rightScored == true && leftScored == true) || (rightScored == false && leftScored == false)) { //if both end up being the same, default to the ball going to the right

    leftScored = false;
    rightScored = true;
  }

  checkGameOver();
}

void checkGameOver() {

  if (scoreL == 5 || scoreR == 5) {

    gameOver = true;
    gameOver();
    wait = true;
  }
}

void drawScore() { //method to draw the score

  fill(#FFFFFF); //white

  scaledText(scoreL, 600, 100, 60); //draws the score
  scaledTextS(" - ", 665, 100, 60); //
  scaledText(scoreR, 760, 100, 60); //
}

void gameOver() { //method that is called when it is game over

  if (gameOver == true) {

    if (scoreL > scoreR) {

      fill(#000000);

      scaledRect(580, 280, 300, 100, 0);

      fill(#FFFFFF);

      scaledTextS("Left wins!", 610, 350, 50);
    } else {


      fill(#000000);

      scaledRect(580, 280, 300, 100, 0);

      fill(#FFFFFF);

      scaledTextS("Right wins!", 600, 350, 50);
    }



    if (scaledIfNOW(400, 500, 450, 700)) {

      fill(#FFFFFF);

      scaledRect(450, 400, 250, 100, 50);

      fill(#000000);
      scaledTextS("Menu", 510, 465, 50);
    } else {

      fill(#000000);
      scaledRect(450, 400, 250, 100, 50);
      fill(#FFFFFF);
      scaledTextS("Menu", 510, 465, 50);
    }

    if (scaledIf(400, 500, 450, 700)) {


      state = 0;
      initialize();
      
    }

    if (scaledIfNOW(400, 500, 700, 1000)) {

      fill(#FFFFFF);

      scaledRect(750, 400, 250, 100, 50);

      fill(#000000);

      scaledTextS("Play again", 765, 465, 45);
    } else {

      fill(#000000);

      scaledRect(750, 400, 250, 100, 50);

      fill(#FFFFFF);

      scaledTextS("Play again", 765, 465, 45);
    }

    if (scaledIf(400, 500, 700, 1000)) {

      initialize();
    }
  }
}

void initialize() { // method that sets all game variables back to their defaults

  paddleSizeR = 200;
  paddleSizeL = 200;

  fastMode = false;

  ballSize = 50;

  ballXspeed = 0;
  ballYspeed = 0;
  ballX = width/2;
  ballY = height/2;

  paddleLY = height/2;
  paddleRY = height/2;

  scoreR = 0;
  scoreL = 0;

  wait = true;

  gameOver = false;
}


void homeScreen() { //method for the homescreen

  background(#000000); //black

  stroke(#FFFFFF); //white

  fill(#FFFFFF); //white

  scaledTextS("v.2.1", 1300, 50, 30);

  scaledTextS("PONG", 430, 240, 200);

  scaledTextS("RELOADED", 200, 440, 200);

  //unscaledMousePos(mouseX,mouseY);


  if (scaledIfNOW(550, 650, 60, 460)) { //one player button

    fill(#FFFFFF); //white

    scaledRect(60, 550, 400, 100, 50);

    fill(#000000); //black

    scaledTextS("One player", 110, 620, 60);
  } else {
    fill(#000000); 

    scaledRect(60, 550, 400, 100, 50);

    fill(#FFFFFF);

    scaledTextS("One player", 110, 620, 60);
  }

  if (scaledIf(550, 650, 60, 460)) {

    state = 1;
  }



  if (scaledIfNOW(550, 650, 510, 910)) { //two player button


    fill(#FFFFFF);
    scaledRect(510, 550, 400, 100, 50);
    fill(#000000);
    scaledTextS("Two player", 550, 620, 60);
  } else {
    fill(#000000);
    scaledRect(510, 550, 400, 100, 50);
    fill(#FFFFFF);
    scaledTextS("Two player", 550, 620, 60);
  }

  if (scaledIf(550, 650, 510, 910)) {
    state = 2;
  }




  if (scaledIfNOW(550, 650, 960, 1360)) { //arcade mode button

    fill(#FFFFFF);
    scaledRect(960, 550, 400, 100, 50);
    fill(#000000);
    scaledTextS("Arcade", 1060, 620, 60);
  } else {
    fill(#000000);
    scaledRect(960, 550, 400, 100, 50);
    fill(#FFFFFF);
    scaledTextS("Arcade", 1060, 620, 60);
  }

  if (scaledIf(550, 650, 960, 1360)) {

    state = 3;
  }




  if (scaledIfNOW(675, 775, 60, 710)) { //how to play button

    fill(#FFFFFF);

    scaledRect(60, 675, 650, 100, 50);

    fill(#000000);

    scaledTextS("How to play", 180, 750, 70);
  } else {

    fill(#000000);

    scaledRect(60, 675, 650, 100, 50);

    fill(#FFFFFF);

    scaledTextS("How to play", 180, 750, 70);
  }

  if (scaledIf(675, 776, 60, 710)) {


    state = 4;
  }




  if (scaledIfNOW(675, 775, 730, 1360)) { //settings button

    fill(#FFFFFF);

    scaledRect(730, 675, 630, 100, 50);

    fill(#000000);

    scaledTextS("Settings", 900, 750, 70);
  } else {

    fill(#000000);

    scaledRect(730, 675, 630, 100, 50);

    fill(#FFFFFF);

    scaledTextS("Settings", 900, 750, 70);
  }

  if (scaledIf(675, 775, 730, 1360)) {

    state = 5;
  }
}

void exitButton() { //method for exit button in the top left of all screens

  stroke(#FFFFFF);

  if (scaledIfNOW(0, 75, 0, 150)) {

    fill(#FFFFFF); //white

    scaledRect(0, 0, 150, 75, 25);

    fill(#000000); //black

    scaledTextS("EXIT", 35, 50, 40);
  } else {

    fill(#000000); //black

    scaledRect(0, 0, 150, 75, 25);

    fill(#FFFFFF); //white

    scaledTextS("EXIT", 35, 50, 40);
  }

  if (scaledIf(0, 75, 0, 150)) { // if button clicked

    state = 0; //set state to 0 (homescreen)
    initialize(); // 'run initialize' method
  }
}

void keyPressed() {

  if (keyCode == 40) {

    rPaddleDown = true;
  }
  if (keyCode == 38) {

    rPaddleUp = true;
  }

  if (keyCode == 83) {

    lPaddleDown = true;
  }
  if (keyCode == 87) {

    lPaddleUp = true;
  }

  if (keyCode == 32) {

    spacePressed = true;



    if (gameOver == false && ballXspeed == 0) {

      wait = false;


      ballYspeed = 4;

      if (rightScored == true) {

        if (fastMode == false) {

          ballXspeed = 15;
        } else {

          ballXspeed = 25;
        }
        wait=false;
      }
      if (leftScored == true) {

        if (fastMode == false) {

          ballXspeed = -15;
        } else {

          ballXspeed = -25;
        }
        wait=false;
      }
    }

    //leftScored = false;
    //rightScored = false;
  }


  //38 = up
  //40 = down

  //87 = w
  //83 = s
}

void keyReleased() {

  if (keyCode == 38) { //down arrow

    rPaddleUp = false;
  }
  if (keyCode == 40) { //up arrow

    rPaddleDown = false;
  }

  if (keyCode == 83) {

    lPaddleDown = false;
  }
  if (keyCode == 87) {

    lPaddleUp = false;
  }

  if (keyCode == 32) {

    spacePressed = false;
  }
}


void mousePressed() {

  mouseXpos = mouseX;
  mouseYpos = mouseY;

  mouseIsClicked = true;
}

void mouseReleased() {

  mouseIsClicked = false;

  mouseXpos = 0;
  mouseYpos = 0;
}

void singleDifficulty() { //method for diffiulty selection screen in single player mode

  background(#000000);  // black

  fill(#FFFFFF); //white

  scaledTextS("Choose a difficulty", 150, 280, 120);

  if (scaledIfNOW(430, 530, 170, 370)) { //easy button

    fill(#FFFFFF); //white

    scaledRect(170, 430, 200, 100, 50);

    fill(#000000); //black

    scaledTextS("Easy", 200, 500, 60);

    fill(#FFFFFF); //white

    scaledTextS("AI moves based on the ball's current position.", 150, 700, 50); //description of easy mode if you hover over it
  } else {

    fill(#000000); //black

    scaledRect(170, 430, 200, 100, 50);

    fill(#FFFFFF); //white

    scaledTextS("Easy", 200, 500, 60);
  }




  if (scaledIfNOW(430, 530, 520, 820)) { //medium button

    fill(#FFFFFF);  //white

    scaledRect(520, 430, 300, 100, 50);

    fill(#000000); //black

    scaledTextS("Medium", 550, 500, 60);

    fill(#FFFFFF); //white

    scaledTextS("AI uses linear equations to calculate the ball's", 150, 650, 50); //description of medium mode if you hover over it
    scaledTextS("future position.", 150, 700, 50); //
  } else {

    fill(#000000); //black

    scaledRect(520, 430, 300, 100, 50);

    fill(#FFFFFF); //white

    scaledTextS("Medium", 550, 500, 60);
  }

  if (scaledIfNOW(430, 530, 970, 1170)) { //hard mode button

    fill(#FFFFFF); //white

    scaledRect(970, 430, 200, 100, 50);

    fill(#000000); //black

    scaledTextS("Hard", 1000, 500, 60);

    fill(#FFFFFF); //white

    scaledTextS("AI can calculate ball's future position using", 150, 650, 50); //description of hard mode is shown if you hover over it
    scaledTextS("linear equations. Faster than in medium mode.", 150, 700, 50); //
  } else {

    fill(#000000); //black

    scaledRect(970, 430, 200, 100, 50);

    fill(#FFFFFF); //white

    scaledTextS("Hard", 1000, 500, 60);
  }

  if (scaledIf(430, 530, 170, 370)) {

    state = 6;
  }

  if (scaledIf(430, 530, 520, 820)) {

    state = 7;
  }

  if (scaledIf(430, 530, 970, 1170)) {

    state = 8;
  }



  exitButton(); //exit button method
}

void AIeasy() { //easy AI method

  // moves paddle to wherever the ball is currently

  AIrate = 8;

  if (paddleLY < ballY && paddleLY < height - paddleSizeL/2) { 

    paddleLY = paddleLY + AIrate;
  }
  if (paddleLY > ballY && paddleLY > paddleSizeL/2) {

    paddleLY = paddleLY - AIrate;
  }
}

void AImedium() { //medium AI


  AIrate = 8;

  if (ballXspeed < 0) {



    slope = ballYspeed/ballXspeed;

    yIntercept = ballY-(slope*ballX);

    yPOI = int(yIntercept) + int(100 * slope);

    if (paddleLY<yPOI) {

      paddleLY = paddleLY + AIrate;
    }
    if (paddleLY > yPOI) {

      paddleLY = paddleLY - AIrate;
    }


    if (yIntercept > 800 || yIntercept < 0 ) {

      slope = pow(slope, -1);

      slope = slope * -1;

      yIntercept = ballY-(slope*ballX);

      yPOI = (slope*paddleL) + yIntercept;

      if (paddleLY<yPOI) {

        paddleLY = paddleLY + AIrate;
      }
      if (paddleLY > yPOI) {

        paddleLY = paddleLY - AIrate;
      }
    }
  }
}

void AIhard() { // hard mode AI

  AIrate = 10;


  if (ballXspeed < 0) {



    slope = ballYspeed/ballXspeed;

    yIntercept = ballY-(slope*ballX);

    yPOI = int(yIntercept) + int(100 * slope);

    if (paddleLY<yPOI) {

      paddleLY = paddleLY + AIrate;
    }
    if (paddleLY > yPOI) {

      paddleLY = paddleLY - AIrate;
    }


    if (yIntercept > 800 || yIntercept < 0 ) {

      slope = pow(slope, -1);

      slope = slope * -1;

      yIntercept = ballY-(slope*ballX);

      yPOI = (slope*paddleL) + yIntercept;

      if (paddleLY<yPOI) {

        paddleLY = paddleLY + AIrate;
      }
      if (paddleLY > yPOI) {

        paddleLY = paddleLY - AIrate;
      }
    }
  }
}

void AIadaptive() { // adaptive AI (for arcade mode)
}

void singleEasy() { //single player - easy difficulty

  background(#000000); //black

  exitButton(); 

  drawScore();

  if (gameOver == false) {

    drawBall(ballX, ballY);
  }

  drawPaddles();

  if (gameOver == false) {

    movePaddleR();

    AIeasy();

    moveBall();

    checkIfScored();

    checkBallHitPaddleR();

    checkBallHitPaddleL();

    gameOver();
  } else {

    gameOver();
  }
}

void singleMedium() { //single player - medium difficulty

  background(#000000); //black

  exitButton();

  drawScore();

  if (gameOver == false) {

    drawBall(ballX, ballY);
  }

  drawPaddles();

  movePaddleR();

  AImedium();

  moveBall();

  checkIfScored();

  checkBallHitPaddleR();

  checkBallHitPaddleL();

  if (gameOver == true) {

    gameOver();
  }
}

void singleHard() { //single player - hard difficulty

  background(#000000); //black

  exitButton();

  drawScore();

  if (gameOver == false) {

    drawBall(ballX, ballY);
  }

  drawPaddles();

  movePaddleR();

  AIhard();

  moveBall();

  checkIfScored();

  checkBallHitPaddleR();

  checkBallHitPaddleL();
}

void doublePlayer() { //two player mode

  background(#000000); //black

  fill(#FFFFFF);

  paddleSizeR = 200;

  paddleSizeL = 200;

  exitButton();

  drawScore();

  if (gameOver == false) {

    drawBall(ballX, ballY);
  }

  drawPaddles();

  movePaddleR();

  movePaddleL();

  moveBall();

  checkIfScored();

  checkBallHitPaddleR();

  checkBallHitPaddleL();
}

void arcade() { //arcade mode selection screen

  background(#000000); //black

  exitButton(); // exit button method

  fill(#FFFFFF); //white

  scaledTextS("As of version 2.1, powerups are not yet available.", 230, 700, 40);


  scaledTextS("Choose a game mode :", 375, 200, 60);

  stroke(#FFFFFF);




  if (scaledIfNOW(300, 400, 200, 500)) { // small paddles button

    fill(#FFFFFF);

    scaledRect(200, 300, 300, 100, 50);

    scaledTextS("Paddles are smaller than in the default game modes.", 185, 600, 40); //description shown if hovered over

    fill(#000000);

    scaledTextS("Small Paddles", 220, 365, 40);
  } else {

    fill(#000000);

    scaledRect(200, 300, 300, 100, 50); 

    fill(#FFFFFF);

    scaledTextS("Small Paddles", 220, 365, 40);
  }

  if (scaledIf(300, 400, 200, 500)) {

    state=9;
  }




  if (scaledIfNOW(300, 400, 550, 850)) { //fast speed button

    fill(#FFFFFF); //white

    scaledRect(550, 300, 300, 100, 50);

    scaledTextS("Ball moves faster than in the default game mode.", 210, 600, 40); //description shown if hovered over

    fill(#000000); //black

    scaledTextS("Fast Speed", 600, 365, 40);
  } else {

    fill(#000000);

    scaledRect(550, 300, 300, 100, 50);

    fill(#FFFFFF);

    scaledTextS("Fast Speed", 600, 365, 40);
  }

  if (scaledIf(300, 400, 550, 850)) {

    state=10;
  }



  if (scaledIfNOW(300, 400, 900, 1200)) { //large ball mode button


    fill(#FFFFFF); //white

    scaledRect(900, 300, 300, 100, 50);

    scaledTextS("Ball is larger than in default game mode.", 300, 600, 40); //description shown when hovered over

    fill(#000000); //black

    scaledTextS("Large ball", 950, 365, 40);
  } else {

    fill(#000000); //black

    scaledRect(900, 300, 300, 100, 50);

    fill(#FFFFFF); //white

    scaledTextS("Large ball", 950, 365, 40);
  }

  if (scaledIf(300, 400, 900, 1200)) {

    state=11;
  }
}

void smallPaddles() { //small paddles mode

  background(#000000); //black

  exitButton();

  paddleSizeL = 100;

  paddleSizeR = 100;

  singleMedium();
}

void fastSpeed() { //fast speed mode

  fastMode = true;

  background(#000000); //black

  exitButton();

  //scaledTextS("Coming soon...",400,400,80);

  singleMedium();
}

void largeBall() { //large ball mode

  background(#000000); //black

  exitButton();

  ballSize = 100;

  singleMedium();
}

void HTP() { //how to play screen

  background(#000000); //black

  exitButton();

  fill(#000000); //black

  scaledRect(325, 100, 75, 75, 20);

  scaledRect(475, 100, 75, 75, 20);


  scaledRect(325, 200, 75, 75, 20);

  scaledRect(475, 200, 75, 75, 20);



  fill(#FFFFFF); //white

  scaledTextS("+", 425, 150, 40);

  scaledTextS("W", 348, 152, 40);

  scaledTextS("S", 502, 152, 40);

  scaledTextS("Controls left paddle", 575, 150, 50);



  scaledTextS("+", 425, 250, 40);

  scaledTextS("↑", 348, 255, 50);

  scaledTextS("↓", 498, 255, 50);

  scaledTextS("Controls right paddle", 575, 250, 50);

  scaledTextS("Arcade modes : ", 200, 400, 60);

  scaledTextS("AI is adaptive in all arcade modes. This means that", 200, 500, 40);

  scaledTextS("the AI adjusts the difficulty automatically to match", 200, 550, 40);

  scaledTextS("the player's skill level.", 200, 600, 40);

  scaledTextS("There are also powerups to collect in Arcade mode,", 200, 700, 40);

  scaledTextS("which can help you win.", 200, 750, 40);
}

void sett() { //settings screen

  background(#000000); //black

  exitButton(); //exit button method

  fill(#FFFFFF); // white

  scaledTextS("As of version 2.1, settings aren't yet functional.", 200, 100, 40);



  scaledTextS("Ball colour : ", 150, 250, 50);

  scaledTextS("Paddle colour : ", 150, 450, 50);

  scaledTextS("Ball speed : ", 150, 650, 50);


  scaledRect(500, 630, 500, 5, 40); //

  scaledRect(500, 610, 5, 50, 40); // Ball speed slider

  scaledRect(1000, 610, 5, 50, 40); //

  scaledEllipse(ballSpeedSlider, 632, 30, 30);



  if (scaledIf(585, 635, 500, 1000)) { //if mouse clicked inside slider area

    if (mouseX>sliderStart &&  mouseX < sliderEnd) { 

      ballSpeedSlider = mouseX; //slider position = mouse x position
    }
  }



  for (int i = 0; i<5; i++) { // draws colour selection boxes

    if (i==0) {

      if (scaledIf(180, 280, 530 + i*150, 630 + i*50)) {

        stroke(#F9FA00);
      } else {

        noStroke();
      }

      fill(#FFFFFF); //white
    }
    if (i==1) {

      stroke(#FFFFFF); 

      fill(#000000);
    }
    if (i==2) {

      noStroke();

      fill(#00B5FA);
    }
    if (i==3) {

      fill(#FA8100);
    }
    if (i==4) {

      fill(#00FA12);
    }

    scaledRect(530 + i*150, 180, 100, 100, 10);
  }


  for (int i = 0; i<5; i++) { //draws colour selection boxes

    if (i==0) {

      noStroke();

      fill(#FFFFFF); //white
    }
    if (i==1) {

      stroke(#FFFFFF); 

      fill(#000000);
    }
    if (i==2) {

      noStroke();

      fill(#00B5FA);
    }
    if (i==3) {

      fill(#FA8100);
    }
    if (i==4) {

      fill(#00FA12);
    }

    scaledRect(605 + i*150, 380, 100, 100, 10);
  }
}

void scaledRect(int x, int y, int wdt, int hgt, int curve) {


  int originalWidth = 1400;
  int originalHeight = 800;


  rect(x*width/originalWidth, y*height/originalHeight, wdt*width/originalWidth, hgt*height/originalHeight, curve);
}

void scaledEllipse(float x, float y, int wdt, int hgt) {

  int originalWidth = 1400;
  int originalHeight = 800;

  ellipse(x*width/originalWidth, y*height/originalHeight, wdt*width/originalWidth, wdt*width/originalWidth);
}

void scaledText(int text, int x, int y, int size) {

  int originalHeight = 800;
  int originalWidth = 1400;

  textSize(size*width/originalWidth);
  text(text, x*width/originalWidth, y*height/originalHeight);
}

void scaledTextS(String text, int x, int y, int size) {

  int originalHeight = 800;
  int originalWidth = 1400;

  textSize(size*width/originalWidth);
  text(text, x*width/originalWidth, y*height/originalHeight);
}

boolean scaledIfNOW(int Ylow, int Yhigh, int Xlow, int Xhigh) { //method to see if the mouse is hovering over a certain area (scaleable)

  int originalHeight = 800;
  int originalWidth = 1400;

  if (mouseY > Ylow * height/originalHeight && mouseY < Yhigh * width/originalWidth && mouseX > Xlow * width/originalWidth && mouseX < Xhigh * width/originalWidth) {

    return true;
  } else {

    return false;
  }
}

boolean scaledIf(int Ylow, int Yhigh, int Xlow, int Xhigh) { //method to see if the mouse is clicked in a certain area (scaleable)

  int originalHeight = 800;
  int originalWidth = 1400;

  if (mouseIsClicked == true && mouseYpos > Ylow * height/originalHeight && mouseYpos < Yhigh * width/originalWidth && mouseXpos > Xlow * width/originalWidth && mouseXpos < Xhigh * width/originalWidth) {

    return true;
  } else {

    return false;
  }
}

void unscaledMousePos(int xPos, int yPos) {

  int originalWidth = 1400;
  int originalHeight = 800;

  unscaledmouseX = mouseX * (originalWidth/width);
  unscaledmouseY = mouseY * (originalHeight/height);
}
