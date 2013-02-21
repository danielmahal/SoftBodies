class Spring {
  SpringJoint[] joints;

  float restLength;
  float strength;
  
//  final float minStrength = 0.2;
//  final float maxStrength = 1.0; 

  Spring(SpringJoint j1, SpringJoint j2) {
    joints = new SpringJoint[2];

    joints[0] = j1;
    joints[1] = j2;
    
    updateRestLength();
  }
  
  void updateRestLength() {
    restLength = joints[0].position.dist(joints[1].position);
    updateStrength();
  }
  
  void updateStrength() {
    strength = min(max(500-restLength, 20), 255) / 255;
  }
  
  boolean hasJoint(SpringJoint joint) {
    return joints[0] == joint || joints[1] == joint;
  }

  void applyForce() {
    float currentLength = joints[1].position.dist(joints[0].position);
    float stretch = currentLength - restLength;
    float force = -strength * stretch;

    PVector dir1 = PVector.sub(joints[0].position, joints[1].position);
    PVector dir2 = PVector.sub(joints[1].position, joints[0].position);

    applyForce(joints[0], dir1, force);
    applyForce(joints[1], dir2, force);
  }

  void applyForce(SpringJoint joint, PVector direction, float magnitude) {
    PVector force = direction.get();
    force.normalize();
    force.mult(magnitude);

    joint.applyForce(force);
  }

  void draw() {
    stroke(80, 120, 255, max(100, strength * 255));
    line(joints[0].position.x, joints[0].position.y, joints[1].position.x, joints[1].position.y);
  }
};
