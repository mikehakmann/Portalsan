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
      return tutorialStage;
    }

    return error;
  }

  void checkMapChange() {
    if (stage == 0) { //if player is on tutorial map
      if (p.pos.x >= 760 && p.pos.x <= width) { //if player is within the end part of this map
        if (p.pos.y >= 10 && p.pos.y <= 75) {   //"
          stage = 1; //change stage
          p.pos.x = 25; //update player's pos to match
          p.pos.y = 50; //"
          
          pg.resetPortals(1);
          pg.resetPortals(2);
        }
      }
    }
  }
}
