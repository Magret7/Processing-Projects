class ParticleSystem { //<>//
  int numParticles;
  ArrayList<Particle> particles = new ArrayList<Particle>();
  ArrayList<Effect> effects = new ArrayList<Effect>();

  ParticleSystem(int numParticles) {
    this.numParticles = numParticles;
    for (int i = 0; i < numParticles; i++) {
      this.particles.add(new Particle(
        0, 0, 0, 0, 0, 0, 0, 1, 1, color(255)
        ));
    }
    //this.particles = new ArrayList<Particle>(numParticles);
  }

  void display() {
    for (Particle p : this.particles) {
      if (p.active) {
        p.display();
      }
    }

    ArrayList<Effect> effectsToRemove = new ArrayList<Effect>();
    for (Effect e : this.effects) {
      if (e.readyToDelete) {
        effectsToRemove.add(e);
      } else {
        e.update();
      }
    }
    this.effects.removeAll(effectsToRemove);
  }

  void checkEnoughParticles(int particlesNeeded) {
    // check for free particles
    int activeParticles = 0;
    for (Particle p : this.particles) {
      if (p.inUse) {
        activeParticles++;
      }
    }
      
    //print("active particles: " + activeParticles + "    particle list size: " + this.particles.size() + "\n");
    if (particlesNeeded > this.numParticles - activeParticles) {
      int particlesToGenerate = particlesNeeded - this.numParticles - activeParticles;
      for (int i = 0; i < particlesToGenerate; i++) {
        this.particles.add(new Particle(
          0, 0, 0, 0, 0, 0, 0, 1, 1, color(255)
          ));
          this.numParticles++;
      }
      //print("new particle count: " + this.numParticles + "particle list size: " + this.particles.size());
    }
  }

  RunParticles assignRunParticles(PVector sourcePos, Boolean startActive) {
    RunParticles newEffect = new RunParticles(sourcePos, startActive);

    int particlesRequired = newEffect.maxParticles;
    checkEnoughParticles(particlesRequired);

    int particlesAssigned = 0;
    for (Particle p : this.particles) {
      if (!p.inUse) {
        newEffect.particles.add(p);
        p.inUse = true;
        particlesAssigned++;
      }
      if (particlesAssigned == particlesRequired) {
        break;
      }
    }

    //add effect to effects list
    this.effects.add(newEffect);
    return newEffect;
  }

  void emitJumpParticles(PVector sourcePos, Boolean startActive, color col) {
    burstParticles newEffect = new burstParticles(sourcePos, startActive, col);

    int particlesRequired = newEffect.maxParticles;
    checkEnoughParticles(particlesRequired);

    int particlesAssigned = 0;
    for (Particle p : this.particles) {
      if (!p.inUse) {
        newEffect.particles.add(p);
        p.inUse = true;
        particlesAssigned++;
      }
      if (particlesAssigned == particlesRequired) {
        break;
      }
    }

    //add effect to effects list
    this.effects.add(newEffect);
  }

  void emitCoinParticles(PVector sourcePos, Boolean startActive, color col) {
    coinParticles newEffect = new coinParticles(sourcePos, startActive, col);

    int particlesRequired = newEffect.maxParticles;
    checkEnoughParticles(particlesRequired);

    int particlesAssigned = 0;
    for (Particle p : this.particles) {
      if (!p.inUse) {
        newEffect.particles.add(p);
        p.inUse = true;
        particlesAssigned++;
      }
      if (particlesAssigned == particlesRequired) {
        break;
      }
    }

    this.effects.add(newEffect);
  }

  void emitHurtParticles(PVector sourcePos, Boolean startActive, color col) {
    hurtParticles newEffect = new hurtParticles(sourcePos, startActive, col);

    int particlesRequired = newEffect.maxParticles;
    checkEnoughParticles(particlesRequired);

    int particlesAssigned = 0;
    for (Particle p : this.particles) {
      if (!p.inUse) {
        newEffect.particles.add(p);
        p.inUse = true;
        particlesAssigned++;
      }
      if (particlesAssigned == particlesRequired) {
        break;
      }
    }

    this.effects.add(newEffect);
  }
}

