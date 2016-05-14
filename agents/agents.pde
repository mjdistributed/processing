// TODO: Don't render agents, render world. States can hold agents. 


import java.util.Map;
import java.util.HashMap;

Agent[] agents;
State[] world;
int numAgents = 1;  
final int MAX_WIDTH = 600;
final int MAX_HEIGHT = 400;

void setup() {
  size(600, 400);
  stroke(255);
  fill(255);
  
  print("initializing...");
  
  // initialize world
  int worldIndex = 0;
  world = new State[MAX_WIDTH * MAX_HEIGHT];
  for(int x = 0; x < MAX_WIDTH; x++) {
    for (int y = 0; y < MAX_HEIGHT; y++) {
        world[worldIndex++] = new State(new Point(x, y));
    }
  }
  
  // initialize agents
  agents = new Agent[numAgents];
  for (int i = 0; i < numAgents; i++) {
    Policy startingPolicy = generateRandomPolicy();
    agents[i] = new Agent(world[0], startingPolicy); 
  }
  println("...done");
}

void draw() {
  background(0);
  for (Agent agent : agents) { 
    agent.act();
    agent.render();
  }
}

Policy generateRandomPolicy() {
  Map<State, Action> policy = new HashMap<State, Action>();
   for (State state : world) {
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
     policy.put(state, randomAction);
   }
   return new Policy(policy);
}

class Agent {
   Policy policy;
   State state;
    
    public Agent(State startState, Policy policy) {
      this.policy = policy;
      this.state = startState;
    }
    
    public void render() {
      rect(state.getLocation().x, state.getLocation().y, 5, 5);
    }
    
    public void act() {
      Point location = state.getLocation();
      switch (policy.getAction(state)) {
        case UP: {
          if (location.y < MAX_HEIGHT) {
            setLocation(state, location.x, location.y + 1);
          }
          break;
        }
        case DOWN: {
          if (location.y > 0) { 
            setLocation(state, location.x, location.y - 1);
          }
          break;
        }
        case LEFT: {
          if (location.x > 0) {
             setLocation(state, location.x - 1, location.y);
          }
         break;
        }
        case RIGHT: {
          if (location.x < MAX_WIDTH) {
            setLocation(state, location.x + 1, location.y);
          }
          break;
        }
      }
    }
    
    private void setLocation(State state, int x, int y) {
       state.setLocation(new Point(x, y)); 
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
  
  public State(Point loc) {
    this.location = loc;
  }
  
  public Point getLocation() {
     return location; 
  }
  
  public void setLocation(Point loc) {
    this.location = loc;
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