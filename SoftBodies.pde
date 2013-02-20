ArrayList<Body> bodies;

final PVector gravity = new PVector(0, 1);

void setup() {
    size(600, 400, OPENGL);
    frameRate(60.0);

    bodies = new ArrayList();
    bodies.add(new Body());
}

void update() {
    for(int i = 0; i < bodies.size(); i++) {
        Body spring = bodies.get(i);

        spring.applyForce(gravity);
        spring.update();
    }
}

void draw() {
    update();

    background(0);

    for(int i = 0; i < bodies.size(); i++) {
        bodies.get(i).draw();
    }
}

Body getLastSpring() {
    return bodies.get(bodies.size() - 1);
}

void mousePressed() {
    getLastSpring().addJoint(mouseX, mouseY);
}

void keyPressed() {
    if(key == ' ') {
        getLastSpring().done();
        bodies.add(new Body());
    }

    if(key == 'c') {
        bodies.clear();
        bodies.add(new Body());
    }
}
