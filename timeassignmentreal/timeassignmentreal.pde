import ddf.minim.*;
import ddf.minim.analysis.*;
PImage pic;
PImage pic2;
PShader shift;
PShader blur;
PShape number;

FFT fft;
Minim minim;
AudioPlayer song;

float specLow = 0.03; // 3%
float specMid = 0.125;  // 12.5%
float specHi = 0.40;   // 40%

float totalLow = 0;
float totalMid = 0;
float totalHi = 0;

float oldtotalLow;
float oldtotalMid;
float oldtotalHi;

float totalDecreaseRate = 25;

//create floating objects
int nParticles;
Particles[] particles;

int nNumbers = 12;

Clocks[] clocks;

void setup() {
  size(1000,1000,P3D);
  number = loadShape("2.obj");
  shift = loadShader("shift.glsl");
  blur = loadShader("blur.glsl");
  pic = loadImage("poster.jpg");
  pic2 = loadImage("poster2.jpg");
  
  minim = new Minim(this);
  song = minim.loadFile("song.mp3", 1024);
  fft = new FFT(song.bufferSize(), song.sampleRate());
  
  nParticles = (int)(fft.specSize()*specHi);
  particles = new Particles[nParticles];
  
  for (int i = 0; i < nParticles; i++) {
   particles[i] = new Particles(); 
  }
  
  clocks = new Clocks[nNumbers];
  
  for (int i = 0; i < nNumbers; i++) {
   clocks[i] = new Clocks(); 
  }


  background(0);

}

void draw(){
  fft.forward(song.mix);
  //calculating totals for the spectrum zones
  oldtotalLow = totalLow;
  oldtotalMid = totalMid;
  oldtotalHi = totalHi;
  totalLow = 0;
  totalMid = 0;
  totalHi = 0;
  for(int i = 0; i< fft.specSize()*specLow; i++){
    totalLow += fft.getBand(i); 
  }
  for(int i = int((fft.specSize()*specLow)) ; i< fft.specSize()*specMid; i++){
    totalMid += fft.getBand(i); 
  }
    for(int i = int((fft.specSize()*specMid)) ; i< fft.specSize()*specHi; i++){
    totalMid += fft.getBand(i); 
  }
  if (oldtotalLow > totalLow){
   totalLow = oldtotalLow - totalDecreaseRate; 
  }
    if (oldtotalMid > totalMid){
   totalLow = oldtotalLow - totalDecreaseRate; 
    }
    if (oldtotalHi > totalHi){
   totalLow = oldtotalLow - totalDecreaseRate; 
  }
  float totalGlobal = 0.66*totalLow + 0.8*totalMid + 1* totalHi;  
  color c = pic.get(int(totalMid),int(totalHi));
  background(c,50-(totalGlobal/10));
  

  //create particles
   for(int i = 1; i < nParticles; i++)
   {
     float bandValue = fft.getBand(i);
     particles[i].display(totalLow, totalMid,bandValue, totalGlobal);
   }
   
   for(int i = 0; i < nNumbers; i++)
   {
     int whichNumber = i;
     float bandValue = fft.getBand(i);
     float previousBandValue = fft.getBand(i-1);
     clocks[i].display(totalLow,totalMid,bandValue,totalGlobal,whichNumber,previousBandValue);
   }
   
   
   
   
    //fill(255);
    //text(mouseX,mouseX,mouseY);
    //text(mouseY,mouseX,mouseY+50);
    //text(totalMid,mouseX, mouseY +100);
 }



void keyPressed(){
   if( song.isPlaying()){
     song.pause();
   
    }else{
      int start = 65000;
     song.play(); 
  }
}
