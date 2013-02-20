import android.view.MotionEvent;

ArrayList<Body> bodies;
Body currentBody;

final PVector gravity = new PVector(0, 1);

void setup() {
  size(displayWidth, displayHeight, OPENGL);
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

Body getLastBody() {
  return bodies.get(bodies.size() - 1);
}

public boolean surfaceTouchEvent(MotionEvent event) {
  int action = event.getActionMasked();
  int count = event.getPointerCount();

  if(action == MotionEvent.ACTION_DOWN) {
    Body body = new Body();
    body.addJoint(0, int(event.getX(0)), int(event.getY(0)));
    bodies.add(body);
  }

  if(action == MotionEvent.ACTION_POINTER_DOWN) {
    int index = event.getActionIndex();
    int id = event.getPointerId(index);
    getLastBody().addJoint(id, int(event.getX(index)), int(event.getY(index)));
  }

  if(action == MotionEvent.ACTION_MOVE) {
    for(int i = 0; i < count && i < 8; i++) {
      int id = event.getPointerId(i);
      Body b = getLastBody();

      SpringJoint joint = b.getJointById(id);
      joint.position.x = event.getX(i);
      joint.position.y = event.getY(i);
    }
  }

  if(action == MotionEvent.ACTION_UP) {
    getLastBody().done();
  }

  return super.surfaceTouchEvent(event);
}
