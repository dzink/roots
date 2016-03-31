float treeGrowthRate = 103.2;
static float leafColorChange = 1.5;
int branches = 0;

class Leaf {
  PVector pos;
  color col;
  float rotate;
  int t;
  
  Leaf(PVector _pos, color _col) {
    col = _col;
    pos = _pos;
    rotate = 0;
    t = (int) random(3);
  }

  void draw() {
    if(leafWither>0) {
      fill(col);
      noStroke();
      //pushMatrix();
      translate(pos.x, pos.y);
      rotate = (rotate + (breeze * 5.0/targetFrameRate) * random(0.4, 0.7)) % TWO_PI;
      
      float r = 0.4 * sin(rotate-1);
      tint(lerpColor(#884488, col, leafWither), 255);
  
      //for (float i = -0.25; i <= 0.25; i+= 0.25) {
        int i = 0;
        PImage leaf = leafImages.get(t);
        pushMatrix();
        rotate(PI * i + r);
        scale(2 * leafScale * leafWither, 2 * leafScale);
  
        //ellipse(0, 40, 35, 80);
        image(leaf,-leaf.width/2,0);
        popMatrix();
      //}
      //popMatrix();
    }
  }
}

class Potato {
  float size;
  float rotation;
  float maxSize;
  float pulseSpeed;
  float pulse;
  
  Potato() {
    rotation = random(TWO_PI);
    maxSize = random(1);
    pulseSpeed = random(0.8,1.4);
    pulse = random(2.0);
    size = maxSize;
  }
  
  void draw() {
    pulse = (pulse + pulseSpeed/targetFrameRate) % 2;
    if (size < maxSize) {
      size += 0.1/targetFrameRate;
    }
    pushMatrix();
    rotate(rotation);
    scale(size*map(sin(pulse*PI), -1, 1, 6.8, 8.2)) ;
    tint(10 + 250*leafWither,255);
    fill(255);
    stroke(0);
    strokeWeight(1);
    ellipse(0,0,10,15);
    noFill();
    popMatrix();
  }
}

class Branch
{
  PMatrix2D joint;
  ArrayList<Branch> children;
  int branches;
  float growth;
  float weight;
  float angle;
  float curve;
  float shrink;
  float len;
  float mutate;
  color col;
  public float apicalCount;
  Potato potato;

  
  CurveControl curveControl_start;
  CurveControl curveControl_end;
  CurveControl end;
  
  int leaves;
  ArrayList<Leaf> leafChildren;
  
  Branch(int _branches, float _weight, float _angle, float _curve, float _shrink, float _mutate)
  {
    joint = new PMatrix2D();
    children = new ArrayList<Branch>();
    leafChildren = new ArrayList<Leaf>();
    if (random(1.0)<0.1) {
      potato = new Potato();
    }
    
    growth = 0.850;
    branches = _branches;
    weight = _weight;
    angle = _angle;
    mutate = _mutate;
    curve = _curve;//pow(_curve * weight, 0.5);
    //println(curve);
    shrink = _shrink;
    curveControl_end = new CurveControl(curve * random(-sHeight/3, sHeight/3), len * -sHeight/6, 90, 1 / sqrt(weight));
    curveControl_start = new CurveControl(curve * random(-sHeight/3, sHeight/3), len * -sHeight/6, 140, 1 / sqrt(weight));
    end = new CurveControl(curve * random(-sHeight/3, sHeight/3), len * -sHeight/6, 100, 3);
    col = color(randomizeColor(20,1.1), randomizeColor(80,1.4), randomizeColor(20 + 0.012 * weight,1.1));
    len = sqrt(random(0.5,2));
    spawnLeaves(1);
    apicalCount = 0;
  }
  
  
  
  void spawnLeaves(int n) {
    for(int i = 0; i<n; i++) {
      //PVector 
      //leafChildren.add(new Leaf(new PVector(0, len * sHeight/3), color(randomizeColor(150, leafColorChange), randomizeColor(200, leafColorChange), randomizeColor(150, leafColorChange), 220)));
    } 
  }
  
  void spawnApical()
  {
    if(children.size() == 0) {
      branch(branches, true, weight);
    } else {
      for(int i=children.size()-1; i>=0; i--) {
        children.get(i).spawnApical();
      }
      if(random(5.0) < mutate) {
        branch(1, false, sqrt(weight)); 
      }
    }
          apicalCount++;

  }

  void branch(int b, boolean straight, float w)
  {
    for(int i = 0; i< b; i++) {
      spawnChild(b, 1, w * ((i+1.0)/4.0));
    }
    if(straight) {
      spawnChild(b, 0, w);
    }
  }
  
  void spawnChild(int b, float _angle, float _weight) {
    if(weight > 0.8) {
      Branch child = new Branch(b, pow(shrink, 3) * _weight, angle, curve, shrink, mutate);
      child.joint.translate(0,len * sHeight/3);
      child.joint.rotate(_angle * random(PI * -angle,PI * angle));
      child.joint.scale(shrink);
      children.add(child);
    } 
  }
  
  
  
  void draw() {
    draw(true, true);
  }
  
  void draw(boolean drawLeaves, boolean drawBranches) {
    pushMatrix();
    applyMatrix(joint);
    drawBranch(drawLeaves, drawBranches);
    popMatrix();
  }
  
  void grow() {
    if (growth < maxTreeGrowth) {
      growth += 0.02 * treeGrowthRate / targetFrameRate;
    }  
    for(int i=children.size()-1; i>=0; i--) {
      children.get(i).grow();
    }
  }
  
  void tip(float direction) {
    if (angle > -0.5 * PI) {
      float tipAmount = direction * TWO_PI / targetFrameRate;
      angle -= tipAmount;
      joint.rotate(tipAmount);
    }  
    for(int i=children.size()-1; i>=0; i--) {
      children.get(i).tip(-direction);
    }
  }
  
  void drawBranch(boolean drawLeaves, boolean drawBranches)
  {    
    if((weight<30 && witherFlag || tipFlag)  && growth > 0) {
      growth -= ((tipFlag) ? 0.03 : 0.1)/targetFrameRate;
    }
    scale(growth);
    
    // scale for growth & weight
    if(drawBranches) {    
      float w = trunkScale*weight/virtscale;
      if (w>0) {
        stroke(0, 255);
    
        strokeWeight(8+trunkScale * (weight*1.1)/virtscale);
        
        // draw a curve or a line
        curve(curveControl_start.x(), curveControl_start.y(), 0,0, 0,len * sHeight/3, curveControl_end.x(), curveControl_end.y());
        
        //stroke(#443366, 255);
        stroke(255);
        strokeWeight(6+trunkScale*weight/virtscale);
        curve(curveControl_start.x(), curveControl_start.y(), 0,0, 0,len * sHeight/3, curveControl_end.x(), curveControl_end.y());
        
        curveControl_start.increment();
        curveControl_end.increment(); 
        //line(0,sHeight/3, 0,0);
      }
    }  
    
    // draw child branches
    for(int i=children.size()-1; i>=0; i--) {
      pushMatrix();
      children.get(i).draw(drawLeaves, drawBranches);
      popMatrix();
    }
  
    if(drawLeaves) {  
      pushStyle();
      pushMatrix();
      translate(0, 1- len);
      scale(1.0/growth);
      // draw leaves - remove this to its own thing
      for(int i = leafChildren.size()-1; i>=0; i--) {
        Leaf leaf = leafChildren.get(i);
        leaf.draw();
        
        //ellipse(0, leaf.y, 15,15);
      }
      if (potato != null) {
        potato.draw();
      }
      popMatrix();
      popStyle();
    }

  }
  
  // get the realworld x-y coordinate along the branch
  void getXY(float n) {
    
  }
}


class Plant extends Branch {
  PVector location;
  float rotation;
  float size;
  
  Plant(PVector _location, float _size, float _rotation, int _branches, float _weight, float _angle, float _curve, float _shrink, float _mutate) {
    super(_branches, _weight, _angle, _curve, _shrink, _mutate);
    location = _location; 
    //joint.scale(0.5, 0.5);   
    
    //joint.scale(_size * 2, _size * 2);
    joint.translate(_location.x, _location.y);
    joint.rotate(_rotation);    
    joint.scale(_size);
  }
  
  void spawnLeaves(int n) {
    //in this simulation plants do not sprout leaves on their main trunk 
  }
  
  
  
  void draw(boolean drawLeaves, boolean drawBranches) {
    pushMatrix();
    applyMatrix(joint);
    noFill();
    //ellipse(0,0,100,100);
    drawBranch(drawLeaves, drawBranches);
    popMatrix();
    
  }
  
  
}

float randomizeColor(float n, float delta) {
  //println(pow(2.0, random(1.0/leafColorChange, leafColorChange) - 1));
  return n * pow(2.0, random(1.0/delta, delta)- 1);
}

class CurveControl {
  public float x;
  public float y;
  public float wiggle;
  public float speed;
  
  float wx;
  float wy;
  
  CurveControl(float _x, float _y, float _w, float _s) {
    x = _x;
    y = _y;
    wiggle = _w;
    speed = _s;
    wx = 0;
    wy = 0;
  }
  
  void increment() {
    wx += pow(2, breeze*random(-2.0, 2.0)) * 1.0 * speed/targetFrameRate;
    wy += pow(2, breeze*random(-2.0, 2.0)) * 1.0 * speed/targetFrameRate;
    wx = wx % 2;
    wy = wy % 2; 
  }
  
  float x() {
    return x + (wiggle * sin(wx * PI)); 
  }
  
  float y() {
    return y + (wiggle * sin(wy * PI)); 
  }
}
