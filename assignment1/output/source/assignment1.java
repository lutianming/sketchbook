import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class assignment1 extends PApplet {

public void setup() {
  size(800, 800);
  readData();
  //labelFont = loadFont("/* font filename from above */");
  //textFont(labelFont, 32);
}

public void draw() {
  background(255);
  int black = color(0);
  for (int i = 0; i < numPoints; ++i) {
    Place p = places[i];
    p.draw();
  }
  drawPos();
}

Place places[];
public void readData() {
  String[] lines = loadStrings("http://www.telecom-paristech.fr/~eagan/class/as2013/inf229/data/population.tsv");
  parseInfo(lines[0]);

  places = new Place[numPoints];
  for (int i = 0; i < numPoints; ++i) {
    String pieces[] = split(lines[i+2], '\t');
    int postalCode = PApplet.parseInt(pieces[0]);
    float x = PApplet.parseFloat(pieces[1]);
    float y = PApplet.parseFloat(pieces[2]);
    x = map(x, minX, maxX, 0, 800);
    y = 800 - map(y, minY, maxY, 0, 800);
    String name = pieces[4];
    int population = PApplet.parseInt(pieces[5]);
    int density = PApplet.parseInt(pieces[6]);
    places[i] = new Place(postalCode, name, x, y, population, density);
  }
}

float minX, maxX; // store the bounding box of all points
float minY, maxY;
int minPopulation, maxPopulation;
int minDensity, maxDensity;
int numPoints; // total number of places seen

public void parseInfo(String line) { // Parse one line
  String infoString = line.substring(2); // remove the #
  String[] pieces = split(infoString, ',');
  numPoints = PApplet.parseInt(pieces[0]);
  minX = PApplet.parseFloat(pieces[1]);
  maxX = PApplet.parseFloat(pieces[2]);
  minY = PApplet.parseFloat(pieces[3]);
  maxY = PApplet.parseFloat(pieces[4]);
  minPopulation = PApplet.parseInt(pieces[5]);
  maxPopulation = PApplet.parseInt(pieces[6]);
  minDensity = PApplet.parseInt(pieces[7]);
  maxDensity = PApplet.parseInt(pieces[8]);
}

class Place {
  int postalCode;
  String name;
  float x;
  float y;
  float population;
  float density;
  private int w;

  Place(int postalCode, String name, float x, float y,
        float population, float density){
    this.postalCode = postalCode;
    this.name = name;
    this.x = x;
    this.y = y;
    this.population = population;
    this.density = density;
    if (this.population < 20000) {
      //still not a city
      this.w = 1;
    }
    else if(this.population < 100000){
      //city
      this.w = 5;
    }
    else if(this.population < 1000000){
      //big city
      this.w = 10;
    } else{
      //super big city
      this.w = 20;
    }
  }

  public void draw() {
    int black = color(0);
    stroke(0xff000000);
    fill(0xff1100AA);
    if(this.w == 1){
      set(PApplet.parseInt(x), PApplet.parseInt(y), black);
    }else{
      ellipse(PApplet.parseInt(this.x),PApplet.parseInt(this.y), this.w, this.w);
    }

  }
}

public void drawPos(){
  fill(0xff000000);
  textSize(10);
  text("x:"+mouseX+",y:"+mouseY, 20, 20);
}
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "assignment1" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
