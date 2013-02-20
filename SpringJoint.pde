class SpringJoint {
    PVector position;
    PVector velocity = new PVector(random(-1, 1), random(-1, 1));

    float bounce = 0.5;

    SpringJoint(PVector pos) {
        position = pos;
    }

    SpringJoint(int x, int y) {
        position = new PVector(x, y);
    }

    void update() {
        velocity.y += 0.05;

        velocity.mult(0.99);

        position.add(velocity);

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

    void draw() {
        noStroke();
        ellipse(position.x, position.y, 10, 10);
    }
};
