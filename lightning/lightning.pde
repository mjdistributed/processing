
Curve[] curves;
int numBolts = 3;  
int maxSpeed = 1; // maximum speed of curve growth, in pixels per iteration

void setup() {
  size(600, 400);
  stroke(255);
  fill(255);
  
  // initialize lightning bolts
  curves = new Curve[numBolts];
  for (int i = 0; i < numBolts; i++) {
    int speed = (int)random(maxSpeed + 1);
    int xDisplacement = (i + 1) * width/(numBolts + 1);
    curves[i] = new Curve(xDisplacement, maxSpeed); 
  }
}

void draw() {
  background(0);
  for (Curve curve : curves) { 
    curve.grow();
    curve.render();
  }
}

int getRandomMaxLength() {
  return (int)random(height / 4.0, height / 2.0);
}

int getRandomMinLength() {
  return (int)random(height / 4.0);
}

class Curve {
  float amplitude = 20.0;  // width of wave
  float period = 100.0;  // How many pixels before the wave repeats
  int topLength = 0; // length of top half of the wave, in pixels
  int bottomLength = 0; // length of bottom half of the wave, in pixels
  int speed = 1; // rate at which curve grows, in pixels per iteration 
  int dTop = 1; // directionality of top of curve growth, should always be in {-1, 1}
  int dBottom = 1; // directionality of bottom of curve growth, should always be in {-1, 1}
  float maxTopLength;
  float maxBottomLength;
  float minTopLength;
  float minBottomLength;
  Point[] points;
    
  public Curve(int xDisplacement, int speed) {
    this.points = new Point[height];
    this.maxTopLength = getRandomMaxLength();
    this.minTopLength = getRandomMinLength();
    this.topLength = (int)minTopLength;
    this.maxBottomLength = getRandomMaxLength();
    this.minBottomLength = getRandomMinLength();
    this.bottomLength = (int)minBottomLength;
    this.speed = speed;
    obtainCurve(xDisplacement);
  }
  
  public void grow() {
    updateTopLength();
    updateBottomLength();
  }
  
  public void render() {
    for (int y = height/2 - topLength; y < height/2 + bottomLength - 1; y ++) {
      int index = max(0, min(y, height - 1));
      point(points[index].x, points[index].y);
    }
  }
  
  private void updateTopLength() {
    topLength += dTop * speed;
    if (topLength >= maxTopLength && dTop > 0 || topLength < minTopLength && dTop < 0) {
      if (topLength >= maxTopLength) {
        maxTopLength = getRandomMaxLength();
        dTop = -1;
      }
      if (topLength < minTopLength) {
        minTopLength = getRandomMinLength();
        dTop = 1;
      }
      //dTop *= -1;
      //topLength += dTop * speed; 
    }
  }
  
  private void updateBottomLength() {
    bottomLength += dBottom * speed;
    if (bottomLength >= maxBottomLength && dBottom > 0 || bottomLength < minBottomLength && dBottom < 0) {
      if (bottomLength >= maxBottomLength) {
        maxBottomLength = getRandomMaxLength(); 
        dBottom = -1;
      }
      if (bottomLength < minBottomLength) {
        minBottomLength = getRandomMinLength();
        dBottom = 1;
      }
      //dBottom *= -1;
      //bottomLength += dBottom * speed;
    }
  }
  
  void obtainCurve(int xDisplacement) {
    float theta = 0;
    float dTheta = (TWO_PI / period);  // Value for incrementing theta, a function of period and xspacing
    for (int y = 0; y < height; y ++) {
       int xVal = (int) (sin(theta) * amplitude);
       points[y] = new Point(xVal + xDisplacement, y);
       theta += dTheta;
    }
  }
}

class Point {
  int x;
  int y;
  
  public Point(int x, int y) {
    this.x = x;
    this.y = y;
  }
}