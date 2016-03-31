/*
A beautiful, complicated tree. Closer scrutiny reveals Potatoes which are growing on the tree as apples. A sack of Potatoes
dressed as Isaac Newton sits at the foot of the tree. One of two Potato twins dangles precariously for a moment, detatches from
its branch and, on a tiny rocket, embarks on a journey through the universe at the speed of light. All other Potatoes sprout eyes
and wither on the tree or within the Isaac Newton suit, many detatching, following a natural curve through space and
plonking onto the 'head' of Sir Newton. The tree grows thicker and taller, and eventually dies, its bark falling off, inundated
by woodpeckers and termites. The Potato version of Isaac Newton now lies in a grave at the foot of the tree. Just then, the
rocket returns, entering onto the scene from the opposite side as that from which it exited, suggesting that the universe is in some
way globular. The Potato on the little rocket is still fresh and plump as if only a few days have passed. It seeks its withered
twin among decay and regrowth.


*/

ArrayList<Plant> roots;

boolean record = true;
float virtscale = 2;

Plant tree;
Plant bonusLeaves;
float sWidth = 1600;
float sHeight = 1200;

float targetFrameRate;
float maxTreeGrowth = 0.85;
float trunkScale = 0.5;
float leafScale = 0.75;
float leafWither = 1;

PImage potato;
PImage nebula;
PImage flower;
ArrayList<PImage>  leafImages;
float breeze = 0.35;
float flash = -255;

boolean growFlag = false;
boolean zoomFlag = false;
boolean witherFlag = false;
boolean tipFlag = false;
float vidmax;
float vidpos = 0;

void setup() {

  size((int) (sWidth / virtscale), 250);
  
  
  colorMode(HSB, 255);
  if (record) {
    frameRate(24);
    targetFrameRate = 24.0;

  } else {
    frameRate(15);
    targetFrameRate = 15.0;

  }

  //frame.removeNotify();
  //frame.setUndecorated(true);
    
  background(0);


  leafImages = new ArrayList<PImage>();
  leafImages.add(loadImage("leaf1.png")); 
  leafImages.add(loadImage("leaf2.png")); 
  leafImages.add(loadImage("leaf3.png")); 
  flower = loadImage("flower1.png");
  nebula = loadImage("nebula.jpg");
  potato = loadImage("potato1.png");
  
  treeGrowthRate = 10.2;
  
  roots = new ArrayList<Plant>();
  
  randomSeed(662);
  tree = new Plant(new PVector(sWidth/3,sHeight-500), 0.40, 1 * PI, 3, 328, 0.35,7.1, 0.88, 0);
  bonusLeaves = new Plant(new PVector(sWidth/3,sHeight), 0.40, PI, 1, 128, 0.35, 5.1, 0.85, 0);  
  for(int i=0; i<6; i++) {
    Plant p = new Plant(new PVector(sWidth*((i+2.1)/10),sHeight/-2 +500), 1.3, 0, 2, 128, 0.10,10.1, 0.8, 0);
    for(int j = 0; j<5; j++) {
      p.spawnApical();
    }
    roots.add(p);
  }

}

void draw() {
  background(#554433);
 


  pushMatrix();
  scale(width/sWidth);
  if(zoomFlag) {
    translate(sWidth/-2, sHeight/-0.85);
    scale(2.5);
  }
  
  for(int i=0; i<roots.size(); i++) {
    Plant r = roots.get(i);
    r.grow();
    r.draw(false, true);
    r.draw(true, false);
  }
  
  popMatrix();

  if(flash>-250) {
    fill(255, 255-abs(flash));
    noStroke();
    //rect(0,0,width, height);
    flash -= 255/targetFrameRate;
    if(flash > 0) {
      flash -= 100/targetFrameRate;
    }
    println(flash);
  }
  
  if(record && frameCount > 0){
    saveFrame("frames/image-######.tif");
    println(frameCount/24.0);
    println(frameRate);
    
  }
}

void keyPressed() {
  if (key == CODED) {
    if (keyCode == UP) {
    } else if (keyCode == DOWN) {
      
    } 
  } else {
  }
  if(key == 'g') {
    growthBegin();
  }
  
  if(key == 'z') {
    zoomFlag = (zoomFlag) ? false : true;
  }
  
  if(key == 'w') {
    witherFlag = true;
  }
  
  if(key == 't') {
    tipFlag = true;
    breeze = 1;
  }
}



void growthBegin() {
  
    treeGrowthRate = 1.05;
    growFlag =true;
    tree.spawnApical();
    bonusLeaves.spawnApical();
    breeze=50;

    flash = 155;
}
