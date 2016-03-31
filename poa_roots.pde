ArrayList<Plant> roots;

boolean record = true;
float virtscale = 2;

Plant tree;
Plant bonusLeaves;
float sWidth = 1024;
float sHeight = 768;

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

  size((int) (sWidth / virtscale), (int) (sHeight / virtscale));
  
  
  colorMode(HSB, 255);
  if (record) {
    targetFrameRate = 24.0;
  } else {
    targetFrameRate = 24.0;
  }
  frameRate((int) targetFrameRate);
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
  int plants = 7;
  randomSeed(669);
  tree = new Plant(new PVector(sWidth/3,sHeight-500), 0.40, 1 * PI, 3, 328, 0.35,7.1, 0.88, 0);
  bonusLeaves = new Plant(new PVector(sWidth/3,sHeight), 0.40, PI, 1, 128, 0.35, 5.1, 0.85, 0);  
  for(int i=0; i<plants; i++) {
    Plant p = new Plant(new PVector(map(i, 0, plants - 1, sWidth * 0.1, sWidth * 0.9),sHeight/-2 + random(100, 300)), 0.75, 0, 1, 28, 0.90, 10.1, 0.9, 0.15);
    for(int j = 0; j<9; j++) {
      p.spawnApical();
    }
    roots.add(p);
  }

}

void draw() {
  background(#000000);
 


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
