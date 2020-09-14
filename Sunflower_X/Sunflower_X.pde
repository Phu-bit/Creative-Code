import ddf.minim.*;
import ddf.minim.analysis.*;
//pshape 3d models
PShape building;
PShape building2;
PShape car;
PShape car2;
color c;
PImage pic;

//FFT is to analyze a signal so that the frequency spectrum may be represented in some way
//fft (fast fourier transform) is used to transform signals from the time domain to frequency domain
FFT fft;
Minim minim;
AudioPlayer song;

// Variables which define the "zones" of the freq spectrum
// For example, for bass, we only take the first 3% of the total spectrum
float specLow = 0.03; // 3%
float specMid = 0.125;  // 12.5%
float specHi = 0.40;   // 40%

// total amplitudes for each zone
float totalLow = 0;
float totalMid = 0;
float totalHi = 0;

// Previous value, to soften the reduction
float oldtotalLow;
float oldtotalMid;
float oldtotalHi;

// Softening value
float totalDecreaseRate = 25;

//create floating objects
int nObj;
Object[] objects;

void setup() {
  //load in 3d models
  building = loadShape("building1.obj");
  building2 = loadShape("building2.obj");
  car = loadShape("car1.obj");
  car2 = loadShape("car2.obj");

  //window size
  size(1000,1000,P3D);
  
  //load image in for colors 
  pic = loadImage("poster.jpg");
    
  //pass this to Minim so that it can load files from the data directory 
  minim = new Minim(this);
  
  //load song
  song = minim.loadFile("music2.mp3", 1024);
  
  //load the song size and sample rate into fft 
  fft = new FFT(song.bufferSize(), song.sampleRate());
  
  //create objects based on number of frequency bands in the low spectrum
  nObj = (int)(fft.specSize()*specLow);
  objects = new Object[nObj];
  
  for (int i = 0; i < nObj; i++) {
   objects[i] = new Object(); 
  }


  song.play(0);
  background(0);

}

