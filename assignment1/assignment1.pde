void setup() {
  size(800, 800);
  readData();
  //labelFont = loadFont("/* font filename from above */");
  //textFont(labelFont, 32);
}

void draw() {
  background(255);
  color black = color(0);
  for (int i = 0; i < numPoints; ++i) {
    Place p = places[i];
    if(p.population >= minPopulationDisplay){
      p.draw();
    }
  }
  drawInfos();
}

Place places[];
void readData() {
  //String[] lines = loadStrings("http://www.telecom-paristech.fr/~eagan/class/as2013/inf229/data/population.tsv");
  String[] lines = loadStrings("population.tsv");
  parseInfo(lines[0]);

  places = new Place[numPoints];
  for (int i = 0; i < numPoints; ++i) {
    String pieces[] = split(lines[i+2], '\t');
    int postalCode = int(pieces[0]);
    float x = float(pieces[1]);
    float y = float(pieces[2]);
    x = map(x, minX, maxX, 0, 800);
    y = 800 - map(y, minY, maxY, 0, 800);
    String name = pieces[4];
    int population = int(pieces[5]);
    int density = int(pieces[6]);
    places[i] = new Place(postalCode, name, x, y, population, density);
  }
}


//Data related variables
float minX, maxX; // store the bounding box of all points
float minY, maxY;
int minPopulation, maxPopulation;
int minDensity, maxDensity;
int numPoints; // total number of places seen
//Display related variable
int minPopulationDisplay = 10000;
Place highlighted_place = null;
Place selected_place = null;

void parseInfo(String line) { // Parse one line
  String infoString = line.substring(2); // remove the #
  String[] pieces = split(infoString, ',');
  numPoints = int(pieces[0]);
  minX = float(pieces[1]);
  maxX = float(pieces[2]);
  minY = float(pieces[3]);
  maxY = float(pieces[4]);
  minPopulation = int(pieces[5]);
  maxPopulation = int(pieces[6]);
  minDensity = int(pieces[7]);
  maxDensity = int(pieces[8]);
}

class Place {
  int postalCode;
  String name;
  float x;
  float y;
  float population;
  float density;

  boolean highlighted;
  boolean selected;
  int w;

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

  boolean contains(int x, int y){
    float dx = this.x - x;
    float dy = this.y - y;
    float d = sqrt(pow(dx, 2) + pow(dy, 2));
    int bonus = 1;
    if(d <= (this.w / 2.0 + bonus)){
      return true;
    }
    else{
      return false;
    }
  }

  void draw() {
    color black = color(0);
    if(this.w == 1){
      set(int(x), int(y), black);
    }else{
      if(this.highlighted == true){
        fill(#FF0000);
      }else{
        fill(#000000);
      }
      ellipse(int(this.x),int(this.y), this.w, this.w);
    }
  }
}

void drawInfos(){
  fill(#000000);
  textSize(10);
  //text("x:"+mouseX+",y:"+mouseY, 20, 20);
  text("Display population about " + minPopulationDisplay, 20, 20);
  Place p = highlighted_place;
  if(p != null){
    noStroke();
    fill(#0000FF, 50);
    float w = textWidth(p.name);
    rect(p.x+p.w/2, p.y+p.w/2, w, -10);
    fill(#000000);
    //    textAlign(RIGHT, TOP);
    text(p.name, p.x+p.w/2, p.y+p.w/2);

  }
}

Place pick(int x, int y){
  for (int i = numPoints-1; i >= 0; i--) {
    Place p = places[i];
    if(p.population < minPopulationDisplay){
      continue;
    }
    if(p.contains(x, y)){
      return p;
    }
  }
  return null;
}

void keyPressed(){
  if(key == CODED){
    if(keyCode == UP){
      if(minPopulationDisplay < 500000){
        minPopulationDisplay = minPopulationDisplay * 2;
      }
    }
    else if(keyCode == DOWN){
      if(minPopulationDisplay >= 2){
        minPopulationDisplay = minPopulationDisplay / 2;
      }
    }
  }
  redraw();
}

void mouseMoved(){
  Place p = pick(mouseX, mouseY);
  if(p == null){
    if(highlighted_place != null){
      highlighted_place.highlighted = false;
    }
    highlighted_place = null;
  }
  else{
    if(highlighted_place == null){
      p.highlighted = true;
      highlighted_place = p;
      //      println("x:"+mouseX+", y:"+mouseY + ", city:" + p.name);
    }else if(p.name != highlighted_place.name){
      p.highlighted = true;
      highlighted_place.highlighted = false;
      highlighted_place = p;
      //      println("x:"+mouseX+", y:"+mouseY + ", city:" + p.name);
    }
  }
}

void mouseClicked(){
  if(mouseButton == LEFT and highlighted_place != null){
    Place p = highlighted_place;
    p.selected = true;
    selected_place = p;
  }
}