class Effect {
  int numParticles = 0;
  int spawnedParticles;
  PVector sourcePos;
  float duration;
  Boolean active;
  Boolean readyToDelete = false;
  ArrayList<Particle> particles = new ArrayList<Particle>();

  Effect(PVector sourcePos, Boolean active) {
    this.sourcePos = sourcePos;
    this.active = active;
  }

  void update() {
  }
}

class hurtParticles extends Effect {
  int fadeTimer = 0;
  float fadeInterval = 0.001;
  int maxParticles = 25;
  float fadeRate = 100.0;
  float shrinkRate = 10;
  float gravityForce = 0.1;
  float rotationRate = 10;
  color startColor;
  Boolean initialized = false;

  hurtParticles(PVector sourcePos, Boolean active, color col) {
    super(sourcePos, active);
    this.startColor = col;
  }
  void update() {
    // spawn particles
    if (!this.initialized) {
      for (Particle p : this.particles) {
        p.active = true;
        p.pos = new PVector(this.sourcePos.x + random(-20, 20), this.sourcePos.y  + random(-20, 20));
        p.vel = new PVector(0, 0);
        p.acc = new PVector(0, 0);
        p.c = startColor;
        p.w = random(2.0, 10.0);
        p.m = 1;
        p.constantXForce = random(-0.8, 0.8);
        p.constantYForce = random(-0.8, 0.1);
        //p.applyConstantForce();
        this.numParticles++;
      }
      //print("radial burst initialized, particle count: " + this.numParticles);
      this.initialized = true;
    }

    // update particles
    ArrayList<Particle> particlesToRemove = new ArrayList<Particle>();
    for (Particle p : this.particles) {
      // apply forces
      p.applyConstantForce();
      p.applyForces(0, this.gravityForce);
      p.constantXForce = lerp(p.constantXForce, 0, 0.5);
      p.constantYForce = lerp(p.constantYForce, 0, 0.5);

      Boolean canFade = ((millis() - this.fadeTimer) >= (this.fadeInterval * 1000));
      if (canFade) {
        this.fadeTimer = millis();
        //print("fade frame");
      }
      p.rot += this.rotationRate;
      if (canFade) {
        //print("alpha calc: " + (alpha(p.c) - (this.fadeRate / 100)));
        float newAlpha = alpha(p.c) - (this.fadeRate);
        p.c = color(red(p.c), green(p.c), blue(p.c), newAlpha);
        //print("newAlpha: " + newAlpha + "alpha: " + alpha(p.c) + "\n");
        p.w = constrain(p.w - this.shrinkRate, 0, 1000);
      }

      // free particle
      if (alpha(p.c) <= 0 || p.w == 0) {
        //print("free burst particle");
        p.inUse = false;
        p.active = false;
        particlesToRemove.add(p);
        this.numParticles --;
      }
    }
    this.particles.removeAll(particlesToRemove);

    // effect finished
    if (this.numParticles == 0) {
      //print("burst effect deleted");
      this.readyToDelete = true;
    }
  }
}

class coinParticles extends Effect {
  int fadeTimer = 0;
  float fadeInterval = 0.001;
  int maxParticles = 50;
  float fadeRate = 100.0;
  float shrinkRate = 10;
  float gravityForce = 0.05;
  float rotationRate = 10;
  color startColor;
  Boolean initialized = false;

