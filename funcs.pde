color getColor (PVector p) {
  float h = p.y + 9 * p.x / 16;
  float t = map(h, 0, 2880, 0, 1);
  float startRed   = clr1 >> 16 & 0xFF;
  float startGreen = clr1 >> 8  & 0xFF;
  float startBlue  = clr1 >> 0  & 0xFF;
  float endRed   = clr2 >> 16 & 0xFF;
  float endGreen = clr2 >> 8  & 0xFF;
  float endBlue  = clr2 >> 0  & 0xFF;
  float lerpedRed   = (1 - t) * startRed   + t * endRed;
  float lerpedGreen = (1 - t) * startGreen + t * endGreen;
  float lerpedBlue  = (1 - t) * startBlue  + t * endBlue;
  return color(lerpedRed, lerpedGreen, lerpedBlue);
}

void line (PVector v1, PVector v2) {
  line(v1.x, v1.y, v2.x, v2.y);
}

void vertex (PVector v) {
  vertex(v.x, v.y);
}

PVector lerp (PVector v1, PVector v2, float amount) {
  PVector res = new PVector();
  res.x = lerp(v1.x, v2.x, amount);
  res.y = lerp(v1.y, v2.y, amount);
  return res;
}

int getState (int a, int b, int c, int d) {
  return a * 8 + b * 4 + c * 2 + d * 1;
}

void drawNoise () {
  noStroke();
  for (int i = 0; i < cols; i++) {
    for (int j = 0; j < rows; j++) {
      float x = i * res;
      float y = j * res;
     
      float ulValue = noise(   i    * inc,   j    * inc, zoff) * 2 - 1;
      float urValue = noise((i + 1) * inc,   j    * inc, zoff) * 2 - 1;
      float drValue = noise((i + 1) * inc,(j + 1) * inc, zoff) * 2 - 1;
      float dlValue = noise(   i    * inc,(j + 1) * inc, zoff) * 2 - 1;
      float cValue  = noise( (i+.5) * inc, (j+.5) * inc, zoff) * 2 - 1;
      
      int state = getState(ceil(ulValue), ceil(urValue), ceil(drValue), ceil(dlValue));
                           
      PVector ul = new PVector(   x   ,    y   );
      PVector ur = new PVector(x + res,    y   );
      PVector dr = new PVector(x + res, y + res);
      PVector dl = new PVector(   x   , y + res);
      PVector c  = new PVector(x+res/2, y+res/2);
      
      PVector u = lerp(ul, ur, ulValue / (ulValue - urValue));
      PVector r = lerp(ur, dr, urValue / (urValue - drValue));
      PVector d = lerp(dr, dl, drValue / (drValue - dlValue));
      PVector l = lerp(dl, ul, dlValue / (dlValue - ulValue));
      
      fill(getColor(c));
      
      beginShape();      
      switch (state) {
        case  0: break;
        
        case  1: vertex(d); vertex(dl); vertex(l); break;
        case  2: vertex(r); vertex(dr); vertex(d); break;
        case  4: vertex(u); vertex(ur); vertex(r); break;
        case  8: vertex(l); vertex(ul); vertex(u); break;
        
        case  3: vertex(r); vertex(dr); vertex(dl); vertex(l); break;
        case  6: vertex(u); vertex(ur); vertex(dr); vertex(d); break;
        case  9: vertex(d); vertex(dl); vertex(ul); vertex(u); break;
        case 12: vertex(l); vertex(ul); vertex(ur); vertex(r); break;
        
        case  7: vertex(u); vertex(ur); vertex(dr); vertex(dl); vertex(l); break;
        case 11: vertex(r); vertex(dr); vertex(dl); vertex(ul); vertex(u); break;
        case 13: vertex(d); vertex(dl); vertex(ul); vertex(ur); vertex(r); break;
        case 14: vertex(l); vertex(ul); vertex(ur); vertex(dr); vertex(d); break;
          
        case  5: vertex(u); vertex(ur); vertex(r); vertex(d); vertex(dl); vertex(l);
          if (ceil(cValue) <= 0) { 
            beginContour();
              vertex(u); vertex(l); vertex(d); vertex(r); 
            endContour(); 
          }
          break;
        case 10: vertex(r); vertex(dr); vertex(d); vertex(l); vertex(ul); vertex(u);
          if (ceil(cValue) <= 0) { 
            beginContour();
              vertex(u); vertex(l); vertex(d); vertex(r); 
            endContour(); 
          }
          break;
          
        case 15: vertex(ul); vertex(ur); vertex(dr); vertex(dl); break;
      }
      endShape(CLOSE);
    }
  }
}

void drawText () {
  noStroke();
  //String time = nf(hour(),2) + ":" + nf(minute(),2) + ":" + nf(second(),2);
  String time = nf(hour(),2) + ":" + nf(minute(),2);
  
  fill(255); 
  textFont(jetbrains);
  textAlign(CENTER, CENTER);
  text(time, width / 2, height / 2);
  
  fill(255, 127); 
  textFont(cascadia);
  textAlign(LEFT, TOP);
  text((int) frameRate, 0, 0);
}
