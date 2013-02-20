ArrayList<SpringShape> springs;

void setup() {
    size(600, 400);
    springs = new ArrayList();

    springs.add(new SpringShape());
}

void draw() {
    background(0);

    for(int i = 0; i < springs.size(); i++) {
        SpringShape spring = springs.get(i);
        spring.update();
        spring.draw();
    }
}

SpringShape getLastSpring() {
    return springs.get(springs.size() - 1);
}

void mousePressed() {
    getLastSpring().addJoint(mouseX, mouseY);
}

void keyPressed() {
    if(key == ' ') {
        getLastSpring().done();
        springs.add(new SpringShape());
    }

    if(key == 'c') {
        springs.clear();
        springs.add(new SpringShape());
    }
}