  coinParticles(PVector sourcePos, Boolean active, color col) {
    super(sourcePos, active);
    this.startColor = col;
  }
  void update() {
    // spawn particles
    if (!this.initialized) {
      for (Particle p : this.particles) {
        p.active = true;
        p.pos = new PVector(this.sourcePos.x + random(-10, 10), this.sourcePos.y  + random(-10, 10));
        p.vel = new PVector(0, 0);
        p.acc = new PVector(0, 0);
        p.c = startColor;
        p.w = random(2.0, 5.0);
        p.m = 1;
        p.constantXForce = random(-0.8, 0.8);
        p.constantYForce = random(-0.8, 0.8);
        p.applyConstantForce();
        this.numParticles++;
      }
      //print("radial burst initialized, particle count: " + this.numParticles);
      this.initialized = true;
    }

    // update particles
    ArrayList<Particle> particlesToRemove = new ArrayList<Particle>();
    for (Particle p : this.particles) {
      // apply forces
      p.applyConstantForce();
      p.applyForces(0, this.gravityForce);
      p.constantXForce = lerp(p.constantXForce, 0, 0.9);
      p.constantYForce = lerp(p.constantYForce, 0, 0.9);

      Boolean canFade = ((millis() - this.fadeTimer) >= (this.fadeInterval * 1000));
      if (canFade) {
        this.fadeTimer = millis();
        //print("fade frame");
      }
      p.rot += this.rotationRate;
      if (canFade) {
        //print("alpha calc: " + (alpha(p.c) - (this.fadeRate / 100)));
        float newAlpha = alpha(p.c) - (this.fadeRate);
        p.c = color(red(p.c), green(p.c), blue(p.c), newAlpha);
        //print("newAlpha: " + newAlpha + "alpha: " + alpha(p.c) + "\n");
        p.w = constrain(p.w - this.shrinkRate, 0, 1000);
      }

      // free particle
      if (alpha(p.c) <= 0 || p.w == 0) {
        //print("free burst particle");
        p.inUse = false;
        p.active = false;
        particlesToRemove.add(p);
        this.numParticles --;
      }
    }
    this.particles.removeAll(particlesToRemove);

    // effect finished
    if (this.numParticles == 0) {
      //print("burst effect deleted");
      this.readyToDelete = true;
    }
  }
}

class burstParticles extends Effect {
  int fadeTimer = 0;
  float fadeInterval = 0.001;
  int maxParticles = 20;
  float fadeRate = 50.0;
  float shrinkRate = 2;
  float gravityForce = 0;
  float rotationRate = 10;
  color startColor;
  Boolean initialized = false;

  burstParticles(PVector sourcePos, Boolean active, color col) {
    super(sourcePos, active);
    this.startColor = col;
  }

  void update() {
    // spawn particles
    if (!this.initialized) {
      for (Particle p : this.particles) {
        p.active = true;
        p.pos = new PVector(this.sourcePos.x + random(-20, 20), this.sourcePos.y + 10);
        p.vel = new PVector(0, 0);
        p.acc = new PVector(0, 0);
        p.c = startColor;
        p.w = random(10.0, 15.0);
        p.m = 0.05;
        p.constantXForce = random(-0.01, 0.01);
        p.constantYForce = random(-0.001, -0.03);
        p.applyConstantForce();
        this.numParticles++;
      }
      //print("burst initialized, particle count: " + this.numParticles);
      this.initialized = true;
    }

    // update particles
    ArrayList<Particle> particlesToRemove = new ArrayList<Particle>();
    for (Particle p : this.particles) {
      // apply forces
      p.applyConstantForce();

      Boolean canFade = ((millis() - this.fadeTimer) >= (this.fadeInterval * 1000));
      if (canFade) {
        this.fadeTimer = millis();
        //print("fade frame");
      }
      p.rot += this.rotationRate;
      if (canFade) {
        //print("alpha calc: " + (alpha(p.c) - (this.fadeRate / 100)));
        float newAlpha = alpha(p.c) - (this.fadeRate);
        p.c = color(red(p.c), green(p.c), blue(p.c), newAlpha);
        //print("newAlpha: " + newAlpha + "alpha: " + alpha(p.c) + "\n");
        p.w = constrain(p.w - this.shrinkRate, 0, 1000);
      }

      // free particle
      if (alpha(p.c) <= 0 || p.w == 0) {
        //print("free burst particle");
        p.inUse = false;
        p.active = false;
        particlesToRemove.add(p);
        this.numParticles --;
      }
    }
    this.particles.removeAll(particlesToRemove);

    // effect finished
    if (this.numParticles == 0) {
      //print("burst effect deleted");
      this.readyToDelete = true;
    }
  }
}

class RunParticles extends Effect {
  int spawnTimer = 0;
  int fadeTimer = 0;
  float spawnInterval = 0.05;
  float fadeInterval = 0.1;
  int maxParticles = 50;
  color startColor = color(200, 200, 200, 100.0);
  float fadeRate = 25.0;
  float shrinkRate = 1;
  float gravityForce = -0.1;
  float rotationRate = 5;

  RunParticles(PVector sourcePos, Boolean active) {
    super(sourcePos, active);
    this.active = active;
  }