void draw() {
  //shape(building);
  //performs a forward fft for each frame of the song.
  fft.forward(song.mix);
  
  //keeping the total additive amplitudes of each of the zones in a placeholder while we update the values
  oldtotalLow = totalLow;
  oldtotalMid = totalMid;
  oldtotalHi = totalHi;
  
  //reset the values 
  totalLow = 0;
  totalMid = 0;
  totalHi = 0;
  
  //calculate the totals for each zone
  for(int i = 0; i< fft.specSize()*specLow; i++){
    totalLow += fft.getBand(i); //tallys up overall amplitude of the requested frequency bands in the low spectrum
  }
  
  //gets amplitudes of freq bands from the low to mid range 
  for(int i = int((fft.specSize()*specLow)) ; i< fft.specSize()*specMid; i++){
    totalMid += fft.getBand(i); //adds amplitude of the requested frequency bands for mid
  }
  //gets totals of amplitudes from mid to high
    for(int i = int((fft.specSize()*specMid)) ; i< fft.specSize()*specHi; i++){
    totalMid += fft.getBand(i); //adds amplitude of the requested frequency bands for high
  }

  //if the amplitude of the frequncies are dropping, smoothen the rate of decrease, fade out 
  if (oldtotalLow > totalLow){
   totalLow = oldtotalLow - totalDecreaseRate; 
  }
  
    if (oldtotalMid > totalMid){
   totalLow = oldtotalLow - totalDecreaseRate; 
  }
  
    if (oldtotalHi > totalHi){
   totalLow = oldtotalLow - totalDecreaseRate; 
  }

  //keep track of the current total volume of the track, this variable will used in movement of objects
  //gives the higher frequencies more prominence, because there are less of them but sonically they are as important
  float totalGlobal = 0.66*totalLow + 0.8*totalMid + 1* totalHi;
  
  //background color changes
  background(totalLow/100, totalMid/100, totalHi/100, (100-(totalGlobal/255)));
  
  
   //object for each freq band in the low spec
    for(int i = 0; i < nObj; i++)
    {
      //retrieve value for each freq band.
      float bandValue = fft.getBand(i);
      println(bandValue);
      
      //the values passed through are only used to determine colors 
      objects[i].display(totalLow, totalMid,bandValue, totalGlobal);
    }

  // keep track of the previous freq band's value
  float previousBandValue = fft.getBand(0);
  
  // Distance between each line point, negative because on dimension z
  float dist = -25;
  
  //connect corner lines 
  beginShape();

  for(int i = 1; i < fft.specSize(); i++)
  {
    //Value of the frequency band, we multiply the bands further away so that they are more visible.
    float bandValue = fft.getBand(i)*(1 + (i/50));
    float zPosOld = dist * (i-1);
    float zPosCur = dist * i;
    //position from bottom
    float curPosFB = height - bandValue;
    float oldPosFB = height - previousBandValue;
    //position from top
    float curPosFT =  bandValue;
    float oldPosFT = previousBandValue;

    //Select the color according to the strengths of the different types of sounds
    //stroke(200+totalLow, 200+totalMid, 50+totalHi, 255-i);
    color c = pic.get(int(curPosFT),int(oldPosFT));
    stroke(c, 255-i);
    strokeWeight(1 + (totalGlobal/150));
    noFill();
    
    // lower left 
    curveVertex(0,oldPosFB,zPosOld);
    curveVertex(0,curPosFB, zPosCur);
    curveVertex(oldPosFT,height,zPosOld);
    curveVertex(curPosFT,height,zPosCur);
    curveVertex(0,oldPosFB,zPosOld);
    curveVertex(curPosFT,height,zPosCur);
    
    //draw line from prev band's value to current bands value from the bottom in the y direection at a z distance away
    //line(0, height-(previousBandValue*heightMult), dist*(i-1), 0, height-(bandValue*heightMult), dist*i);
    
    //draw line from same thing expect in the x direction 
    //line((previousBandValue*heightMult), height, dist*(i-1), (bandValue*heightMult), height, dist*i);
    
    //draw line from the x-axis, band's current value from the bottm in the y-axis, change in z-axis
    //to current band's value in x-axis, the bottom of the screen, and change in z-axis
    //line(0, height-(previousBandValue*heightMult), dist*(i-1), (bandValue*heightMult), height, dist*i);
    
    // top left line
    curveVertex(0,oldPosFT,zPosOld);
    curveVertex(0,curPosFT, zPosCur);
    curveVertex(oldPosFT,0,zPosOld);
    curveVertex(curPosFT,0,zPosCur);
    curveVertex(0,oldPosFT,zPosOld);
    curveVertex(curPosFT,0,zPosCur);
    //endShape();

    //line(0, (previousBandValue*heightMult), dist*(i-1), 0, (bandValue*heightMult), dist*i);
    //line((previousBandValue*heightMult), 0, dist*(i-1), (bandValue*heightMult), 0, dist*i);
    //line(0, (previousBandValue*heightMult), dist*(i-1), (bandValue*heightMult), 0, dist*i);
    
    
    //beginShape();
    // lower right line
    
    curveVertex(width,oldPosFB,zPosOld);
    curveVertex(width,curPosFB, zPosCur);
    curveVertex(width-oldPosFT,height,zPosOld);
    curveVertex(width-curPosFT,height,zPosCur);
    curveVertex(width,oldPosFT,zPosOld);
    curveVertex(width-curPosFT,height,dist*i);

    //line(width, height-(previousBandValue*heightMult), dist*(i-1), width, height-(bandValue*heightMult), dist*i);
    //line(width-(previousBandValue*heightMult), height, dist*(i-1), width-(bandValue*heightMult), height, dist*i);
    //line(width, height-(previousBandValue*heightMult), dist*(i-1), width-(bandValue*heightMult), height, dist*i);
    
    //// upper right line
    curveVertex(width,oldPosFT,zPosOld);
    curveVertex(width,curPosFT, zPosCur);
    curveVertex(width-oldPosFT,0,zPosOld);
    curveVertex(width-curPosFT,0,zPosCur);
    curveVertex(width,oldPosFT,zPosOld);
    curveVertex(width-curPosFT,0,dist*i);

    //line(width, (previousBandValue*heightMult), dist*(i-1), width, (bandValue*heightMult), dist*i);
    //line(width-(previousBandValue*heightMult), 0, dist*(i-1), width-(bandValue*heightMult), 0, dist*i);
    //line(width, (previousBandValue*heightMult), dist*(i-1), width-(bandValue*heightMult), 0, dist*i);
    // Save the value for the next loop round
    previousBandValue = bandValue;
  }  
      endShape();
      
    


}
