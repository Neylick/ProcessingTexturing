import peasy.*;

PeasyCam cam;

PShape shape;
boolean istyping = false;
final int TGT_RESOLUTION = 1024;
final int SPHERE_SIZE = 1000;

String res_type = "brick"; 


void setup() 
{
	PImage dispmap_img, texture_img, p;
	cam = new PeasyCam(this, 1500);
	size(900,900, P3D);

	texture_img = loadImage("Ressources/"+res_type+"/textimg.jpg");
	dispmap_img = loadImage("Ressources/"+res_type+"/dispimg.jpg");

	if(dispmap_img != null) dispmap_img.resize(TGT_RESOLUTION, TGT_RESOLUTION);
	if(texture_img != null) texture_img.resize(TGT_RESOLUTION, TGT_RESOLUTION);

	shape = sphereFromDispMap(texture_img, dispmap_img);

	// saveShapeDispMap(shape, "testdisp.jpg", TGT_RESOLUTION);
}

void draw() 
{
	background(0);
	// translate(-TGT_RESOLUTION/2., 0, -TGT_RESOLUTION/2.);
	lights();
	shape(shape, 0, 0);
}