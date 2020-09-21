class Particles {
  
  //spawn in far back. define a maximum closeness for Z
  float spawnZ = -10000;
  float maxZ = 1000;
  //define positions and rotations
  float x,y,z,pz,radius,radiusOld;
  


  Particles() {
    x = random(0,width);
    y = random(0,width);
    z = random(spawnZ,maxZ);
    pz = z;
  }
  
  void display(float totalLow, float totalMid, float bandValue, float totalGlobal){
    radius = 0;
    radiusOld = radius;

    fill(255, totalGlobal/3);
    radius = bandValue*3;
    if(radius<radiusOld){
      radius -= 3;
    }else{
      radiusOld = radius;
    }

    
    
    noStroke();
    pushMatrix();
    translate(x, y, z);
    //ellipse(0,0,radius,radius);
    
    if(totalMid<400){
    stroke(251, 190, 70,bandValue*3);
    }else{
    stroke(233, 4, 4,bandValue*3);
    }
    line(0,0,pz,0,0,z);
    popMatrix();
    
    z+= (1+(bandValue/5)+(pow((totalGlobal/150), 2)))+30;
    
    if (z >= maxZ) {
      x = random(0, width);
      y = random(0, height);
      z = spawnZ;
      pz = z;
    }
  }
}
