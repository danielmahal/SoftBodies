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

  void draw() {
    for(int i = 0; i < springs.size(); i++) {
      springs.get(i).draw();
    }
    
    for(int i = 0; i < joints.size(); i++) {
      joints.get(i).draw();
    }
  }

  void addJoint(int id, int x, int y) {
    joints.add(new SpringJoint(id, x, y));
  }
  
  void addRemoveTimer(int id, int delay) {
    int[] timer = new int[2];
    
    timer[0] = id;
    timer[1] = millis() + delay;
    
    removeTimers.add(timer);
  }

  void removeJoint(int id) {
    joints.remove(getJointById(id));
  }

  void moveJoint(int id, int x, int y) {
    SpringJoint joint = getJointById(id);

    joint.velocity = new PVector(x - joint.position.x, y - joint.position.y);
    joint.position.x = x;
    joint.position.y = y;
  }

  SpringJoint getJointById(int id) {
    SpringJoint match = new SpringJoint(0, 0, 0);

    for(int i = 0; i < joints.size(); i++) {
    SpringJoint joint = joints.get(i);
    if(joint.id == id) match = joint;
    }

    return match;
  }

  void update() {
    for(int i = 0; i < removeTimers.size(); i++) {
      int[] timer = removeTimers.get(i);
      
      if(millis() > timer[1]) {
        removeJoint(timer[0]);
        removeTimers.remove(i);
      }
    }
    
    if(!creating) {
      for(int i = 0; i < springs.size(); i++) {
        springs.get(i).applyForce();
      }
  
      for(int i = 0; i < joints.size(); i++) {
        joints.get(i).update();
      }
    }
  }

  void applyForce(PVector force) {
    if(creating) return;

    for(int i = 0; i < joints.size(); i++) {
      joints.get(i).applyForce(force);
    }
  }

  void done() {
    creating = false;
    
    removeTimers.clear();

    for(int i = 0; i < joints.size(); i++) {
      SpringJoint j1 = joints.get(i);

      for(int j = i+1; j < joints.size(); j++) {
        SpringJoint j2 = joints.get(j);
        float distance = sqrt(pow(j2.position.x - j1.position.x, 2) + pow(j2.position.y - j1.position.y, 2));

        Spring spring = new Spring(j1, j2);

        springs.add(spring);
      }
    }
  }
};
