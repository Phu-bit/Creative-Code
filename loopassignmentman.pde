import peasy.*;
import processing.video.*;
import ddf.minim.*;

PeasyCam camera;
Minim minim;
AudioPlayer song;
Movie video;

//PImage pic;
int x,y;
float a;
float aChange = 0.015;
boolean mPressed = true;

void setup(){
  size(1000,1000,P3D);
  camera = new PeasyCam(this, width/2, height/2, -1100, 2000);
  camera.setPitchRotationMode(); // like a somersault
  camera.reset(2000);
  //fullScreen(P3D);
  minim = new Minim(this);
  song = minim.loadFile("song2.mp3", 1024);
  video = new Movie(this, "video3.mp4");
  video.loop();
  video.volume(0);
  //pic = loadImage("hand.jpg");
  background(0);
}

void moveEvent(Movie r){
  r.read();
}

void draw(){   
  //load in pixels of videos and pics or whatever
  //loadPixels();
  video.loadPixels();
  //pic.loadPixels();
  video.read();

  //turn background draw on or off
  if(mPressed){
    background(0);
    
  }
  
  //textSize(100);
  //fill(255);

//for( int i = 0; i<song.bufferSize(); i++){

  //float g = song.mix.get(i)*100;
  //println(g);
  //if(abs(g)>20){
  //camera.rotateY(a);
  //}
  //pushMatrix();
  //translate(width/4,0,0);
  //rotateY(a);
  //rotateX(song.mix.get(i)*40);
  
//}
  //image(video,0,0);
  float step = map(mouseX,0,width,5,50);
    for(int x = 0; x<width; x++){
      for(int y = 0; y<height; y+=step){
          //for(int i = 0; i < song.bufferSize() - 1; i++){

       int loc = x+y*video.width;
       color c = video.get(x,y);
       float b = brightness(video.pixels[loc]);
       float z = map(b, 0, 255, -1000,0);
       //float x1 = map( i , 0, song.bufferSize(),0,width);
       //float x2 = map( i+1 , 0, song.bufferSize(), 0 , width);
       //float x3 = song.left.get(i) * 100;
       //float x4 = song.right.get(i) * 100;
  
        stroke(c);
        fill(c-b);
        
        pushMatrix();
        translate(x,y,z+song.mix.get(x)*200);
        //translate(0,0,song.mix.get(x)*10);
        //rotate(z);
        //beginShape();
        //curveVertex(0,0,0);
        //curveVertex(song.left.get(x),song.right.get(x),song.mix.get(x)*100);
        //endShape();
        line(0,0,0,song.left.get(x),song.right.get(x),song.mix.get(x)*100);
        
        //line(song.left.get(x),song.right.get(x),song.mix.get(x)*100,0,0,0);
        popMatrix();
        
        //pixels[loc] = pic.pixels[loc];
      //}
    }
  }
    //if(abs(a)>=1.15){
    //  aChange *= -1;
    //}
    //a+=aChange;
}

void keyPressed(){
  if(key == 'z'){
 if(song.isPlaying()){
   song.pause();
   
}else{
  int start = 32000;
 song.play(start); 
}
video.play();
  }
  
  if(key == 'x'){
  video.pause();
  }
  if(key == 'c'){
    video.stop();
    song.play(0);
  }
    if(key =='b'){
   mPressed = false; 
  }
  
  if(key =='v'){
    mPressed = true;
    
  }

}
