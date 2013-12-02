import processing.opengl.*;

Holofilter H;

void setup() {
  size(627, 627, OPENGL);

  imageMode(CENTER);

  H = new Holofilter(15, 22 , 4 );
  background(0);
}

void draw() {
  background(0);
  
  float r  =  map( mouseX, 0, width, -11, 11 );
  float z  =  map( mouseY, 0, width, -1000, 400 );

  translate(width/2, height/2, z);

  rotateY(radians(r));  


  H.math();
  H.render();
}

class Holofilter {

  PGraphics pg;

  PImage[] img = new PImage[2] ;
  PImage maskImg;

  float w;
  float shift;
  float max_shift;
  int number_of_lines;
  float angle;
  float deviation;

  float fade;


  Holofilter( float w, float max_shift, float deviation) {
    pg = createGraphics(627, 627, P2D);
    maskImg = loadImage("mask.jpg");

    pg.imageMode(CENTER);

    img[0] = loadImage("tornado.png");
    img[1] = loadImage("turtle.png");

    this.w = w;
    this.max_shift = abs(max_shift);
    number_of_lines = round(width/w);
    this.deviation = deviation;
  }

  void math() {
    shift =  map( mouseX, 0, width, -1 * ( H.max_shift/2), H.max_shift/2 );
    fade  =  map(mouseX, 0, width, 0, 255) ;
  }

  void render() {
    image(img[0], 0, 0);
    pg.beginDraw();
    pg.background(0);

    pg.pushStyle();
    pg.fill(155, 155, 155, 50);
    //pg.noStroke();
    for ( int x = 0; x < number_of_lines ; x++ ) {
      pg.rect( ( w * x ) + shift, 0, w+deviation, height);
    }
    pg.popStyle();

    pg.tint(255, 255 - fade - 60 );
    pg.image( img[0], width/2, height/2 );
    pg.tint(255, fade - 60);
    pg.image( img[1], width/2, height/2 );

    pg.endDraw();

    pg.mask(maskImg);
    image(pg, 0, 0);
  }
}

