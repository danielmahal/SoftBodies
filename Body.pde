class Body {
  List<Joint> joints;
  List<Spring> springs;
  List<int[]> removeTimers;
  boolean creating = true;

  Body() {
    joints = new CopyOnWriteArrayList();
    springs = new CopyOnWriteArrayList();
    removeTimers = new CopyOnWriteArrayList();
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

      for(Joint joint : joints) {
        joint.update();
      }
    }
  }

  void draw() {
    for(Spring spring : springs) {
      spring.draw();
    }

    for(Joint joint : joints) {
      joint.draw();
    }
  }

  void addJoint(int id, int x, int y) {
    Joint joint = new Joint(id, x, y);

    for(Joint connectJoint : joints) {
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
    Joint joint = getJointById(id);

    for(Spring spring : getSpringsByJoint(joint)) {
      springs.remove(spring);
    }

    joints.remove(joint);
  }

  void moveJoint(int id, int x, int y) {
    Joint joint = getJointById(id);

    joint.velocity = new PVector(x - joint.position.x, y - joint.position.y);
    joint.position.x = x;
    joint.position.y = y;

    for(Spring spring : getSpringsByJoint(joint)) {
      spring.updateRestLength();
    }
  }

  ArrayList<Spring> getSpringsByJoint(Joint joint) {
    ArrayList<Spring> relatedSprings = new ArrayList();

    for(Spring spring : springs) {
      if(spring.hasJoint(joint)) relatedSprings.add(spring);
    }

    return relatedSprings;
  }

  Joint getJointById(int id) {
    Joint match = new Joint(0, 0, 0);

    for(Joint joint : joints) {
      if(joint.id == id) match = joint;
    }

    return match;
  }

  void applyForce(PVector force) {
    if(creating) return;

    for(Joint joint : joints) {
      joint.applyForce(force);
    }
  }

  void done() {
    creating = false;
    removeTimers.clear();
  }
};
