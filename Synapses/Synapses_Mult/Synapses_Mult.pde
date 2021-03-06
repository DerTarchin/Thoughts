// Punktiert is a particle engine based and thought as an extension of Karsten Schmidt's toxiclibs.physics code. 
// This library is developed through and for an architectural context. Based on my teaching experiences over the past couple years. (c) 2012 Daniel Köhler, daniel@lab-eds.org

//here: particles with swarm behavior, additional connected with a Range-Spring

import peasy.PeasyCam;
import punktiert.math.Vec;
import punktiert.physics.*;

VPhysics physics;
VPhysics bg1;
VPhysics bg2;
VPhysics bg3;
VPhysics bg4;
VPhysics bg5;
VPhysics bg6;
VPhysics bg7;
VPhysics bg8;
VPhysics bg9;

PeasyCam cam;
float a = 0;

public void setup() {
  //size(1280, 720, OPENGL);
  fullScreen(OPENGL);
  //smooth();

  cam = new PeasyCam(this, 1000);
  cam.setMaximumDistance(2300);

  physics = new VPhysics();
  bg1 = new VPhysics();
  bg2 = new VPhysics();
  bg3 = new VPhysics();
  bg4 = new VPhysics();
  bg5 = new VPhysics();
  bg6 = new VPhysics();
  bg7 = new VPhysics();
  bg8 = new VPhysics();
  bg9 = new VPhysics();

  createColony(physics, 1000, 0, 0, 0);
  createColony(bg1, 150, -1000, 0, -1300);
  createColony(bg2, 200, 1300, 800, 1300);
  createColony(bg3, 50, 1300, -1000, -800);
  createColony(bg4, 50, -800, 500, 1300);
  createColony(bg5, 800, 700, 1300, 500);
  createColony(bg6, 400, -900, -300, 1000);
  createColony(bg7, 600, -100, -900, 300);
  createColony(bg8, 300, -300, 800, 100);
  createColony(bg9, 200, 800, 1000, -800);
}

public void draw() {
  background(0);

  drawColony(physics, 1);
  drawColony(bg1, .6);
  drawColony(bg2, .3);
  drawColony(bg3, .3);
  drawColony(bg4, .3);
  drawColony(bg5, .8);
  drawColony(bg6, .5);
  drawColony(bg7, .7);
  drawColony(bg8, .4);
  drawColony(bg9, .3);
}

void keyPressed() {
  if (key == 's') 
    save("screenshot_"+frameCount+"f.png");
  if (key=='r')
    cam.reset();
}

void createColony(VPhysics colony, int size, int cX, int cY, int cZ) {
  for (int i = 0; i < size; i++) {

    Vec pos = new Vec(cX, cY, cZ).jitter(25);
    Vec vel = new Vec(random(cX-1, cX+1), random(cY-1, cY+1), random(cZ-1, cZ+1));
    VBoid p = new VBoid(pos, vel);
    p.setRadius(50);

    p.swarm.setCohesionRadius(8);
    p.swarm.setSeperationRadius(55);
    if (size>=700) {
      p.trail.setInPast(3);
      p.trail.setreductionFactor(2);
    }
    colony.addParticle(p);

    p.addBehavior(new BCollision());

    colony.addSpring(new VSpring(p, new VParticle(cX, cY, cZ), random(size), .005f));
  }
}

void drawColony(VPhysics colony, float scale) {
  colony.update();
  for (int i = 0; i < colony.particles.size(); i++) {
    VBoid p = (VBoid) colony.particles.get(i);

    strokeWeight(5*scale);
    stroke(random(0, 145), random(145, 255), random(145, 255));
    point(p.x, p.y, p.z);
    if (scale>=.7) {
      if (frameCount > 40) {
        if (scale == 1)
          p.trail.setInPast(int(45));
        else
          p.trail.setInPast(int(35*(scale/3)));
      }

      strokeWeight(3*scale);

      noFill();
      beginShape();

      for (int j = 0; j < p.trail.particles.size(); j++) {
        VParticle t = p.trail.particles.get(j);
        if ((p.trail.particles.size()-j)%(12*scale)==0) a = 140;
        else a = 40;
        stroke(0, 222, 255, a);
        vertex(t.x, t.y, t.z);
      }
      endShape();
    }
  }
}