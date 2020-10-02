import peasy.*;
import processing.video.*;
import ddf.minim.*;

PeasyCam camera;
Minim minim;
AudioPlayer song;
Movie video;

PImage pic;
int x,y;
float a;
float aChange = 0.015;
boolean mPressed = true;

void setup(){
  camera = new PeasyCam(this, width/2, height/2, -1000, 1800);
  camera.setSuppressRollRotationMode(); // like a somersault
  camera.reset(2000);

  size(1000,1000,P3D);
  //fullScreen(P3D);
  minim = new Minim(this);
  song = minim.loadFile("song.mp3", 1024);
  video = new Movie(this, "video4.mp4");
  video.loop();
  pic = loadImage("hand.jpg");
  background(0);
}

void draw(){   
   
  //loadPixels();
  video.loadPixels();
  pic.loadPixels();
  video.read();
  
  if(mPressed){
    background(0);
  }
  //pushMatrix();
  //translate(width/4,0,0);
  //rotateY(a);
  //rotateX(a);
  //background(0);
  //image(video,0,0);
    for(int x = 0; x<width; x++){
      for(int y = 0; y<height; y+=25){
          //for(int i = 0; i < song.bufferSize() - 1; i++){

       int loc = x+y*video.width;
       color c = video.get(x,y);
       float b = brightness(video.pixels[loc]);
       float z = map(b, 0, 255, -1000,0);
       //float x1 = map( i , 0, song.bufferSize(),0,width);
       //float x2 = map( i+1 , 0, song.bufferSize(), 0 , width);
       float x3 = song.left.get(y)*100 ;
       float x4 = song.right.get(x)*100;
       float master = song.mix.get(x)*100;
  
        stroke(c);
        //fill(c-b);
        
        pushMatrix();
        translate(x,y,z+song.mix.get(x)*150);
        //translate(0,0,song.mix.get(x)*10);
        rotateZ(x3);
        rotateY(x4);
        rotateX(master);
        line(0,0,0,song.left.get(x),song.right.get(x),song.mix.get(x)*100);
        popMatrix();
        
        //pixels[loc] = pic.pixels[loc];
      //}
    }
  }
    //popMatrix();
    if(abs(a)>=1.15){
      aChange *= -1;
    }
    a+=aChange;
  //textSize(100);
  //fill(255);
  //text(a,mouseX,mouseY);
  //updatePixels();
}

void keyPressed(){
  if(key == 'z'){
     if(song.isPlaying()){
       song.pause();
      }else{
       song.play(); 
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

//void mouseClicked(){
//  mPressed = true;
//}

//void mouseReleased(){
//  mPressed = false;
//}
