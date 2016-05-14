// TODO: Don't render agents, render world. States can hold agents. 

import java.util.Set;
import java.util.HashSet;
import java.util.Map;
import java.util.HashMap;

Set<Agent> agents;
State[][] world;
final int numAgents = 100;  
final int AGENT_LIFE_LENGTH = 1000;
final int FOOD_RATE = 1; // percent of states starting with food
int day = 0;

void setup() {
  size(400, 400);
  
  print("initializing...");
  
  // initialize world
  world = new State[height][width];
  for(int x = 0; x < width; x++) {
    for (int y = 0; y < height; y++) {
      float percent = random(100);
      boolean hasFood = (percent < FOOD_RATE);
      world[y][x] = new State(new Point(x, y), hasFood);
    }
  }
  
  // initialize agents
  agents = new HashSet<Agent>();
  for (int i = 0; i < numAgents; i++) {
    Policy startingPolicy = generateRandomPolicy();
    int startX = (int)random(height/3, height * 2/3);
    int startY = (int)random(width / 3, width * 2/3);
    agents.add(new Agent(world[startY][startX], startingPolicy)); 
  }
  println("...done");
}

void draw() {
  background(0);
  println("day " + (day++) + ", " + agents.size() + " agents");
  for (Agent agent : new HashSet<Agent>(agents)) { 
    agent.act();
  }
  for (State[] yStates : world) {
    for (State state : yStates) {
      state.render();
    }
  }
}

Policy generateRandomPolicy() {
  Map<State, Action> policy = new HashMap<State, Action>();
   for (int  y = 0; y < height; y++) {
     for (int x = 0; x < width; x++) {
       State currState = world[y][x];
       int randomVal = (int)random(0, 4);
       Action randomAction;
       switch (randomVal) {
          case 0: {
            randomAction = Action.UP;
            break;
          } case 1: {
            randomAction = Action.DOWN;
            break;
          } case 2: {
            randomAction = Action.LEFT;
            break;
          } case 3: {
            randomAction = Action.RIGHT;
            break;
          } default: {
            throw new RuntimeException("Error: unexpected value while generating policy");
          }
       }
       policy.put(currState, randomAction);
     }
   }
   return new Policy(policy);
}

Policy crossPolicies(Policy one, Policy two) {
  Map<State, Action> resultPolicy = new HashMap<State, Action>();
  for (State[] yStates : world) {
    for (State state : yStates) {
      int randomVal = (int)random(0, 2);
      if (randomVal == 0) {
         resultPolicy.put(state, one.getAction(state)); 
      } else {
        resultPolicy.put(state, two.getAction(state));
      }
    }
  }
  return new Policy(resultPolicy);
}

class Agent {
   private Policy policy;
   private State state;
   private int remainingLife;
   private boolean hasEaten;
    
    public Agent(State startState, Policy policy) {
      this.policy = policy;
      this.state = startState;
      this.remainingLife = AGENT_LIFE_LENGTH;
    }
    
    public void act() {
      move();
      eat();
    }
    
    private void eat() {
     if (state.removeFood()) {
       println("eating!!");
      this.hasEaten = true; 
      remainingLife = AGENT_LIFE_LENGTH;
     }
    }
    
    private void move() {
      this.remainingLife--;
      this.state.removeAgent(this);
      if (remainingLife <= 0) {
        agents.remove(this);
        return;
      }
      Point location = state.getLocation();
      switch (policy.getAction(state)) {
        case UP: {
          if (location.y > 0) {
            this.state = world[location.y+1][location.x];
          }
          break;
        }
        case DOWN: {
          if (location.y > height) { 
            this.state = world[location.y - 1][location.x];
          }
          break;
        }
        case LEFT: {
          if (location.x > 0) {
            this.state = world[location.y][location.x - 1];
          }
         break;
        }
        case RIGHT: {
          if (location.x < width) {
            this.state = world[location.y][location.x + 1];
          }
          break;
        }
      }
      this.state.addAgent(this);
    }
    
    public void replicate(Agent otherAgent) {
      if (hasEaten) {
       hasEaten = false; 
      } else {
        // agent must have eaten to replicate
       return; 
      }
      println("replicating!");
      Agent child = new Agent(this.state, crossPolicies(this.getPolicy(), otherAgent.getPolicy()));
      this.state.addAgent(child);
      agents.add(child);
    }
    
    public Policy getPolicy() {
      return this.policy;
    }
}

class Policy {
   Map<State, Action> policy;
   
   public Policy(Map<State, Action> policy) {
     this.policy = policy;
   }
   
   public Action getAction(State state) {
      return policy.get(state); 
   }
}

class State {
  Point location;
  Set<Agent> agents;
  boolean hasFood;
  
  public State(Point loc, boolean hasFood) {
    this.location = loc;
    this.agents = new HashSet<Agent>();
    this.hasFood = hasFood;
  }
  
  public Point getLocation() {
     return location; 
  }
  
  public void setLocation(Point loc) {
    this.location = loc;
  }
  
  public void addAgent(Agent agent) {
    this.agents.add(agent);
  }
  
  public void removeAgent(Agent agent) {
    this.agents.remove(agent);
  }
  
  public boolean removeFood() {
     if (hasFood) {
       hasFood = false;
       return true;
     }
     return false;
  }
  
  public void render() {
    if (!this.agents.isEmpty()) {
      stroke(255);
      fill(255);
      rect(location.x, location.y, 5, 5);
    }
    if (hasFood) {
      stroke(0, 255, 0);
      fill(0, 255, 0);
      rect(location.x, location.y, 1, 1); //<>//
    }
    for (Agent agent : new ArrayList<Agent>(agents)) {
      for (Agent otherAgent : new ArrayList<Agent>(agents)) {
        if (!agent.equals(otherAgent)) {
         agent.replicate(otherAgent); 
        }
      }
    }
  }
  
  public String toString() {
     return "State at: " + location.y + ", " + location.x; 
  }
}

enum Action {
   UP, DOWN, LEFT, RIGHT 
}

class Point {
  int x;
  int y;
  
  public Point(int x, int y) {
    this.x = x;
    this.y = y;
  }
}