  void update() {
    if (this.active) {
      // "spawn" new particle, activate one
      //print("num: " + this.numParticles + "    max: "  + this.maxParticles + "\n");
      if (this.numParticles < this.maxParticles) {
        if ((millis() - this.spawnTimer) >= (this.spawnInterval * 1000)) {
          //print("time: " + ((millis() - this.spawnTimer)) + "interval: " + (this.spawnInterval * 1000) + "particles: " + this.particles.size() + "\n");
          for (Particle p : this.particles) {
            if (!p.active) {
              p.active = true;
              p.pos = new PVector(this.sourcePos.x, this.sourcePos.y + random(10.0, 15.0));
              p.vel = new PVector(0, 0);
              p.acc = new PVector(0, 0);
              p.c = startColor;
              p.w = random(10, 15.0);
              this.numParticles++;
              this.spawnTimer = millis();
              //print("run particle activated, num run particles: " + this.numParticles + "\n");
              break;
            }
          }
        }
      }
    }
    // update active particles
    Boolean canFade = ((millis() - this.fadeTimer) >= (this.fadeInterval * 1000));
    if (canFade) {
      this.fadeTimer = millis();
      //print("fade frame");
    }
    for (Particle p : this.particles) {
      if (p.active) {
        p.rot += this.rotationRate;
        p.applyForces(0, this.gravityForce);
        if (canFade) {
          //print("alpha calc: " + (alpha(p.c) - (this.fadeRate / 100)));
          float newAlpha = alpha(p.c) - (this.fadeRate);
          p.c = color(red(p.c), green(p.c), blue(p.c), newAlpha);
          //print("newAlpha: " + newAlpha + "alpha: " + alpha(p.c) + "\n");
          p.w = constrain(p.w - this.shrinkRate, 0, 1000);
        }

        // reset particle
        if (alpha(p.c) <= 0 || p.w == 0) {
          p.active = false;
          this.numParticles --;
          //print("run particle de-activated, num run particles: " + this.numParticles + "\n");
        }
      }
    }
  }
}

class Particle {
  Boolean inUse = false;
  Boolean active = false;
  PVector pos;
  float rot;
  PVector vel;
  PVector acc;
  float m;
  float w;
  color c;

  float constantXForce = 0;
  float constantYForce = 0;

  Particle(float x, float y, float rot, float vx, float vy, float ax, float ay, float mass, float w, color col) {
    this.pos = new PVector(x, y);
    this.rot = rot;
    this.vel = new PVector(vx, vy);
    this.acc = new PVector(ax, ay);
    this.m = mass;
    this.w = w;
    this.c = col;
  }

  void applyConstantForce() {
    applyForces(this.constantXForce, this.constantYForce);
  }

  void applyForces(float fx, float fy) {
    this.acc.x = fx/this.m;
    this.acc.y = fy/this.m;
    this.vel.x += this.acc.x;
    this.vel.y += this.acc.y;
    this.pos.x += this.vel.x;
    this.pos.y += this.vel.y;
  }

  void applySpringForce(float ry, float ks, float kd) {
    float f = -((ks * (this.pos.y - ry)) + kd * this.vel.y);
    float a = f/m;
    this.vel.y = this.vel.y + a;
    this.pos.y += this.vel.y;
  }

  void applyConnectedForce(float rx, float ry, float ks, float kd) {
    float fx = -((ks * (this.pos.x - rx)) + kd * this.vel.x);
    float ax = fx/m;

    float fy = -((ks * (this.pos.y - ry)) + kd * this.vel.y);
    float ay = fy/m;

    this.vel.x = this.vel.x + ax;
    this.pos.x += this.vel.x;
    this.vel.y = this.vel.y + ay;
    this.pos.y += this.vel.y;
  }

  void display() {
    pushMatrix();
    pushStyle();
    //colorMode(RGB, 255, 255, 255.0);
    //print(alpha(this.c));
    noStroke();
    translate(this.pos.x, this.pos.y);
    rotate(radians(this.rot));
    fill(this.c);
    rect(0, 0, this.w, this.w);
    popStyle();
    popMatrix();
  }

  void setActive(Boolean isActive) {
    if (isActive) {
      this.active = true;
    } else {
      this.active = false;
    }
  }
}
