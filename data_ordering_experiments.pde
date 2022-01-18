import java.util.*;
import java.util.concurrent.ThreadLocalRandom;


int data_length = 500;

int boxSize, small_radius;

char data[] = new char[data_length];  

VecArrayTool vat;


PVector circle_data[] = new PVector[data_length];
PVector rect_data[] = new PVector[data_length];

void setup() {
  size(1200, 800);
  background(0);

  vat = new VecArrayTool();

  PFont f = createFont("Arial", 32);
  textFont(f);
  textSize(8);
  textAlign(CENTER, CENTER);
  for (int i = 0; i < data_length; i++) {
    data[i] = chars[int(random(256))];
  }

  colorMode(HSB, data_length, 1, 1);
  
  noFill();
  stroke(0, 0, 1);
  strokeWeight(1);
  
  background(0);



  draw_rect(0, 0, width / 3, height / 2);
  shuffleArray(rect_data);
  draw_rect_data(width / 3, 0, width / 3, height / 2);
  //shuffleArray(rect_data);
  vat.sort(rect_data, "y");
  draw_rect_data(2 * width / 3, 0, width / 3, height / 2);


  draw_circle(0, height / 2, width / 3, height / 2);
  shuffleArray(circle_data);
  draw_circle_data(width / 3, height / 2, width / 3, height / 2);
  vat.sort(circle_data, "h");
  draw_circle_data(2 * width / 3, height / 2, width / 3, height / 2);

  // saveFrame("image.png");
}

void draw_rect(int _x, int _y, int w, int h) {
  pushMatrix();
  rectMode(CENTER);
  translate(_x,_y);
  noFill();
  int num = 0;
  boxSize = 30;
  
  while(num < data_length) {
    boxSize -= 1;
    num = 0;
    
    for (int y = 0; y < h - boxSize; y += boxSize) {
      for (int x = 0; x < w - boxSize; x += boxSize) {
        num++;
      }
    }
    println("[box] num", num);
  }

  num=0;
  int marginX = (w - (floor(w / boxSize) * boxSize)) / 2;
  int marginY = (h - (floor(h / boxSize) * boxSize)) / 2;

  PVector last_p = new PVector(0, 0);
  for (int y = marginY; y < h - boxSize; y += boxSize) {
    for (int x = marginX; x < w - boxSize; x += boxSize) {
      if (num == data_length) {
        break;
      }
      int px = x + boxSize / 2; 
      int py = y + boxSize / 2; 
      // fill(num, 1, 1);
      if (num != 0) {
        stroke(0, 1, 1);
        line(last_p.x, last_p.y, px, py);
        // stroke(0, 0, 1);
      }
      noStroke();
      rect(px, py, boxSize, boxSize);
      text(Integer.toString(num), px, py);
      last_p = new PVector(px, py);
      rect_data[num] = last_p;
      num++;
    }
  }
  num = 0;
  popMatrix();
}

void draw_circle(int x, int y, int w, int h) {
  pushMatrix();
  ellipseMode(CENTER);
  translate(x + w / 2,y + h / 2);
  // ellipse(0, 0, w-2, h-2);
  
  small_radius = 20;
  int num = 0;
  
  while(num < data_length) {
    small_radius -= 1;
    num = 0;
    int cur_radius = 0;
    while(cur_radius + (small_radius * 2) < h / 2) {
      float circ = (cur_radius + small_radius) * PI * 2;
      int num_circles = floor(circ / (small_radius * 2));
      for (int c = 0; c < num_circles; c++) {
        num++;
        float angle = c * (PI * 2) / num_circles;
        float c_x = sin(angle) * (cur_radius + small_radius);
        float c_y = cos(angle) * (cur_radius + small_radius);
      }
      cur_radius += small_radius * 2;
    }
    println("num", num);
  }
  
  num = 0;
  int cur_radius = 0;
  PVector last_p = new PVector(0, 0);
  while(cur_radius + (small_radius * 2) < h / 2) {
    float circ = (cur_radius + small_radius) * PI * 2;
    int num_circles = floor(circ / (small_radius * 2));
    for (int c = 0; c < num_circles; c++) {
      if (num ==  data_length) {
        break;
      }
      
      float angle = c * (PI * 2) / num_circles;
      float c_x = sin(angle) * (cur_radius + small_radius);
      float c_y = cos(angle) * (cur_radius + small_radius);
      pushMatrix(); 
      // fill(num, 1, 1);
      noStroke();
      println(num, c_x, c_y);
      if (num != 0) {
        stroke(0, 1, 1);
        line(last_p.x, last_p.y, c_x, c_y);
        // stroke(0, 0, 1);
      }
      noStroke();
      ellipse(0, 0, small_radius * 2, small_radius * 2);
      translate(c_x, c_y);
      last_p=new PVector(c_x, c_y);
      circle_data[num] = last_p;
      text(Integer.toString(num), 0, 0);
      popMatrix();
      num++;
    }
    cur_radius += small_radius * 2;
  }
  popMatrix();
}

void shuffleArray(PVector[] ar) {
  // If running on Java 6 or older, use `new Random()` on RHS here
  Random rnd = ThreadLocalRandom.current();
  for (int i = ar.length - 1; i > 0; i--)
  {
    int index = rnd.nextInt(i + 1);
    // Simple swap
    PVector a = ar[index];
    ar[index] = ar[i];
    ar[i] = a;
  }
}


void draw_rect_data(int x, int y, int w, int h) {
  pushMatrix();
  rectMode(CENTER);
  translate(x,y);

  for (int i = 0; i < rect_data.length; i++) {
    PVector p = rect_data[i];
    noStroke();
    rect(p.x, p.y, boxSize, boxSize);
    text(Integer.toString(i), p.x, p.y);
    
    //reading line
    if (i != 0) {
      PVector last_p = rect_data[i-1];
      stroke(0, 1, 1);
      line(p.x, p.y, last_p.x, last_p.y);
    }
  }
  popMatrix();
}


void draw_circle_data(int x, int y, int w, int h) {
  pushMatrix();
  ellipseMode(CENTER);
  translate(x + w / 2,y + h / 2);
  for (int i = 0; i < circle_data.length; i++) {

    println(i, circle_data[i]);
    PVector p = circle_data[i];
    noStroke();
    rect(p.x, p.y, small_radius*2, small_radius*2);
    text(Integer.toString(i), p.x, p.y);
    
    //reading line
    if (i != 0) {
      PVector last_p = circle_data[i-1];
      stroke(0, 1, 1);
      line(p.x, p.y, last_p.x, last_p.y);
    }
  }
  popMatrix();
}




void sortPVectorArray(PVector position, PVector[] positions) {
  for (int i = 0; i < positions.length; i++) { // Loops through positions
    // Make sure i is not 0 as positions[positions.length] is out of bounds
    if (i != positions.length-1) {
      while (PVector.dist(positions[i+1], position) < PVector.dist(positions[i], position)) {
        PVector temp1 = positions[i+1]; // Assign temp variables
        PVector temp2 = positions[i];
        positions[i] = temp1;
        positions[i+1] = temp2; // Swap them around
      }
    }
  }
}