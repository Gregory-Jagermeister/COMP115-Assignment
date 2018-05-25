//Integers used When creating Screen size, timers or scores.
int screenW = 512;
int screenH = 348;
int intTime;
int interval = 1000;
int RandomCount;
int score;
int hits;
int oldscore;

//Color array only used for trees however.
color[] greenArray = {#5AC11F, #52A224, #337E08, #419313};

//Booleans 
boolean response = false;
Boolean layered;
Boolean DoorOpen;

//Objects used mainly to draw and provide logic for the hammer and player.
Hammer[] hammers = new Hammer[5];
MrGW player = new MrGW();

//Image to show what the original game looked like. I used it as a Base.
PImage Bg;

void setup() {
  //Load Image into BG so I can use it to overlay over the screen.
  Bg = loadImage("HelmetBG.gif");
  //same as "size()" however I am allowed to input varibles not only integers
  //makes it easier to understand what is what in the statment
  surface.setSize(screenW, screenH);
  //a boolean value to see if the image is "layered" on the canvas, initally set
  //to false to prevent it from appearing
  layered = false;
  //set the inital time
  intTime = millis();
  //create the player and set the boundarys of which the player is allowed
  //to move on the world space.
  player.Create(48 + 16, 256 - 16);
  player.setBoundary(48,450);
  //the score is set to 0 on startup
  score = 0;
  hits = 0;
  oldscore = 0;
  //populate the hammers array with hammers.
  for (int i = 0; i < hammers.length; i++) {
    hammers[i] = new Hammer();
    hammers[i].Create(64, -16);
  }
}

void draw() {
 
  //a timer that runs the code inside every 1 seconds
  if (millis() - intTime > interval) {

    RandomCount = int(random(3, 8));
    intTime = millis();
  }
  //checks to see if we should draw the Image onto of the canvas
  if (layered == true) {
    image(Bg, 0, 0, screenW, screenH);
  //OR if we shouldnt draw everything else
  } else if (layered == false) {
    background(255);
    //local varibles used to colour and position the trees.
    float treeX = 90;
    float treeY = 256;
    int Colorindex = 0;
    //Time to draw each tree and give them a colour based on the 
    //ColourArray made earlier.
    for (int i = 0; i< 13; i= i + 1) {
      drawTree(treeX, treeY, greenArray[Colorindex]);
      treeX = treeX + 25;
      Colorindex = Colorindex + 1;
      if (Colorindex > 2) {

        Colorindex = 0;
      }
    }
    //Draws the Background 
    drawBG();
    //initaldrawing of the door ensuring it is shut
    drawEndDoorClosed();
    //using the timer to open and close the door after the specified amount of secs
    if (RandomCount <= 4 && RandomCount > 0) {
      drawEndDoorClosed();
      DoorOpen = false;
    } else if (RandomCount > 4 && RandomCount < 8) {
      drawEndDoorOpen();
      DoorOpen = true;
    }
    
    noStroke();
    fill(0);
    //creates the players score and draws the player to the screen. Now Obsolete
    //Score(score);
    player.Draw();
    //This for loop checks each hammer object and compares it to the player checking to
    //see if the two objects have intersected, if they havent then nothing happens, however
    //if they have then the player is reset aswell as the hammer that hit the player.
    for (int i=0; i < hammers.length; i++) {

      hammers[i].Fall();
      if (isColliding(hammers[i].Xpos, hammers[i].Ypos, hammers[i]._Width, hammers[i]._Height, 
                      player.Xpos, player.Ypos, player.Width, player.Height) == true) {

        player.stopLEFT();
        hammers[i].Ypos = 0;
        //this simply tells the object that the hammer has fallen and should reset in a
        // random position.
        hammers[i].HamFell = true;
        hits++;
      }
    }
    noStroke();
    CheckScore(score, oldscore, hits);
    
    if(score + (hits * 9) >= 54){
      score = 0;
      hits = 0;
      
    };
    
  }
  
  //used for assinging the layered properly toggles it on/off when a key is pressed.
  if (response == true) {
    layered = true;
  } else if (response == false) {
    layered = false;
  }
}

void keyPressed() {
  if (key == CODED) {
    if (keyCode == LEFT) {
      //When the left arrow key is pressed the player moves left.
      player.MoveLEFT();
      //checks to see if the player has reached the boundary specified, if so
      //stop them from moving.
      if(player.boundaryUpdate()){
        player.stopLEFT();
      }
      
    } else if (keyCode == RIGHT) {
      //when the right key is pressed move right.
      player.MoveRIGHT();
      //if the door is not open the player must wait untill its open before proceeding.
      if(DoorOpen == false){
        player.Bound2 = 320+64;
        if (player.boundaryUpdate()){
           player.stopRIGHT();
        }
      //However if the Door is open then player is reset and the score is incremented
      //by 1.
      }else if(DoorOpen == true){
        player.Bound2 = 400;
        if(player.boundaryUpdate()){
          player.stopLEFT(); 
          score+=3;
        }
      }
    }
  }

//Toggles the Layered boolean which in turn shows the image.
  if (key == 'l') {
    if (response == false) {
      response = true;
    } else if (response == true) {
      response = false;
    }
  }
}

void drawBG() {
  //Start Drawing the Appartment Block
  noStroke();
  fill(#C4AA26);
  rect(0, 117, 5, 85);
  rect(0, 117, 33, 8);
  rect(0, 153, 33, 8);
  rect(0, 189, 33, 8);
  rect(0, 142, 33, 1);
  rect(0, 178, 33, 1);
  rect(9.3, 142, 1, 12);
  rect(18.6, 142, 1, 12);
  rect(27.9, 142, 1, 12);
  rect(9.3, 178, 1, 12);
  rect(18.6, 178, 1, 12);
  rect(27.9, 178, 1, 12);
  //End Drawing Appartment Block

  //Draw Left Door
  fill(0);
  stroke(0);
  strokeWeight(1.5);
  line(0, 207, 28, 207);
  line(28, 207, 28, 256);
  line(0, 256, 28, 256);
  noStroke();
  rect(8.5, 215, 10, 12.5);
  ellipse(22, 235, 4, 4);
  //End Drawing the Left Door

  //Start Drawing forest Hut
  stroke(0);
  fill(255);
  line(444, 188, 444, 256);
  strokeWeight(6);
  line(478, 172, 436, 195);
  line(478, 172, 512, 189);

  //Ground Height
  fill(227, 138, 48);
  stroke(227, 138, 48);
  rect(0.0, 259, 511.0, 91.0);
  fill(122, 227, 48);
  noStroke();
  rect(0.0, 256.8, 511.0, 21.0);
}

void drawEndDoorClosed() {
  //Draw the door closed/
  fill(0);
  stroke(0);
  strokeWeight(1.5);
  line(450, 207, 478, 207);
  line(478, 207, 478, 256);
  line(450, 256, 478, 256);
  line(450, 207, 450, 256);
  noStroke();
  rect(459.5, 215, 10, 12.5);
  ellipse(458, 235, 4, 4);
  //end drawing the door closed.
}

void drawEndDoorOpen() {
  
  //draw the door as open
  fill(255);
  stroke(0);
  strokeWeight(1.5);
  beginShape();
  vertex(478, 207);
  vertex(492, 197);
  vertex(492, 266);
  vertex(478, 256);
  vertex(478, 207);
  vertex(450, 207);
  vertex(450, 256);
  vertex(478, 256);
  endShape(CLOSE);
  //end drawing the door as open
}

void drawTree(float x, float y, color treeColor) {
  //draws the tree.
  fill(treeColor);
  noStroke();
  strokeWeight(1.5);
  beginShape();
  vertex(x, y);
  vertex(x + 20, y);
  vertex(x + 20, y - 10);
  vertex(x + 40, y - 10);
  vertex(x + 15, y - 30);
  vertex(x + 35, y - 30);
  vertex(x + 15, y - 55);
  vertex(x + 25, y - 55);
  vertex(x + 10, y - 75);
  vertex(x - 5, y - 55);
  vertex(x + 5, y - 55);
  vertex(x - 10, y - 30);
  vertex(x + 5, y - 30);
  vertex(x - 17, y - 10);
  vertex(x, y - 10);
  endShape(CLOSE);
  //ends drawing the tree
}

//void Score(int text) {
//  //sets the text size
//  textSize(24);
//  //draws it to the screen.
//  text("Score: " + text, 20, 40);
//}

/*For the below code I've used classes to help create and 
structure some of the objects that I was using. Now i'm not particularly
sure whether I am allowed to use them or not, however using them was the best
way to achieve the goals I was trying to attain, for example the collision detection
was fixed using objects and arrays whereas before I struggled with only 
using arrays.*/
class Hammer {

  float XOrigin, YOrigin, _Height, _Width, Xpos, Ypos, RotAngle, XinitVal;
  int time, time2 = millis();
  int ShouldHammerFall;
  boolean HamFell;

  Hammer() {
    _Height = 32;
    _Width = 32;
    XOrigin = 0;
    YOrigin = 0;
    HamFell = true;
  }

  void Create(float x, float y) {
    Xpos = x;
    Ypos = y;
    XinitVal = Xpos;
    Draw();
  }

  void Fall() {
    if (HamFell == true) {    
      ShouldHammerFall = int(random(1, 3));
    }
    if (ShouldHammerFall == 1) {
      if (millis() > time + 1000)
      {
        Ypos += 64;
        if (HamFell == true) {

          int Rnd = int(random(1, 6));
          if (Rnd == 1) {
            Xpos = 0;
            Xpos = XinitVal + 64;
            HamFell = false;
          } else if (Rnd == 2) {
            Xpos = 0;
            Xpos = XinitVal + 128;
            HamFell = false;
          } else if (Rnd == 3) {
            Xpos = 0;
            Xpos = XinitVal+192;
            HamFell = false;
          } else if (Rnd == 4) {
            Xpos = 0;
            Xpos = XinitVal + 256;
            HamFell = false;
          } else if (Rnd == 5) {
            Xpos = 0;
            Xpos = XinitVal + 320;
            HamFell = false;
          }
        } 

        if (Ypos + 16 > 256 ) {

          HamFell = true;
          Ypos = -16;
          score++;
        }

        if (Ypos == Ypos) {
          RotAngle += 90;
        }
        time = millis();
      }

      Draw();
    } else {
      //Do Nothing
    }
  }

  void Draw() {

    pushMatrix();
    translate(XOrigin + Xpos, XOrigin + Ypos);
    rotate(radians(RotAngle));
    translate(XOrigin - 16, XOrigin + 16);
    fill(255, 255, 255, 0);

    fill(#AD4A0C);
    beginShape();
    vertex(XOrigin + 14, YOrigin);
    vertex(XOrigin + 14, YOrigin - 20);
    vertex(XOrigin + 18, YOrigin - 20);
    vertex(XOrigin + 18, YOrigin);
    vertex(XOrigin + 14, YOrigin);
    endShape(CLOSE);

    fill(#ADACAB);
    beginShape();
    vertex(XOrigin + 14, YOrigin - 20);
    vertex(XOrigin + 2, YOrigin - 20);
    vertex(XOrigin + 2, YOrigin - 22);
    vertex(XOrigin + 16, YOrigin - 30);
    vertex(XOrigin + 27, YOrigin - 30);
    vertex(XOrigin + 27, YOrigin - 20);
    endShape(CLOSE);

    popMatrix();

    if (RotAngle >=360 || RotAngle <= -360) {

      RotAngle = 0;
    }
  }
}

class MrGW {

  float Xpos, Ypos, Xorigin, Yorigin, Height, Width, Velocity, Dir, Bound1, Bound2;

  MrGW() {

    Height = 32;
    Width = 32;
    Xorigin = 0;
    Yorigin = 0;
    Velocity = 64;
    Dir = 1;
  }

  void Create(float x, float y) {

    Xpos = x;
    Ypos = y;
  }

  void Draw() {
    pushMatrix();
    translate(Xorigin + Xpos, Yorigin + Ypos);
    stroke(0);
    strokeWeight(1.5);
    if (Dir == 1) {
      beginShape();
      //fill(255,255,255,0);
      //rect(Xorigin - 16, Yorigin -16, 32,32);
      fill(0);
      ellipse(Xorigin, Yorigin -8.5, 12.5, 12.5);
      ellipse(Xorigin + 9, Yorigin -8.5, 6, 6);
      ellipse(Xorigin, Yorigin+2, 6, 12);
      line(Xorigin - 3, Yorigin, Xorigin - 6, Yorigin + 7);
      line(Xorigin + 3, Yorigin, Xorigin + 6, Yorigin + 7);
      line(Xorigin+1.5, Yorigin +6, Xorigin + 3, Yorigin + 16);
      line(Xorigin-1.5, Yorigin +6, Xorigin - 3, Yorigin + 16);
      endShape(CLOSE);
    } else if (Dir == -1) {
      beginShape();
      //fill(255,255,255,0);
      //rect(Xorigin - 16, Yorigin -16, 32,32);
      fill(0);
      ellipse(Xorigin, Yorigin -8.5, 12.5, 12.5);
      ellipse(Xorigin - 9, Yorigin -8.5, 6, 6);
      ellipse(Xorigin, Yorigin+2, 6, 12);
      line(Xorigin - 3, Yorigin, Xorigin - 6, Yorigin + 7);
      line(Xorigin + 3, Yorigin, Xorigin + 6, Yorigin + 7);
      line(Xorigin+1.5, Yorigin +6, Xorigin + 3, Yorigin + 16);
      line(Xorigin-1.5, Yorigin +6, Xorigin - 3, Yorigin + 16);
      endShape(CLOSE);
    }

    popMatrix();
  }

  void MoveLEFT() {
    Xpos -= Velocity;
    Dir = -1;
  }

  void MoveRIGHT() {
    Xpos += Velocity;
    Dir = 1;
  }

  void setBoundary(float x1, float x2) {
    Bound1 = x1;
    Bound2 = x2;
  }

  boolean boundaryUpdate() {
    if (Xpos - 16 <= Bound1 && Velocity != 0) {
      return true;
    } else if (Xpos >= (Bound2 +32) && Velocity != 0) {
      return true;
    }
    return false;
  }
  
  void stopLEFT(){
    
    Xpos = Bound1 + 16;
    
  }
  
  void stopRIGHT(){
    
    Xpos = Bound2;
    
  }
}

//this is for detecting collision between two objects inorder to achieve this
//I used had to research into the intesection and collision detection which 
// led me to http://www.jeffreythompson.org/collision-detection/table_of_contents.php
// this was very useful on giving examples of code.
boolean isColliding(float p1x, float p1y, float p1w, float p1h, 
  float p2x, float p2y, float p2w, float p2h) {

  // are the sides of one rectangle touching the other?

  if (p1x + p1w >= p2x &&    // r1 right edge past r2 left
    p1x <= p2x + p2w &&    // r1 left edge past r2 right
    p1y + p1h >= p2y &&    // r1 top edge past r2 bottom
    p1y <= p2y + p2h) {    // r1 bottom edge past r2 top
    return true;
  }
  return false;
}

//This function will check the score and whether it needs to be changed on the display.
// Note For Marker: You missed an opportunity in calling this Part "one function to rule
// them all" you could have used "One function to Score them all". Also please no Mark
// reductions for this all in good jest.
void CheckScore(int score, int PreScore, int lifeScore) {
  //create X,Y positions in the plane.
  int x, y;
  // Has the score changed since the last check.
  if (PreScore < score) {

    // this is bloody Cool; seperate the score in columns and rows
    // basically we get our index (i) which is incrementing over an amount equal to
    // the score. 
    for (int i = 0; i <= (score); i++) {
      x = ((i % 9) + 1) *50;
      y = (((i / 9) + 1) *50)+(lifeScore*50);
      int size = 50;
      circleGradient(x, y, size, 30, true);
      
    }
  }
  if(lifeScore > 0){

      for(int s = 1; s <= lifeScore; s++){
       for(int j = 1; j <= 9; j++){
        int size = 50;
        circleGradient(j*50,s*50, size, 30, false);
       }
      }

    }
  PreScore = score;
}

// draws a gradient circle.
void circleGradient(float xloc, float yloc, int size, int stepSize, boolean IsBlack ) {
  //work out how many steps are needed for the size and the amount of iterations.
  float steps = size/stepSize;
  // a Loop to draw the gradient circle.
  for (int i = 0; i < stepSize; i++) {
    // a check to see if we want the circle black or red.
    if (IsBlack) {
      fill(255 - (i * (steps + 10)));
    } else {
      fill(255, 255 - (float(i) * (steps + 10)), 255 - (float(i) * (steps + 10)));
    }
    //draw the circle to the screen.
    ellipse(xloc, yloc, size - (i*steps), size - (i*steps));
  }
}