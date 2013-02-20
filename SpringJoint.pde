class SpringJoint {
    int id;
    PVector position;
    PVector acceleration;
    PVector velocity;
    
    final float mass = 10.0;
    final float bounce = 0.5;
    final float damp = 0.98;

    SpringJoint(int pId, int x, int y) {
        id = pId;
        position = new PVector(x, y);
        acceleration = new PVector(0, 0);
        velocity = new PVector(0, 0);
    }

    void update() {
        velocity.add(acceleration);
        velocity.mult(damp);
        position.add(velocity);
        acceleration.mult(0);

        if(position.x < 0) {
            position.x = 0;
            velocity.x *= -bounce;
        }

        if(position.x > width) {
            position.x = width;
            velocity.x *= -bounce;
        }

        if(position.y < 0) {
            position.y = 0;
            velocity.y *= -bounce;
        }

        if(position.y > height) {
            position.y = height;
            velocity.y *= -bounce;
        }
    }

    void applyForce(PVector force) {
        PVector f = force.get();
        f.div(mass);
        acceleration.add(f);
    }

    void draw() {
        noStroke();
        ellipse(position.x, position.y, 10, 10);
    }
};
