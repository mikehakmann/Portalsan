class Maps {
  
  //int checkStage() {
  //  if (stage == 0  &&  ) {
      
  //  }
    
  //  if () {
      
  //  }
    
  //  if () {
      
  //  }
    
    
  //}
  
  
  PImage loadMap(int stage) {  //a function for switching the current map/stage
    if (stage == 0) {
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
