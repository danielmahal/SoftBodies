class Spring {
  SpringJoint[] joints;

  float restLength;
  float strength = 0.8;

  Spring(SpringJoint j1, SpringJoint j2) {
    joints = new SpringJoint[2];

    joints[0] = j1;
    joints[1] = j2;

    restLength = joints[0].position.dist(joints[1].position);
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
    stroke(255, 200);
    line(joints[0].position.x, joints[0].position.y, joints[1].position.x, joints[1].position.y);
  }
};
