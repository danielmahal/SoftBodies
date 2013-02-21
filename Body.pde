class Body {
  ArrayList<SpringJoint> joints;
  ArrayList<Spring> springs;
  ArrayList<int[]> removeTimers;
  boolean creating = true;

  Body() {
    joints = new ArrayList();
    springs = new ArrayList();
    removeTimers = new ArrayList();
  }
  
  void update() { 
    for(int[] timer : removeTimers) {
      if(millis() > timer[1]) {
        removeJoint(timer[0]);
        removeTimers.remove(timer);
      }
    }
    
    if(!creating) {
      for(Spring spring : springs) {
        spring.applyForce();
      }
      
      for(SpringJoint joint : joints) {
        joint.update();
      }
    }
  }

  void draw() {
    for(Spring spring : springs) {
      spring.draw();
    }
    
    for(SpringJoint joint : joints) {
      joint.draw();
    }
  }

  void addJoint(int id, int x, int y) {
    SpringJoint joint = new SpringJoint(id, x, y);
    
    for(SpringJoint connectJoint : joints) {
      springs.add(new Spring(joint, connectJoint));
    }
    
    joints.add(joint);
  }
  
  void addRemoveTimer(int id, int delay) {
    int[] timer = new int[2];
    
    timer[0] = id;
    timer[1] = millis() + delay;
    
    removeTimers.add(timer);
  }

  void removeJoint(int id) {
    SpringJoint joint = getJointById(id);
    
    for(Spring spring : getSpringsByJoint(joint)) {
      springs.remove(spring);
    }
    
    joints.remove(joint);
  }

  void moveJoint(int id, int x, int y) {
    SpringJoint joint = getJointById(id);
    
    joint.velocity = new PVector(x - joint.position.x, y - joint.position.y);
    joint.position.x = x;
    joint.position.y = y;
    
    for(Spring spring : getSpringsByJoint(joint)) {
      spring.updateRestLength();
    }
  }
  
  ArrayList<Spring> getSpringsByJoint(SpringJoint joint) {
    ArrayList<Spring> relatedSprings = new ArrayList();
    
    for(Spring spring : springs) {
      if(spring.hasJoint(joint)) relatedSprings.add(spring);
    }
    
    return relatedSprings;
  }

  SpringJoint getJointById(int id) {
    SpringJoint match = new SpringJoint(0, 0, 0);
  
    for(SpringJoint joint : joints) {
      if(joint.id == id) match = joint;
    }

    return match;
  }

  void applyForce(PVector force) {
    if(creating) return;
    
    for(SpringJoint joint : joints) {
      joint.applyForce(force);
    }
  }

  void done() {
    creating = false;
    removeTimers.clear();
  }
};
