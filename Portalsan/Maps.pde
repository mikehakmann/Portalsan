class Maps {
  int stage = 0;
  int black = -16777216;  //the color 'black' as an int (obtained with get())
  int bgColor = -6574665; //the color of the background (blue/cyan-ish) as an int
  float spawnX, spawnY;
  boolean displayLava = false;

  Maps() {
    player = loadImage("Steve.png");
    portalGun = loadImage("portal_gun.png");
    tutorialStage = loadImage("tutorial.png");
    stage1 = loadImage("stage_1.png");
    stage2 = loadImage("stage_2.png");
    stage3 = loadImage("stage_3.png");
    error = loadImage("error.png");
    lever = loadImage("lever.png");
    button = loadImage("unpoweredButton.png");
    poweredButton = loadImage("poweredButton.png");

    stage2_lever1Effect = loadImage("stage2_lever1Effect.png");
    stage2_button1Effect = loadImage("stage2_button1Effect.png");

    spawnX = 80;
    spawnY = 535;
  }

  PImage loadMap(int stage) {  //a function for switching the current map/stage
    switch(stage) {
    case 0:
      return tutorialStage;

    case 1:
      return stage1;

    case 2:
      return stage2;

    case 3:
      return stage3;

    default:
      return error;//returns error-image, in case a non-existant map is to be loaded
    }
  }

  void checkMapChange() {
    if (stage == 0) { //if player is on tutorial map
      if (p.pos.x >= 760 && p.pos.x <= width) { //if player is within the end part of this map
        if (p.pos.y >= 10 && p.pos.y <= 75) {   //"
          stage = 1; //change stage
          spawnX = 10; //update spawnpoint
          spawnY = 50; //"
          p.respawnPlayer(); //spawns player at (spawnX, spawnY)

          pg.resetPortals(0); //to reset both portals

          println("Moving on to Stage 1!");
        }
      }
    }

    if (stage == 1) {
      if (p.pos.x >= 790 && p.pos.x <= width) {
        if (p.pos.y >= 500 && p.pos.y <= 550) {
          stage = 2;
          spawnX = 25;
          spawnY = 535;
          p.respawnPlayer();

          pg.resetPortals(0);

          println("Moving on to Stage 2!");
        }
      }
    }

    if (stage == 2) {
      if (p.pos.x >= 790 && p.pos.z <= width) { //bottom exit
        if (p.pos.y >= 460 && p.pos.y <= 525) {
          stage = 3;
          spawnX = 30;
          spawnY = 535;
          p.respawnPlayer();

          pg.resetPortals(0);
          
          println("Moving on to Stage 3!");
        }
      }
      
      if (p.pos.x >= 790 && p.pos.z <= width) { //top exit
        if (p.pos.y >= 40 && p.pos.y <= 95) {
          stage = 3;
          spawnX = 30;
          spawnY = 80;
          p.respawnPlayer();

          pg.resetPortals(0);
          
          println("Moving on to Stage 3!");
        }
      }
    }

    if (stage == 3) {
      displayLava = true; //this stage has lava
      if (p.pos.x >= 0 && p.pos.x <= 15) {      //if player goes back through the exit,
        if (p.pos.y >= 500 && p.pos.y <= 550) { //then spawns player at the corresponding entry
          stage = 2;
          spawnX = 780;
          spawnY = 507;
          p.respawnPlayer();

          pg.resetPortals(0);

          println("Moving back to Stage 2!");
        }
      }
    }//
    else {
      displayLava = false;
    }
  }
}
