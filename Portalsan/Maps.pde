class Maps {
  int stage = 0;
  int black = -16777216;  //the color 'black' as an int (obtained with get())
  int yellow = -2621696;  //the color 'yellow' as an int (used to disable portal use - player can still walk on it)
  int bgColor = -6574665; //the color of the background (blue/cyan-ish) as an int
  float spawnX, spawnY, lever1Angle, lever2Angle, lever3Angle;
  boolean activate, loadLava = false, secretDiscovered = false;
  boolean button1Powered, button2Powered, loadButton2, loadLever1, loadLever2, loadLever3, coverUp;

  Maps() {
    player = loadImage("John_Connor.png");
    portalGun = loadImage("portal_gun.png");
    tutorialStage = loadImage("tutorial.png");
    stage1 = loadImage("stage_1.png");
    stage2 = loadImage("stage_2.png");
    stage3 = loadImage("stage_3.png");
    stage4 = loadImage("stage_4.png"); //the victory stage
    error = loadImage("error.png");

    button = loadImage("unpoweredButton.png");
    poweredButton = loadImage("poweredButton.png");
    lever = loadImage("lever.png");
    secretArea = loadImage("stage_3_secret.png");

    button1 = loadImage("button1Effect.png");
    button2 = loadImage("terminator_hand.png");
    lever1 = loadImage("lever1Effect.png");
    lever2 = loadImage("lever2Effect.png");
    lever3 = loadImage("lever3Effect.png");

    spawnX = 80;
    spawnY = 520; //was originally 535 but new verticleMovement code dies instantly with that value :/
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

    case 4:
      return stage4;

    default:
      return error;//returns error-image, in case a non-existant map is to be loaded
    }
  }

  int colorAt(float x, float y) { //all collision relies on color, so this function is often used
    return get(int(x), int(y));
  }


  void mapProperties() { //function for loading specific stage utilities, like lava or levers, and also changes maps (verry repetitive, though)
    if (stage == 0) { //if player is on tutorial map
      if (p.pos.x >= 780 && p.pos.x <= width) { //if player is within the end part of this map
        if (p.pos.y >= 10 && p.pos.y <= 75) {   //"
          stage = 1; //change stage
          spawnX = 30; //update spawnpoint
          spawnY = 50; //"

          p.respawnPlayer(); //spawns player at (spawnX, spawnY)
          pg.resetPortals(0); //to reset both portals

          println("Moving on to Stage 1!");
        }
      }
    }


    if (stage == 1) {
      if (p.pos.x >= 790 && p.pos.x <= width) { //move from stage 1 to stage 2
        if (p.pos.y >= 500 && p.pos.y <= 550) {
          stage = 2;
          spawnX = 40;
          spawnY = 535;

          p.respawnPlayer();
          pg.resetPortals(0);

          println("Moving on to Stage 2!");
        }
      }

      if (p.pos.x >= 0 && p.pos.x <= 15) {
        if (p.pos.y >= 10 && p.pos.y  <= 75) {
          stage = 0;
          spawnX = 760;
          spawnY = 50;

          p.respawnPlayer();
          pg.resetPortals(0);

          println("Moving back to Tutorial Stage!");
        }
      }
    }


    if (stage == 2) {
      loadLever1 = true;

      if (activate) { //if 'E' is pressed, check if player is within bounds of lever:
        if (p.pos.x >= 325 && p.pos.x <= 375) {
          if (p.pos.y >= 465 && p.pos.y <= 525) {
            lever1Angle = PI; //if so, set angle of rotation on lever1 to PI,
          }                  //to simulate pulling it down
        }
      }

      if (p.pos.x >= 0 && p.pos.x <= 15) { //return to stage 1 from stage 2 entrance
        if (p.pos.y >= 500 && p.pos.y <= 550) {
          stage = 1;
          spawnX = 780;
          spawnY = 535;

          p.respawnPlayer();
          pg.resetPortals(0);

          println("Moving back to Stage 1!");
        }
      }

      if (p.pos.x >= 790 && p.pos.z <= width) { //continue to stage 3 through the top exit
        if (p.pos.y >= 40 && p.pos.y <= 95) {
          stage = 3;
          spawnX = 30;
          spawnY = 80;

          p.respawnPlayer();
          pg.resetPortals(0);

          println("Moving on to Stage 3!");
        }
      }

      if (p.pos.x >= 790 && p.pos.z <= width) { //continue to stage 3 through the bottom exit
        if (p.pos.y >= 500 && p.pos.y <= 550) {
          stage = 3;
          spawnX = 30;
          spawnY = 535;

          p.respawnPlayer();
          pg.resetPortals(0);

          println("Moving on to Stage 3!");
        }
      }
    }//
    else { //if stage is *not* 2, then lever1 shouldn't be loaded/rendered or usable
      loadLever1 = false;
    }


    if (stage == 3) {
      loadLava = true;
      loadLever2 = true;
      loadLever3 = true;
      loadButton2 = true;
      coverUp = true;
      if (activate) {
        if (p.pos.x >= 15 && p.pos.x <= 65) {
          if (p.pos.y >= 280 && p.pos.y <= 340) {
            lever2Angle = PI;
          }
        }

        if (p.pos.x >= 700 && p.pos.x <= 750) {
          if (p.pos.y >= 280 && p.pos.y <= 340) {
            lever3Angle = PI;
          }
        }
      }

      if (p.pos.x >= 249 && p.pos.x <= 473 && p.pos.y >= 551 && p.pos.y <= 590 ||
        p.pos.x >= 565 && p.pos.x <= 789 && p.pos.y >= 156 && p.pos.y <= 197) { //killboxes for the lava
        p.respawnPlayer();
      }

      if (p.pos.x >= 790 && p.pos.x <= width) {
        if (p.pos.y >= 500 && p.pos.y <= 550) {
          stage = 4;
          spawnX = 30;
          spawnY = 535;

          p.respawnPlayer();
          pg.resetPortals(0);

          println("Moving on to Victory!");
        }
      }

      if (p.pos.x >= 0 && p.pos.x <= 15) { //return to stage 2 from stage 3 top entrance
        if (p.pos.y >= 40 && p.pos.y <= 95) {
          stage = 2;
          spawnX = 780;
          spawnY = 80;

          p.respawnPlayer();
          pg.resetPortals(0);

          println("Moving back to Stage 2!");
        }
      }

      if (p.pos.x >= 0 && p.pos.x <= 15) { //return to stage 2 from stage 3 bottom entrance
        if (p.pos.y >= 500 && p.pos.y <= 550) {
          stage = 2;
          spawnX = 780;
          spawnY = 535;

          p.respawnPlayer();
          pg.resetPortals(0);

          println("Moving back to Stage 2!");
        }
      }
    }//
    else {
      loadLava = false;
      loadLever2 = false;
      loadLever3 = false;
      loadButton2 = false;
      coverUp = false;
    }


    if (stage == 4) {
      if (p.pos.x >= 0 && p.pos.x <= 15) {
        if (p.pos.y >= 500 && p.pos.y <= 550) {
          stage = 3;
          spawnX = 780;
          spawnY = 535;

          p.respawnPlayer();
          pg.resetPortals(0);

          println("Moving back to Stage 3!");
        }
      }
    }
  }
  


  void loadMapImages() {
    if (stage == 0) {
      displayText(0);
    }
    
    /*-----------------------------------------------------------------------------------*/
    
    else if (stage == 2) {
      displayText(2);
      
      pushMatrix();
      translate(350, 495);
      rotate(lever1Angle); //rotate lever with specific angle - changed if lever is activated
      image(lever, 0, 0);
      popMatrix();

      if (lever1Angle == PI) { //if lever is pulled (i.e. is rotated PI to point down)
        pushMatrix();
        translate(width/2, height/2);
        image(lever1, 0, 0);
        popMatrix();

        if (!button1Powered) { //button appears only after lever is pulled
          image(button, 435, 47); //render the unpowered buttons by default
          image(button, 771, 82); //"
        }

        if (p.pos.x >= 415 && p.pos.x <= 455 && p.pos.y >= 40 && p.pos.y <= 60 || //if player is within either button's bounds:
          p.pos.x >= 751 && p.pos.x <= 780 && p.pos.y >= 75 && p.pos.y <= 95) {

          image(poweredButton, 435, 47); //render the powered buttons
          image(poweredButton, 771, 82); //"
          button1Powered = true; //set this to true, so unpowered isn't rendered too
          pushMatrix();
          translate(width/2, height/2);
          image(button1, 0, 0);
          popMatrix();
        }//
        else {
          button1Powered = false; //unpower button if player isn't near it
        }
      }
    }

    /*-----------------------------------------------------------------------------------*/
    
    else if (stage == 3) {
      displayText(3);

      if (!button2Powered) { //loadButton2 is only for rendering it, while Button2Powered also can switch between button images
        image(button, 50, 233);
      }

      if (p.pos.x >= 30 && p.pos.x <= 70) {
        if (p.pos.y >= 225 && p.pos.y <= 245) {
          image(poweredButton, 50, 233);
          button2Powered = true;
          secretDiscovered = true; //used to alter the victory text a little
          
          pushMatrix();
          translate(width/2, height/2);
          image(button2, 0, 0);
          popMatrix();
        }//
        else {
          button2Powered = false; //if both if-statements didn't have these else, then button would disappear
        }
      }//
      else {
        button2Powered = false;  //either after use, or when jumping above it
      }

      image(lava, 361, 570);
      image(lava, 677, 178);

      pushMatrix();
      translate(40, 310);
      rotate(lever2Angle);
      image(lever, 0, 0);
      popMatrix();

      if (lever2Angle == PI) {
        pushMatrix();
        translate(width/2, height/2);
        image(lever2, 0, 0);
        popMatrix();
      }

      pushMatrix();
      translate(725, 310);
      rotate(lever3Angle);
      image(lever, 0, 0);
      popMatrix();

      if (lever3Angle == PI) {
        pushMatrix();
        translate(width/2, height/2);
        image(lever3, 0, 0);
        popMatrix();
      }
    }
    
    /*-----------------------------------------------------------------------------------*/
    
    else if (stage == 4) {
      displayText(4); //this displays the victory text
    }
  }


  void displayText(int currStage) { //function for displaying tutorial-info and victory text
    fill(255); //text should usually be white, unless a specific stage needs another color
    
    if (currStage == 0) {
      textAlign(LEFT, CENTER);
      textSize(14);

      text("Move with 'A' and 'D'", 25, 30);
      text("Jump using SPACEBAR", 25, 60);
      text("Shoot portals using LEFT and RIGHT mouse button", 25, 90);
      text("Reset the portals by pressing 'R'", 25, 120);
      text("Keep yourrself from teleporting by holding SHIFT", 25, 150);
    }
    
    else if (stage == 2) {
      textAlign(LEFT, CENTER);
      textSize(14);
      
      text("Pull levers with 'E' when standing near them", 25, 40);
      text("Levers stay activated for the remainder of the game", 25, 57);
      text("Stand on buttons will activate them.", 25, 87);
      text("Stepping off deactivates them", 25, 104);
    }

    else if (currStage == 3) {
      textAlign(CENTER, CENTER);
      textSize(14);
      text("Notice: Yellow walls and portals don't get along well, so portals can't be placed on them", width/2, 363);
    }

    else if (currStage == 4) {
      fill(50);
      textAlign(CENTER, CENTER);
      textSize(30);
      
      text("Congratulations, John Connor!", width/2, 170);
      text("You beat the game!", width/2, 210);
      
      textSize(20);
      if (!secretDiscovered) {
        text("... But did you find the hidden reference?", width/2, 260);
      }
      else {
        text("And remember: I'll be Back", width/2, 260);
      }
    }
    
    fill(255); //to make sure following things (like the bullet) get their correct color back
  }
}
