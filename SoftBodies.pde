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
        Body body = bodies.get(i);

        body.applyForce(gravity);
        body.update();
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
    currentBody = new Body();
    currentBody.addJoint(event.getPointerId(0), int(event.getX(0)), int(event.getY(0)));
    
    bodies.add(currentBody);
  }
  
  if(action == MotionEvent.ACTION_POINTER_DOWN) {
    int index = event.getActionIndex();
    currentBody.addJoint(event.getPointerId(index), int(event.getX(index)), int(event.getY(index)));
  }
  
  if(action == MotionEvent.ACTION_MOVE) {
    for(int i = 0; i < count && i < 8; i++) {
      int id = event.getPointerId(i);
      currentBody.moveJoint(id, int(event.getX(i)), int(event.getY(i)));
    }
  }
  
  if(action == MotionEvent.ACTION_POINTER_UP) {
    currentBody.addRemoveTimer(event.getPointerId(event.getActionIndex()), 200);
  }
  
  if(action == MotionEvent.ACTION_UP && currentBody != null) {
    if(currentBody.joints.size() < 3) {
      bodies.remove(currentBody);
    } else {
      currentBody.done();
    }
    
    currentBody = null;
  }
  
  return super.surfaceTouchEvent(event);
}
