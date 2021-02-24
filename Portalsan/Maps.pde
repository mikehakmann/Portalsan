class Maps {
  
  PImage loadMap(int stage) {  //a function for switching the current map/stage
    if (stage == 0) {
      spawnX = width*0.1;
      spawnY = height*0.89;
      return tutorialStage;
    }
    
    if (stage == 1) {
      return stage1;
    }
    
    if (stage == 2) {
      return tutorialStage;
    }
    
    return error;
  }
}
