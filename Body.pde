class Body {
    ArrayList<SpringJoint> joints;
    ArrayList<Spring> springs;
    boolean creating = true;

    Body() {
        joints = new ArrayList();
        springs = new ArrayList();
    }

    void draw() {
        for(int i = 0; i < joints.size(); i++) {
            joints.get(i).draw();
        }

        for(int i = 0; i < springs.size(); i++) {
            springs.get(i).draw();
        }
    }

    void addJoint(int x, int y) {
        joints.add(new SpringJoint(x, y));
    }

    void update() {
        if(creating) return;

        for(int i = 0; i < springs.size(); i++) {
            springs.get(i).applyForce();
        }

        for(int i = 0; i < joints.size(); i++) {
            joints.get(i).update();
        }
    }

    void applyForce(PVector force) {
        if(creating) return;

        for(int i = 0; i < joints.size(); i++) {
            joints.get(i).applyForce(force);
        }
    }

    void done() {
        creating = false;

        for(int i = 0; i < joints.size(); i++) {
            SpringJoint j1 = joints.get(i);

            for(int j = i+1; j < joints.size(); j++) {
                SpringJoint j2 = joints.get(j);
                float distance = sqrt(pow(j2.position.x - j1.position.x, 2) + pow(j2.position.y - j1.position.y, 2));

                Spring spring = new Spring(j1, j2);

                springs.add(spring);
            }
        }
    }
};
