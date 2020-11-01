Bacteria[] colony;
Bacteria[] newColony;
float attraction;;
int numBacteria;
int speed;
int numLinesToShow;
void setup() {
  frameRate(100);
  size(1000,1000); //size((int)(0.95*window.innerWidth), (int)(0.95*window.innerHeight));
  textAlign(CENTER, CENTER);
  textSize(width/50);
  
  
  //set up variables
  attraction=0;
  speed=5;
  numLinesToShow=20;
  numBacteria= 10;
  colony = new Bacteria[numBacteria];
  for(int i=0;i<colony.length;i++) {  
    colony[i]=new Bacteria((int)(width*Math.random()), (int)(width*Math.random()));
    for(int j=0; j<numLinesToShow; j++) {
      colony[i].oldXcords[j]=colony[i].myX;
      colony[i].oldYcords[j]=colony[i].myY;
    }
  }
}

void draw() {
  background(0,0,0);
  for(int i=0; i<colony.length; i++) {
    colony[i].move();
    colony[i].show();
  }
  
  fill(255,255,255);
  noStroke();
  text("Click to reset\nControls listed as [key]", width/2, height/15);
  text("[↑]/[↓]\nvelocity\n"+speed, width/5, 7*height/8);
  text("[←]/[→]\nattraction\n"+round(attraction*20)/20.0, 2*width/5, 7*height/8);
  text("[a]/[d]\nbacteria\n"+numBacteria, 3*width/5, 7*height/8);
  text("[s]/[w]\ntrail length\n"+numLinesToShow, 4*width/5, 7*height/8);
}



class Bacteria {
  float myX, myY, oldX, oldY, dX, dY;
  color myColor;
  double angleRad, angleToMouse, moveX, moveY, mouseDx, mouseDy, avgX, avgY;
  float[] oldXcords = new float[numLinesToShow];
  float[] oldYcords = new float[numLinesToShow];
  Bacteria(int x_, int y_){
    myX=x_;
    myY=y_;
    angleRad=(float)(2*PI*Math.random());
    
    //for drawing lines
    oldX=myX;
    oldY=myY;
    
    //for calculating where to go
    dX=0;
    dY=0;
    mouseDx=0;
    mouseDy=0;
    avgX = 0;
    avgY = 0;
    moveX=0;
    moveY=0;
    
    //Pick a color
    myColor = color((int)(255*Math.random()), (int)(255*Math.random()), (int)(255*Math.random()));
  }
  
  void move() {
    //calculate theta to the mouse and the random angle that the bacterium will go
    angleToMouse = Math.atan2((float)(mouseY-myY),(float)(mouseX-myX));
    angleRad+=(Math.random()*2)-1;
    
    //how much it would move to the mouse
    mouseDx=attraction*cos((float)angleToMouse);
    mouseDy=attraction*sin((float)angleToMouse);
    
    //how much it would move randomly
    dX=cos((float)angleRad);
    dY=sin((float)angleRad);
    
    //the sum of the two vectors above
    avgX = dX+mouseDx;
    avgY = dY+mouseDy;
    
    //normalize the above vectors
    moveX=avgX/Math.sqrt(Math.pow(avgX, 2)+Math.pow(avgY,2));
    moveY=avgY/Math.sqrt(Math.pow(avgX, 2)+Math.pow(avgY,2));
    
    //not that we've done a ton of math, move!
    myX+=speed*moveX;
    myY+=speed*moveY;
  }
  void randomPos() {
    myX=(int)(width*Math.random());
    myY=(int)(height*Math.random());
  }
  void show() {
    for(int a=0;a<numLinesToShow-1;a++) { //shift values in the array of previous coordinates to the left, discarding the first element, and keeping the last element as it was
      oldXcords[a]=oldXcords[a+1];
      oldYcords[a]=oldYcords[a+1];
    }
    oldXcords[numLinesToShow-1]=myX;  //set the last element to be the current position
    oldYcords[numLinesToShow-1]=myY;
    
    for(int a=1;a<numLinesToShow;a++) { //draw said lines
      stroke(myColor, 100+(155.0*a/(numLinesToShow-1))); //color gradient
      line(oldXcords[a-1],oldYcords[a-1],oldXcords[a],oldYcords[a]);
    }
    //draw the dot
    fill(myColor);
    noStroke();
    ellipse(myX, myY, 5, 5);
  }
}
void keyPressed() {
  if(keyCode==DOWN&&speed>1){  //slow down
    speed-=1;
  }
  if(keyCode==UP){  //speed up
    speed+=1;
  }
  if(keyCode==RIGHT) { //increase attraction to mouse
    attraction+=0.05;
  }
  if(keyCode==LEFT) {  //decrease attraction to mouse
    attraction-=0.05;
  }
  if(key=='s'&&numLinesToShow>1) {  //decrease number of lines to show for every bacteria
    numLinesToShow-=1;
    for(int i=0;i<colony.length;i++) {
      colony[i].oldXcords=shorten(colony[i].oldXcords);
      colony[i].oldYcords=shorten(colony[i].oldYcords);
    }
  }
  if(key=='w') {  //increase number of lines to show for every bateria
    numLinesToShow+=1;
    for(int i=0;i<colony.length;i++) {
      colony[i].oldXcords=append(colony[i].oldXcords, colony[i].myX);
      colony[i].oldYcords=append(colony[i].oldYcords, colony[i].myY);
    }
  }
  if(key=='a'&&numBacteria>1) { //remove the last bacteria in the list
    numBacteria-=1;
    colony=(Bacteria[])shorten(colony);
  }
  if(key=='d') { //add a bacteria
    numBacteria+=1;
    colony=(Bacteria[])append(colony, new Bacteria((int)(width*Math.random()), (int)(width*Math.random())));
    for(int j=0; j<numLinesToShow; j++) { //set all previous coordinates of the bacteria to current cooridnates
      colony[numBacteria-1].oldXcords[j]=colony[numBacteria-1].myX;
      colony[numBacteria-1].oldYcords[j]=colony[numBacteria-1].myY;
    }
  }
  if(keyCode==32) {  //reset on spacebar
    setup();
  }
}

void mousePressed(){
  frameRate(10);
}
void mouseReleased(){
  frameRate(100);
}
