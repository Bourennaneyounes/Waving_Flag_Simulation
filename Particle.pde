class Particle {
  PVector position;
  PVector velocity;
  PVector acceleration;
  float mass;
  boolean locked = false;

  Particle(float x, float y, float z) {
    position = new PVector(x, y, z);
    velocity = new PVector(0, 0, 0);
    acceleration = new PVector(0, 0, 0);
    mass = 1.0;
  }

  void applyForce(PVector force) {
    if (!locked) {
      acceleration.add(force);
    }
  }

  void update() {
    if (!locked) {
      velocity.add(acceleration);
      velocity.mult(damping);
      position.add(velocity);
      acceleration.mult(0);
    }
  }

  void display() {
    point(position.x, position.y, position.z);
  }
}
