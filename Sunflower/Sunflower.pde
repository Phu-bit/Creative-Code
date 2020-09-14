import ddf.minim.*;
//PShader shift;
Minim minim;
AudioPlayer sample;
float r, g, b,rot;
color c;
PImage pic;

void setup() {
  size(600,600,P3D);
  
  //shift = loadShader("shift.glsl");
  pic = loadImage("poster.jpg");
  background(0);
  frameRate(50);
  smooth();
  minim = new Minim(this);
  
  sample = minim.loadFile("music2.mp3", 1024);

  sample.play();
  
}

void draw() {
   background(0);

  stroke(128);
  strokeWeight(1);
  //for ( int i=0; i<height/60; i++) {
  //  line(0, i*60, width, i*60);
  //}
  //for ( int i=0; i<width/60; i++) {
  //  line(i*60, 0, i*60, height);
  //}
  translate(width/2, height/2);
  scale(1, 2);
  strokeWeight(2);
  //stroke(255, 120);
  noFill();
  
  float f = 200;
  float left[] = sample.left.toArray();
  beginShape();
  rotate(-PI/4);
  
  
  for (int i =0; i<sample.bufferSize() -10; i++) {
    //pushMatrix();
    rot = map(i,0,sample.bufferSize(),-12,12);
    //rotate(PI/rot);
    //fill(r,g,b);
    float x1 = left[i];
    float x2 = left[i+1];
    //box((x1 *f),(x2 * f),(sample.left.get(i)));
    //popMatrix();

    curveVertex((x1*f),(x2*f));
    
  }
endShape();

for (int i =0; i<sample.bufferSize() -10; i++) {
    pushMatrix();
    rot = map(i,0,sample.bufferSize(),-12,12);
    rotate(PI/rot);
    //fill(r,g,b);
    float x1 = left[i];
    float x2 = left[i+1];
    float x3 = map( i , 0, sample.bufferSize(),0,width);
    float x4 = map( i+1 , 0, sample.bufferSize(), 0 , width);

    color c = pic.get(int(x3),int(x4));
    stroke(c);

    box((x1 *f),(x2 * f),(sample.left.get(i)));
    popMatrix();
    
  }
  //translate((mouseX+(width*0.05))%width, mouseY+(height*0.025), 20);

  

  //filter(shift);
}
