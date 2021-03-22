import peasy.*;

PeasyCam cam;

PShape shape;
boolean istyping = false;
final int TGT_RESOLUTION = 1024;
final int SPHERE_SIZE = 1000;

String res_type = "brick"; 


void setup() 
{
	PImage dispmap_img, texture_img, normmap_img;
	cam = new PeasyCam(this, 1500);

	size(900,900, P3D);
	// fullScreen(P3D);
	smooth(8);

	texture_img = loadImage("Ressources/"+res_type+"/textimg.jpg");
	dispmap_img = loadImage("Ressources/"+res_type+"/dispimg.jpg");
	normmap_img = loadImage("Ressources/"+res_type+"/normimg.jpg");

	dispmap_img.resize(TGT_RESOLUTION, TGT_RESOLUTION);
	texture_img.resize(TGT_RESOLUTION, TGT_RESOLUTION);
	normmap_img.resize(TGT_RESOLUTION, TGT_RESOLUTION);

	shape = shapeFromDispMap(texture_img, dispmap_img, null);

	saveShapeNormMap(shape, "testnorm.jpg", TGT_RESOLUTION);
}

void draw() 
{
	background(0);
	translate(-TGT_RESOLUTION/2., 0, -TGT_RESOLUTION/2.);

	ambientLight(0x40, 0x40, 0x60, 0, 10, 0);
  directionalLight(0xC0, 0xC0, 0xA0, 0, 1, 0);
  lightFalloff(1, 0, 0);
  lightSpecular(0, 0, 0);

	shape(shape, 0, 0);
}