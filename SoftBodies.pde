import android.view.MotionEvent;
import ketai.sensors.*;
import java.util.List;
import java.util.concurrent.CopyOnWriteArrayList;

List<Body> bodies;
Body currentBody;

KetaiSensor sensor;
PVector accelerometer = new PVector(0, 0, 0);
PVector gravity = new PVector(0, 1);

void setup() {
    size(displayWidth, displayHeight, OPENGL);
    frameRate(60.0);
    orientation(LANDSCAPE);

    sensor = new KetaiSensor(this);
    sensor.start();

    bodies = new CopyOnWriteArrayList();
    bodies.add(new Body());
}

void update() {
    gravity = new PVector(-accelerometer.x, accelerometer.y);
    
    for(Body body : bodies) {
      body.applyForce(gravity);
      body.update();    
    }
}

void draw() {
    update();

    background(0);
    
    for(Body body : bodies) {
      body.draw();
    }
}

Body getLastBody() {
    return bodies.get(bodies.size() - 1);
}

public boolean surfaceTouchEvent(MotionEvent event) {
  int action = event.getActionMasked();
  int count = event.getPointerCount();

  if(action == MotionEvent.ACTION_DOWN) {
    bodies.clear();

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

void onAccelerometerEvent(float x, float y, float z) {
  accelerometer = new PVector(x, y, z);
}
