float rectGX=400, rectGY=5;// grob cordinates 
color grob=#E05B46;
float speed=3;
int keyPress;

//I cal the ellipses "bubbles" because it sounds cute.
int bubbleNum;

IntList bubbleCoords;//An array to store x,y coordinates of all the bubbles.
/*
  I use IntList instead of prain ordinary array for a reason.
  Ordinary array doesn't allow us to remove the element inside, so we can't erase colided bubbles.
  Whereas, IntList allows us to do so.
*/

int diameter = 0;
color bubbleFill = color(0, 0, 0);

boolean isInitialized = false;

int totalScore = 6;
int sceneScore = 0;

void setup() {
  size(800, 600);
  initialize();//I put this funciton at the bottom
}

void draw() {
  Background();
  checkColision();
  bubbles();
  grob();
  keyboard();
  limits();
  
  fill(0, 150);
  textSize(30);
  int displayScore = totalScore+sceneScore;
  text("Score: "+displayScore, width-200, 50);
  
  
  if(isInitialized == true){
    initialize();
    isInitialized = false;//After initialise bubbles, immediately set false again.
  }
}

void keyboard() {
  if (keyPressed) {
    if (keyCode==RIGHT) {
     rectGX+=random(2,5);
      keyPress+=1;
    }
    if (keyCode==LEFT) {
      rectGX+=random(-2,-5);
      keyPress+=1;
    }
  }
}


void grob() {
  //I set the rectangle mode to CENTER, to make it easy to calculate distance between the grob and the bubbles
  rectMode(CENTER);
  
  //To along with the rect center mode, I tweaked the value a bit.
  fill(grob);
  rect(rectGX, rectGY, 50, 50);// face
  fill(255);
  ellipse(rectGX-15, rectGY-14, 15, 15);// left eye 
  fill(0);
  ellipse(rectGX-16, rectGY+-14, 8, 8);// left inner eye
  fill(255);
  ellipse(rectGX+10, rectGY-14, 15, 15);// right eye
  fill(0);
  ellipse(rectGX+8, rectGY-14, 8, 8);// right inner eye
  fill(#F6FC9C);
  arc(rectGX-3, rectGY+5, 30, 25, 0, 3.14);// happy smile

  rectGY+=speed;

}

void limits(){
  if(rectGY>=600){//Mr.Grob reached the bottom.
    isInitialized = true;//Initialize the bubbles again at this moment.
    rectGY=0; 
  }
  
  //I made a limitation not the grob to go out of the canvas. If you don't like then you can just delete this.
  if(rectGX < 0+25){
    rectGX = 0+25;
  }else if(rectGX > width-25){
    rectGX = width-25;
  }
}



void bubbles(){
  stroke(255);
  for(int i=0; i<bubbleCoords.size(); i+=2){
    int[] bubbleCoord = bubbleCoords.array();//Convert the IntList to ordinary int array in order to use in processing function.
    float bX = float(bubbleCoord[i]);//functions like ellipse requires float value, so convert to float.
    float bY = float(bubbleCoord[i+1]);
    
    fill(bubbleFill);
    ellipse(bX, bY, diameter, diameter);
  }
  
  stroke(100, 101, 11);
}


void checkColision(){  
  for(int i=0; i<bubbleCoords.size(); i+=2){
    int[] bubbleCoord = bubbleCoords.array();//Convert the IntList to ordinary int array in order to use in processing function.
    float bX = float(bubbleCoord[i]);//functions like ellipse requires float value, so convert to float.
    float bY = float(bubbleCoord[i+1]);
    float d = dist(bX, bY, rectGX,rectGY);//Calculate each distance between every bubble and the Grob 

    if(d < diameter/2+25){//d smaller than (radius of the bubble + half length of the grob) => colide!!!!!
      bubbleCoords.remove(i);//First we remove the x value
      bubbleCoords.remove(i);//Right after erase the x value, the y value slide into the position, so we erase that y value too.
      
      sceneScore+=2;//yay
    }
  }
}

void Background(){
  background(240);
  rectMode(CORNER);

  for (int x = 0; x < width; x += 100) {
    for (int y = 0; y < height; y += 24) {
      
      stroke(100, 101, 11);
      strokeWeight(2);
  
      fill(200);
      rect(x, y, 100, 12);

      fill(180, 161, 11);
      rect(x+50-6, y+12, 12, 12);
    
    }
  }
}

void initialize(){
  bubbleNum = int(random(1, 15));//Determine initial number of the bubbles.
  //println(bubbleNum);
  bubbleCoords = new IntList();//Make spaces to store bubbles
  
  for(int i=0; i<bubbleNum; i++){//Iterate number of the bubbles times.
    bubbleCoords.append(int(random(0, width)));//Add each bubble's x coordinate
    bubbleCoords.append(int(random(height/3, height)));//Add each bubble's y coordinate
  }
  /*
    At this moment, the size of the IntList bubbleCoords is 2 times of the bubbleNum
    
                x0   y0   x1   y1   x2   y2           xN   yN
    bubbleCoords [ 484, 473, 135, 575, 694, 445, ..... , 249, 473 ]
  */
  //println(bubbleCoords);
   
  //Initialize the bubble diamter and fill
  diameter = int(random(40, 80));
  bubbleFill = color(int(random(0, 255)), int(random(0, 255)), int(random(0, 255)), 125);//I added a bit of transparency
  
  if(sceneScore == 0){
    if(totalScore > 0){
      totalScore -= 1;
    }else{
    }
    
  }else if(sceneScore > 0){
    totalScore += sceneScore;
  }
  sceneScore = 0;
  
}
