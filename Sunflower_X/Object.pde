class Object {
  
  //spawn in far back. define a maximum closeness for Z
  float spawnZ = -10000;
  float maxZ = 1000;
  
  //define positions and rotations
  float x,y,z;
  float rotX, rotY,rotZ;
  float sumRotX, sumRotY, sumRotZ;
  
  Object() {
    //give em some random rotation and positions
    x = random(0,width);
    y = random(0,width);
    z = random(spawnZ,maxZ);
    
    rotX = random(0,1);
    rotY = random(0,1);
    rotZ = random(0,1);
  }
  
  void display(float totalLow, float totalMid, float bandValue, float totalGlobal){
    
    //go ahead and grab the colors from the picture based on the totallow and totalmid
    color c = pic.get(int(totalLow*0.67),int(totalMid*0.67));
    //alpha level based on bandValue. so when bandValue low, alpha is low 
    fill(c, bandValue*10);

    //matrix transformations
    pushMatrix();
    
    //displace using the random variables
    translate(x, y, z);
    
    //calculate rotation according to bandvalue and randomn rot variables for each object 
    sumRotX += bandValue*(rotX/1000);
    sumRotY += bandValue*(rotY/1000);
    sumRotZ += bandValue*(rotZ/1000);
    
    //rotate each object 
    rotateX(sumRotX);
    rotateY(sumRotY);
    rotateZ(sumRotZ);
    
    //setting the fill of each object
    building.setFill(c);
    building2.setFill(c);
    car.setFill(c);
    car2.setFill(c);
    
    //random object generation based upon a random variable, who woulda thought
    
    float choice = random(100);
    
    if(choice <35)
    {
         shape(building);
    }
    else if(choice < 70 && choice > 35)
    {
        shape(building2);
    }else if(choice > 70 && choice < 85)
    {
      shape(car);
    }else{
      shape(car2);
    }
    //reset matrix
    popMatrix();
    
    //z displacement. objects will move forward based upon band value and total volume
    z+= (1+(bandValue/5)+(pow((totalGlobal/150), 2)));
    //resets the object once it reaches the front
    if (z >= maxZ) {
      x = random(0, width);
      y = random(0, height);
      z = spawnZ;
    }
  }
}
