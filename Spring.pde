class Spring {
    Joint[] joints;

    float restLength;
    float strength;

    final float strengthDistance = 500;
    final float minStrength = 0.3;
    final float maxStrength = 1.0;

    Spring(Joint j1, Joint j2) {
        joints = new Joint[2];

        joints[0] = j1;
        joints[1] = j2;

        updateRestLength();
    }

    void updateRestLength() {
        restLength = joints[0].position.dist(joints[1].position);
        updateStrength();
    }

    void updateStrength() {
        strength = min(max((strengthDistance - restLength) / strengthDistance, minStrength), maxStrength);
    }

    boolean hasJoint(Joint joint) {
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

    void applyForce(Joint joint, PVector direction, float magnitude) {
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
