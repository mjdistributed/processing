
import java.util.List;


List<Branch> branches; 
private final static int NUM_STARTING_BRANCHES = 1;
private final static int MAX_BRANCHINGS = 4;
private final int AVEERAGE_SPLIT_TIME = 100; // average # of growth times before splitting
private final float BRANCH_NARROWING_RATE = 0.7; // rate at which later branches are narrower than their parents


void setup() {
  size(800, 800);
  fill(0,0,0);
  //background(0);
  branches = new ArrayList();
  for (int i = 0; i < NUM_STARTING_BRANCHES; i++) {
    Point startPoint = new Point(width / 3 + (int)random(width / 3), height);
      branches.add(new Branch(startPoint, 180, 1, 0));
  }
  
}

void draw() {
  //background(0);
  for (int i = 0; i < branches.size(); i++) {
    branches.get(i).grow();
  }
}


class Branch {
 private int theta; // an angle between 0 & 360 degrees inticating direction of growth
 private int age;
 private int growthRate;
 private Point startPoint;
 private Point endPoint;
 private final int maxBranchAngleDelta = 80; 
 private final int branchNum; // how many branches from og branch this is
 
 public Branch(Point startPoint, int theta, int growthRate, int branchNum) {
   this.age = 0;
   this.startPoint = startPoint;
   this.theta = theta;
   this.growthRate = growthRate;
   this.branchNum = branchNum;
 }
 
 private void grow() {
   age ++;
   float radians = radians(theta);
   double nextY = age * growthRate * cos(radians) + startPoint.y;
   double nextX = age * growthRate * sin(radians) + startPoint.x;
   if (nextX > width || nextX < 0 || nextY > height || nextY < 0) {
     die();
     return;
   }
   endPoint = new Point((int) nextX, (int) nextY);
   rect(endPoint.x, endPoint.y, 5 - branchNum * BRANCH_NARROWING_RATE, 5 - branchNum * BRANCH_NARROWING_RATE); 
   if ((int)random(AVEERAGE_SPLIT_TIME + 1) == AVEERAGE_SPLIT_TIME) {
     branch();
   }
 }
 
 private void branch() {
   if (branchNum < MAX_BRANCHINGS) {
     int nextTheta = 135 + ((int)random(maxBranchAngleDelta)) % 360;
     
     branches.add(new Branch(new Point(endPoint.x, endPoint.y), nextTheta, growthRate, branchNum + 1));
   }
 }
 
 private void die() {
   branches.remove(this);
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