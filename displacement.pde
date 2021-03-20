PShape shapeFromDispMap(PImage i_text, PImage i_dispmap)
{
	PShape resShape = createShape();

	if(i_dispmap == null) 
	{
		print("No file found, aborting..");
		return resShape;
	}

	//Loading the images' pixels
	i_dispmap.loadPixels();
	if(i_text != null) i_text.loadPixels();


	int detscale = ceil(min(i_dispmap.width, i_dispmap.height)/(float)MAX_RESOLUTION);

	resShape.beginShape(QUADS);
		resShape.textureMode(IMAGE);
		for(int x = 0; x < i_dispmap.width/(float)detscale -1; ++x)
		{
			for(int y = 0; y < i_dispmap.height/(float)detscale -1; ++y)
			{
				if(i_text != null) //A texture was given for the Shape
				{
					resShape.noStroke();
					resShape.fill(i_text.pixels[detscale*floor(x+y*i_dispmap.width)]);
				}	
				else //No texture
				{
					resShape.noFill();
					resShape.stroke(255);
				}
				resShape.vertex(detscale*x, -brightness(i_dispmap.pixels[detscale*floor(x+y*i_dispmap.width)]), detscale*y);
					//  +----+
					//  |    |
					//  X----+

				resShape.vertex(detscale*(x+1), -brightness(i_dispmap.pixels[detscale*floor((x+1)+y*i_dispmap.width)]), detscale*y); 
					//  X----+
					//  |    |
					//  +----+

				resShape.vertex(detscale*(x+1), -brightness(i_dispmap.pixels[detscale*floor((x+1)+(y+1)*i_dispmap.width)]), detscale*(y+1));
					//  +----X
					//  |    |
					//  +----+

				resShape.vertex(detscale*x, -brightness(i_dispmap.pixels[detscale*floor(x+(y+1)*i_dispmap.width)]), detscale*(y+1)); 
					//  +----+
					//  |    |
					//  +----X
			}
		}
	resShape.endShape();

	return resShape;
}

void saveShapeDispMap(PShape s, String filename, int s_size)
{
	colorMode(HSB);

	PImage i_dispmap = createImage(s_size,s_size,HSB);

	i_dispmap.loadPixels();
		for(int pos = 0; pos < s.getVertexCount(); ++pos)
		{
			PVector position = s.getVertex(pos);

			int p_coord = floor(position.x + position.z*s_size);
			color p_color = color(0, 0, abs(position.y)); //Color with Brightness corresponding to pixel's height.

			if(i_dispmap.pixels[p_coord] == color(255,255,255)) i_dispmap.pixels[p_coord] = p_color;//Applying color
			else i_dispmap.pixels[p_coord] = lerpColor(p_color, i_dispmap.pixels[p_coord], 0.5); //Mixing with previous color
		}
	i_dispmap.updatePixels();
	i_dispmap.save(filename);
}