class Maps {
  int stage = 0;
  float spawnX, spawnY;

  Maps() {
    spawnX = 80;
    spawnY = 535;
  }

  PImage loadMap(int stage) {  //a function for switching the current map/stage
    if (stage == 0) {
      return tutorialStage;
    }

    if (stage == 1) {
      return stage1;
    }

    if (stage == 2) {
      return tutorialStage; //there are no more stages, so just goes back to tutorial
    }

    return error; //returns error-image, in case a non-existant map is to be loaded
  }

  void checkMapChange() {
    if (stage == 0) { //if player is on tutorial map
      if (p.pos.x >= 760 && p.pos.x <= width) { //if player is within the end part of this map
        if (p.pos.y >= 10 && p.pos.y <= 75) {   //"
          stage = 1; //change stage
          spawnX = 10; //update spawnpoint
          spawnY = 50; //"
          p.respawnPlayer(); //spawns player at (spawnX, spawnY)
          
          pg.resetPortals(1); //to reset both portals
          pg.resetPortals(2); //
          
          println("Advancing to Stage 1!");
        }
      }
    }
    
    if (stage == 1) {
      if (p.pos.x >= 790 && p.pos.x <= width) {
        if (p.pos.y >= 500 && p.pos.y <= 550) {
          stage = 2; //change stage
          spawnX = 80; //update spawnpoint
          spawnY = 535; //"
          p.respawnPlayer();
          
          pg.resetPortals(1);
          pg.resetPortals(2);
          
          println("Advancing to Tutorial Stage! (we don't have more stages)");
        }
      }
    }
  }
}
