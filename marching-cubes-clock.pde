import yash.oklab.*; 

float res = 20;
int cols, rows;
float inc = 0.02 * (res / 20);
float zoff = 0;
color clr1 = #e7305e, clr2 = #4D09BC;
PFont jetbrains, cascadia;

void setup(){
  fullScreen();
  noCursor();
  Ok.p = this;
  
  cols = 1 + (int)(width / res);
  rows = 1 + (int)(height / res);
  
  jetbrains = createFont("JetBrainsMono-ExtraBold.ttf", 288);
  cascadia = createFont("CascadiaCode.ttf", 36);
}

void draw(){
  fill(0, 85);
  rect(0, 0, width, height);
  //background(0);
  
  drawNoise();
  drawText();
  
  zoff += 0.004 * (30 / frameRate);
}
