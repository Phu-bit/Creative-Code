class Clocks{
  
  float spawnZ = -10000;
  float maxZ = -1000;
  float maxX;
  float maxY;
  float x,y,z,zp;
  float rotX, rotY,rotZ;
  float sumRotX, sumRotY, sumRotZ;
  int xPos[] = new int[12];
  int yPos[] = new int[12];
  String[] numbers = new String[12];

  Clocks() {
    
    for(int i = 0; i<12;i++){
      xPos[i] = int(cos(degrees(30)*i) * height * 2/4);
      yPos[i] = int(sin(degrees(30)*i) * height * 2/4);
      println(xPos[i]);
    }
    
  for(int i = 0; i<12; i++)
   {
    numbers[i] = str(i+1);
   }

    
    z = random(spawnZ,maxZ);
    zp = z;
    rotX = random(0,1);
    rotY = random(0,1);
    rotZ = random(0,1);
  }

 void display(float totalLow, float totalMid, float bandValue, float totalGlobal, int whichNumber, float prevBand){  
    
    color c = pic2.get(int(totalLow*0.3),int(totalMid*0.3));
    color t = pic.get(int(totalLow*0.6),int(totalMid*0.9));

    //fill(c);
    
      for (int i = 0; i < 60; i++) {
      int s = int(400 * sin(radians(6 * i - 90)));
      int j = int(400 * cos(radians(6 * i - 90)));
      int x1 = width / 2 + j - (int)prevBand;
      int x2 = x1 + j + (int)bandValue;
      int x3 = x2 + j - (int)bandValue;
      int y1 = height / 2 + s - (int)prevBand;
      int y2 = y1 + s+ (int)bandValue;
      int y3 = y2 + s - (int)bandValue;
      //if (i <= millis()) {
      //  line(x2, y2, x3, y3);
      //}
      if (i <= second()%60) {
        stroke(251, 190, 70,bandValue*2);
        line(x1, y1, x3, y3);
        line(x1,y2,x2,y3);
        line(x2,y3,x1,y2);
      }
      }
      
      for (int i = 0; i < 60; i++) {
      int s = int(400 * -sin(radians(6 * i - 90)));
      int j = int(300 * -cos(radians(6 * i - 90)));
      int x1 = width / 2 + j - (int)prevBand;
      int x2 = x1 + j + (int)bandValue;
      int x3 = x2 + j - (int)bandValue;
      int y1 = height / 2 + s - (int)prevBand;
      int y2 = y1 + s+ (int)bandValue;
      int y3 = y2 + s - (int)bandValue;
      //if (i <= millis()) {
      //  line(x2, y2, x3, y3);
      //}
      
      if (i <= second()) {
        stroke(251, 190, 70,bandValue*2);
        line(x1, y1, x3, y3);
        line(x1,y2,x2,y3);
        line(x2,y3,x1,y2);

      }


    }
    if(totalMid<400){
    stroke(106, 57, 250,bandValue*3);
    fill(106, 57, 250,bandValue*3);
    }else{
    stroke(233, 4, 4,bandValue*3);
    fill(106, 57, 250,bandValue*3);
    }

    pushMatrix();      
    translate(width/2, height/2);
    translate(xPos[whichNumber],yPos[whichNumber],z);

    sumRotX += bandValue*(rotX/1000);
    sumRotY += bandValue*(rotY/1000);
    sumRotZ += bandValue*(rotZ/1000);
    rotateX(sumRotX);
    rotateY(sumRotY);
    rotateZ(sumRotZ);


    textSize(100);
    text(numbers[whichNumber],0,0);
    
    popMatrix();
    
    //if(z<maxZ){
    z+= (1+(bandValue/5)+(pow((totalGlobal/150), 2)))+30;
    zp = z;

    //}
    if (z >= maxZ) {
      x = random(0, width);
      y = random(0, height);
      z = spawnZ;
    }

    }
    
 }
