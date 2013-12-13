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
    p.draw();
  }
  drawPos();
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

float minX, maxX; // store the bounding box of all points
float minY, maxY;
int minPopulation, maxPopulation;
int minDensity, maxDensity;
int numPoints; // total number of places seen

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

  void draw() {
    color black = color(0);
    stroke(#000000);
    fill(#1100AA);
    if(this.w == 1){
      set(int(x), int(y), black);
    }else{
      ellipse(int(this.x),int(this.y), this.w, this.w);
    }

  }
}

void drawPos(){
  fill(#000000);
  textSize(10);
  text("x:"+mouseX+",y:"+mouseY, 20, 20);
}
