class Spring {
    SpringJoint joint1;
    SpringJoint joint2;

    float targetDistance;
    float stiffness = 0.5;
    float damping = 0.01;

    Spring(SpringJoint j1, SpringJoint j2) {
        joint1 = j1;
        joint2 = j2;
        targetDistance = joint1.position.dist(joint2.position);
    }

    void update() {
        float distance = joint2.position.dist(joint1.position);
        float force = (targetDistance - distance) * stiffness * damping;

        PVector j1v = new PVector(joint1.position.x, joint1.position.y);
        j1v.sub(joint2.position);
        j1v.normalize();
        j1v.mult(force);

        joint1.velocity.add(j1v);
        joint1.position.add(joint1.velocity);

        PVector j2v = new PVector(joint2.position.x, joint2.position.y);
        j2v.sub(joint1.position);
        j2v.normalize();
        j2v.mult(force);

        joint2.velocity.add(j2v);
        joint2.position.add(joint2.velocity);
    }

    void draw() {
        stroke(255, 100);
        line(joint1.position.x, joint1.position.y, joint2.position.x, joint2.position.y);
    }
};
