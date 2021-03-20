import peasy.*;

PeasyCam cam;

PShape test_shape;
PImage dispmap_img, texture_img, p;
boolean istyping = false;

final int MAX_RESOLUTION = 1024;

String res_type = "cobble"; 


void setup() 
{
	cam = new PeasyCam(this, 1500);
	size(900,900, P3D);

	texture_img = loadImage("Ressources/"+res_type+"/textimg.jpg");
	dispmap_img = loadImage("Ressources/"+res_type+"/dispimg.jpg");
	// dispmap_img = loadImage("testdisp.jpg");

	if(dispmap_img.width != dispmap_img.height) System.exit(1);

	test_shape = shapeFromDispMap(texture_img, dispmap_img);
	saveShapeDispMap(test_shape, "testdisp.jpg", dispmap_img.width);
}

void draw() 
{
	background(0);
	if(dispmap_img != null) translate(-dispmap_img.width/2, 0, -dispmap_img.height/2);
	shape(test_shape, 0, 0);
}