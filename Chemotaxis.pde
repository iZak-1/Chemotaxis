Bacteria[] colony;
float attraction;;
int numBacteria = 20;
int FR=60;  //framerate
int speed;
int numLinesToShow = 50;
void setup() {
  attraction=0;
  speed=5;
  size(1000,1000); //size((int)(0.95*window.innerWidth), (int)(0.95*window.innerHeight));
  colony = new Bacteria[numBacteria];
  System.out.print(Math.sin(PI/2));
  stroke(255,255,255);
  for(int i=0;i<colony.length;i++) {  
    colony[i]=new Bacteria((int)(width*Math.random()), (int)(width*Math.random()), (float)(2*PI*Math.random()));
    for(int j=0; j<numLinesToShow; j++) {
      colony[i].oldXcords[j]=colony[i].myX;
      colony[i].oldYcords[j]=colony[i].myY;
    }
  }
}

void draw() {
  background(0,0,0);
  frameRate(FR);
  for(int i=0; i<colony.length; i++) {
    colony[i].move();
    colony[i].show();
  }
}

class Bacteria {
  float myX, myY, oldX, oldY, dX, dY;
  color myColor;
  double angleRad, angleToMouse, moveX, moveY, mouseDx, mouseDy, avgX, avgY;
  float[] oldXcords = new float[numLinesToShow];
  float[] oldYcords = new float[numLinesToShow];
  Bacteria(int x_, int y_, float angle_){
    myX=x_;
    myY=y_;
    angleRad=angle_;
    
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
    
    // System.out.println(Math.sqrt(Math.pow((float)moveX,2)+Math.pow((float)moveY,2))+", "+ dX+", "+dY); //ignore, this is for debug
    
    //not that we've done a ton of math, move!
    myX+=speed*moveX;
    myY+=speed*moveY;
  }
  void randomPos() {
    myX=(int)(width*Math.random());
    myY=(int)(height*Math.random());
  }
  void show() {
    stroke(myColor);
    for(int a=0;a<numLinesToShow-1;a++) {  
      oldXcords[a]=oldXcords[a+1];
      oldYcords[a]=oldYcords[a+1];
    }
    oldXcords[numLinesToShow-1]=myX;
    oldYcords[numLinesToShow-1]=myY;
    for(int a=1;a<numLinesToShow;a++) {  
      line(oldXcords[a-1],oldYcords[a-1],oldXcords[a],oldYcords[a]);
    }
    fill(myColor);
    noStroke();
    ellipse(myX, myY, 5, 5);
    System.out.println(oldXcords.length);
  }
}
void keyPressed() {
  if(keyCode==DOWN){
    speed-=1;
  }
  if(keyCode==UP){
    speed+=1;
  }
  if(keyCode==RIGHT) {
    attraction+=0.1;
  }
  if(keyCode==LEFT) {
    attraction-=0.1;
  }
  if(key=='w') {
    FR+=1;
  }
  if(key=='s'&&FR>1) {
    FR-=0.1;
  }
}

void mouseClicked(){
  setup();
}
