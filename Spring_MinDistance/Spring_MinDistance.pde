// Punktiert is a particle engine based and thought as an extension of Karsten Schmidt's toxiclibs.physics code. 
// This library is developed through and for an architectural context. Based on my teaching experiences over the past couple years. (c) 2012 Daniel Köhler, daniel@lab-eds.org

//here: particles with swarm behavior, additional connected with a Range-Spring

import peasy.PeasyCam;
import punktiert.math.Vec;
import punktiert.physics.*;

VPhysics physics;

PeasyCam cam;

public void setup() {
  size(1280, 720, OPENGL);
  smooth();

  cam = new PeasyCam(this, 1000);

  physics = new VPhysics();

  for (int i = 0; i < 1000; i++) {

    Vec pos = new Vec(0, 0, 0).jitter(25);
    Vec vel = new Vec(random(-1, 1), random(-1, 1), random(-1, 1));
    VBoid p = new VBoid(pos, vel);
    p.setRadius(50);

    p.swarm.setCohesionRadius(8);
    p.swarm.setSeperationRadius(55);
    p.trail.setInPast(3);
    p.trail.setreductionFactor(2);
    physics.addParticle(p);

    p.addBehavior(new BCollision());

    //physics.addSpring(new VSpringRange(p, new VParticle(), 50, 500, .00005f));
    physics.addSpring(new VSpring(p, new VParticle(), random(1000), .005f));
    //println(physics.string.getStrength());
    
    for (int j=0; j< int(random(5)); j++) {
      if (j>=3) {
        VBoid p2 = (VBoid) physics.particles.get(int(random(physics.particles.size()))); 
        //noFill();
        //bezier(p.x, p.y, p.z, p.x/2, p.y/2, p.z/2, p2.x, p2.y, p2.z, p2.x/2, p2.y/2, p2.z/2);
      }
    }
  }
}

public void draw() {
  background(0);

  physics.update();
  for (int i = 0; i < physics.particles.size(); i++) {
    VBoid p = (VBoid) physics.particles.get(i);

    strokeWeight(5);
    stroke(random(0, 145), random(145, 255), random(145, 255));
    point(p.x, p.y, p.z);
    strokeWeight(2);
    
    if (frameCount > 100) {
      p.trail.setInPast(100);
    }
    strokeWeight(2);
    noFill();
    beginShape();
    for (int j = 0; j < p.trail.particles.size(); j++) {
     VParticle t = p.trail.particles.get(j);
     float a = 40;
     if(j%3==0) a = 140;
     stroke(0, 222, 255, a);
     vertex(t.x, t.y, t.z);
    }
    endShape();
  }
}