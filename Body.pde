class Body {
    List<Joint> joints;
    List<Spring> springs;
    List<int[]> removeTimers;

    boolean creating = true;

    Body() {
        joints = new CopyOnWriteArrayList();
        springs = new CopyOnWriteArrayList();
        removeTimers = new CopyOnWriteArrayList();
    }

    void update() {
        for(int[] timer : removeTimers) {
            if(millis() > timer[1]) {
                removeJoint(timer[0]);
                removeTimers.remove(timer);
            }
        }

        if(!creating) {
            for(Spring spring : springs) {
                spring.applyForce();
            }

            for(Joint joint : joints) {
                joint.update();
            }
        }
    }

    void draw() {
        drawTriangles();
        drawSprings();
        drawJoints();
        drawCentroid();
    }
    
    void drawTriangles() {
        if(joints.size() > 2) {
            ArrayList<Joint> hull = getConvexHull();
            PVector centroid = getCentroid();
            
            fill(0, 100, 0);
            stroke(255);
            
            for(int i = 0; i < hull.size(); i++) {
                Joint j1 = hull.get(i);
                Joint j2 = hull.get((i + 1) % (hull.size()));
                
                beginShape();
                vertex(centroid.x, centroid.y);
                vertex(j1.position.x, j1.position.y);
                vertex(j2.position.x, j2.position.y);
                endShape(CLOSE);
            }
        }
    }
    
    void drawCentroid() {
        fill(0, 0, 255);
        noStroke();
        
        PVector centroid = getCentroid();
        ellipse(centroid.x, centroid.y, 10, 10);
    }
    
    void drawSprings() {
        for(Spring spring : springs) {
            spring.draw();
        }    
    }
    
    void drawJoints() {
        for(Joint joint : joints) {
            joint.draw();
        }    
    }

    void addJoint(int id, int x, int y) {
        Joint joint = new Joint(id, x, y);

        for(Joint connectJoint : joints) {
            springs.add(new Spring(joint, connectJoint));
        }

        joints.add(joint);
    }

    void addRemoveTimer(int id, int delay) {
        int[] timer = new int[2];

        timer[0] = id;
        timer[1] = millis() + delay;

        removeTimers.add(timer);
    }

    void removeJoint(int id) {
        Joint joint = getJointById(id);

        for(Spring spring : getSpringsByJoint(joint)) {
            springs.remove(spring);
        }

        joints.remove(joint);
    }

    void moveJoint(int id, int x, int y) {
        Joint joint = getJointById(id);

        PVector position = new PVector(x, y);

        PVector velocity = position.get();
        velocity.sub(joint.position);
        velocity.sub(joint.velocity);
        velocity.mult(0.2);
        velocity.add(joint.velocity);

        joint.velocity = velocity;
        joint.position = position;

        for(Spring spring : getSpringsByJoint(joint)) {
            spring.updateRestLength();
        }
    }

    ArrayList<Spring> getSpringsByJoint(Joint joint) {
        ArrayList<Spring> relatedSprings = new ArrayList();

        for(Spring spring : springs) {
            if(spring.hasJoint(joint)) relatedSprings.add(spring);
        }

        return relatedSprings;
    }

    Joint getJointById(int id) {
        Joint match = new Joint(0, 0, 0);

        for(Joint joint : joints) {
            if(joint.id == id) match = joint;
        }

        return match;
    }
    
    PVector getCentroid() {
        PVector centroid = new PVector();
        
        for(Joint joint : joints) {
            centroid.add(joint.position);
        }
        
        centroid.div(joints.size());
        
        return centroid;
    }
    
    ArrayList<Joint> getConvexHull() {
        ArrayList<Joint> hull = new ArrayList();
        
        Joint leftJoint = joints.get(0);
        
        for(Joint joint : joints) {
            if(joint.position.x < leftJoint.position.x) {
                leftJoint = joint;
            }
        }
        
        Joint jointOnHull = leftJoint;
        Joint currentJoint = null;
        
        while(currentJoint != leftJoint) {
            hull.add(jointOnHull);
            currentJoint = joints.get(0);
            
            for(int i = 1; i < joints.size(); i++) {
                Joint joint = joints.get(i);
                
                if(jointOnHull == currentJoint || isLeft(jointOnHull.position, currentJoint.position, joint.position)) {
                    currentJoint = joint;
                }
            }
            
            jointOnHull = currentJoint;
        }
        
        return hull;
    }
    
    boolean isLeft(PVector p1, PVector p2, PVector p) {
        return (p2.x - p1.x) * (p.y - p1.y) - (p.x - p1.x) * (p2.y - p1.y) > 0;
    }

    void applyForce(PVector force) {
        if(creating) return;

        for(Joint joint : joints) {
            joint.applyForce(force);
        }
    }

    void done() {
        creating = false;
        removeTimers.clear();
    }
};
