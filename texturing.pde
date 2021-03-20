import peasy.*;

PeasyCam cam;

PShape shape;
boolean istyping = false;
final int TGT_RESOLUTION = 1024;

String res_type = "wall"; 


void setup() 
{
	PImage dispmap_img, texture_img, p;
	cam = new PeasyCam(this, 1500);
	size(900,900, P3D);

	texture_img = loadImage("Ressources/"+res_type+"/textimg.jpg");
	dispmap_img = loadImage("Ressources/"+res_type+"/dispimg.jpg");
	// dispmap_img = loadImage("testdisp.jpg");

	if(dispmap_img.width != dispmap_img.height) System.exit(1);

	shape = shapeFromDispMap(texture_img, dispmap_img);
	// shape = shapeFromDispMap(null, dispmap_img);


	saveShapeDispMap(shape, "testdisp.jpg", TGT_RESOLUTION);
}

void draw() 
{
	background(0);
	translate(-TGT_RESOLUTION/2., 0, -TGT_RESOLUTION/2.);
	lights();
	shape(shape, 0, 0);
}