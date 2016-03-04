Curve[] curves;
  
void setup() {
  size(640, 360);
  stroke(255);
  fill(255);
  curves = new Curve[3];
  curves[0] = new Curve(width/2);
  curves[1] = new Curve(width/4);
  curves[2] = new Curve((int)(width * 3.0/4));
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
  int dTop = 1; // rate at which length of top changes, in pixels
  int dBottom = 1; // rate at which length of bottom changes, in pixels
  float maxTopLength;
  float maxBottomLength;
  float minTopLength;
  float minBottomLength;
  Point[] points;
    
  public Curve(int xDisplacement) {
    points = new Point[height];
    maxTopLength = getRandomMaxLength();
    minTopLength = getRandomMinLength();
    topLength = (int)minTopLength;
    maxBottomLength = getRandomMaxLength();
    minBottomLength = getRandomMinLength();
    bottomLength = (int)minBottomLength;
    obtainCurve(xDisplacement);
  }
  
  void grow() {
    updateTopLength();
    updateBottomLength();
  }
  
  void render() {
    for (int y = height/2 - topLength; y < height/2 + bottomLength - 1; y ++) {
      point(points[y].x, points[y].y);
    }
  }
  
  void updateTopLength() {
    topLength += dTop;
    if (topLength >= maxTopLength && dTop > 0 || topLength < minTopLength && dTop < 0) {
      if (topLength >= maxTopLength) {
        maxTopLength = getRandomMaxLength();
      }
      if (topLength < minTopLength) {
        minTopLength = getRandomMinLength();
      }
      dTop *= -1;
      topLength += dTop; 
    }
  }
  
  void updateBottomLength() {
    bottomLength += dBottom;
    if (bottomLength >= maxBottomLength && dBottom > 0 || bottomLength < minBottomLength && dBottom < 0) {
      if (bottomLength >= maxBottomLength) {
        maxBottomLength = getRandomMaxLength(); 
      }
      if (bottomLength < minBottomLength) {
        minBottomLength = getRandomMinLength();
      }
      dBottom *= -1;
      bottomLength += dBottom;
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