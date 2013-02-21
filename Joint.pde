class Joint {
  int id;
  PVector position;
  PVector acceleration;
  PVector velocity;

  final float mass = 10.0;
  final float bounce = 0.0;
  final float damp = 0.98;
  final float friction = 0.4;

  Joint(int pId, int x, int y) {
    id = pId;
    position = new PVector(x, y);
    acceleration = new PVector(0, 0);
    velocity = new PVector(0, 0);
  }

  void update() {
    velocity.add(acceleration);

    if(collideWall()) velocity.mult(friction);

    velocity.mult(damp);
    position.add(velocity);
    acceleration.mult(0);
  }

  boolean collideWall() {
    boolean colliding = false;

    if(position.x < 0) {
      colliding = true;
      position.x = 0;
      velocity.x *= -bounce;
    }

    if(position.x > width) {
      colliding = true;
      position.x = width;
      velocity.x *= -bounce;
    }

    if(position.y < 0) {
      colliding = true;
      position.y = 0;
      velocity.y *= -bounce;
    }

    if(position.y > height) {
      colliding = true;
      position.y = height;
      velocity.y *= -bounce;
    }

    return colliding;
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
