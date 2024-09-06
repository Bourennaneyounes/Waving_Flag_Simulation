int cols = 30;
int rows = 40;
float springLength = 20;
float gravity = 0.2;
float damping = 0.98;
float K = 0.1;
float defaultWindStrength = 0.1;
float windStrength = defaultWindStrength;
PImage flag;
Particle[][] particles;

float cameraDistance = 1500;
float cameraXRotation = 0;
float cameraYRotation = 0;
boolean leftMouseClicked = false;
boolean applyWind = false;

void setup() {
  size(1000, 600, P3D);
  flag = loadImage("algerie.jpg");
  particles = new Particle[cols][rows];

  for (int i = 0; i < cols; i++) {
    for (int j = 0; j < rows; j++) {
      float x = i * springLength;
      float y = j * springLength;
      float z = random(-1, 1)* springLength;
      particles[i][j] = new Particle(x, y, z);
    }
  }

  for (int j = 0; j < rows; j++) {
    particles[0][j].locked = true;
  }

  particles[1][0].locked = false;
}

void draw() {
  background(255);
  updateCamera();
  translate(width / 2, 0, -cameraDistance);
  rotateX(cameraXRotation);
  rotateY(cameraYRotation);

  drawReferencePlane();

  for (int i = 0; i < 2; i++) {
    simulate();
  }
textureMode(NORMAL);
 for (int j = 0; j < rows-1; j++) 
 {
    beginShape(TRIANGLE_STRIP);
    texture(flag);
    for (int i = 0; i < cols-1; i++) {
    
      float u = map(i, 0, cols, 0, 1);
      float v = map(j, 0, rows, 0, 1);
      vertex(particles[i][j].position.x, particles[i][j].position.y,  particles[i][j].position.z, u, v);
      vertex (particles[i][j+1].position.x, particles[i][j+1].position.y , particles[i][j+1].position.z, u, v);
    }
    endShape(CLOSE);
  }
  render();
}

void updateCamera() {
  if (mouseButton == LEFT) {
    if (mousePressed) {
      float sensitivity = 0.005;
      cameraYRotation -= (pmouseX - mouseX) * sensitivity;
      cameraXRotation += (pmouseY - mouseY) * sensitivity;
    }
  }
}

void simulate() {
  for (int i = 0; i < cols; i++) {
    for (int j = 0; j < rows; j++) {
      if ( i > 0) {
        PVector windForce = new PVector(windStrength, 0, random(-windStrength*2,windStrength*2));
        particles[i][j].applyForce(windForce);
      }

      particles[i][j].applyForce(createGravityForce(particles[i][j].mass));
      particles[i][j].update();
    }
  }

  for (int i = 0; i < 5; i++) {
    for (int j = 0; j < cols - 1; j++) {
      for (int k = 0; k < rows; k++) {
        applySpringForces(particles[j][k], particles[j + 1][k]);
      }
    }
  }

  for (int i = 0; i < cols - 1; i++) {
    for (int j = 0; j < rows - 1; j++) {
      applySpringForces(particles[i][j], particles[i + 1][j + 1]);
      applySpringForces(particles[i + 1][j], particles[i][j + 1]);
    }
  }
}

void applySpringForces(Particle p1, Particle p2) {
  PVector force = new PVector(p2.position.x - p1.position.x, p2.position.y - p1.position.y, p2.position.z - p1.position.z);
  float distance = force.mag();
  float displacement = distance - springLength;
  force.normalize();
  force.mult(K * displacement);

  p1.applyForce(force);
  p2.applyForce(force.copy().mult(-1));
}

PVector createGravityForce(float mass) {
  return new PVector(0, mass * gravity, 0);
}

void keyPressed() {
  if (key == 'f' || key == 'F') {
    applyWind = !applyWind;
    if (applyWind) {
      windStrength = 0.5;
    } else {
      windStrength = 0.0;
    }
  }
}

void render() {
  stroke(2);
  strokeWeight(2);
  beginShape(POINTS);
  for (int i = 0; i < cols; i++) {
    for (int j = 0; j < rows; j++) {
      particles[i][j].display();
    }
  }
  endShape();
  //stroke(2);
  noStroke();
  strokeWeight(1);
  beginShape(LINES);
  for (int i = 0; i < cols - 1; i++) {
    for (int j = 0; j < rows; j++) {
      vertex(particles[i][j].position.x, particles[i][j].position.y, particles[i][j].position.z);
      vertex(particles[i + 1][j].position.x, particles[i + 1][j].position.y, particles[i + 1][j].position.z);
    }
  }

  for (int i = 0; i < cols - 1; i++) {
    for (int j = 0; j < rows - 1; j++) {
      vertex(particles[i][j].position.x, particles[i][j].position.y, particles[i][j].position.z);
      vertex(particles[i + 1][j + 1].position.x, particles[i + 1][j + 1].position.y, particles[i + 1][j + 1].position.z);

      vertex(particles[i + 1][j].position.x, particles[i + 1][j].position.y, particles[i + 1][j].position.z);
      vertex(particles[i][j + 1].position.x, particles[i][j + 1].position.y, particles[i][j + 1].position.z);
    }
  }
  endShape();
}

void drawReferencePlane() {
  fill(200);
  noStroke();
  float planeSize = 1000;
  float planeY = 3000;
  beginShape();
  vertex(-planeSize, planeY, planeSize);
  vertex(planeSize, planeY, planeSize);
  vertex(planeSize, planeY, -planeSize);
  vertex(-planeSize, planeY, -planeSize);
  endShape(CLOSE);
}
