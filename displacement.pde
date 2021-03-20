PShape shapeFromDispMap(PImage i_texture, PImage i_dispmap)
{
	PShape resShape = createShape();

	if(i_dispmap == null) 
	{
		print("No file found, aborting..");
		return resShape;
	}

	//Loading the images' pixels
	i_dispmap.loadPixels();

	int SCALE = ceil(min(i_dispmap.width, i_dispmap.height)/(float)MAX_RESOLUTION);

	//Height computations
	int h[][] = new int[ceil(i_dispmap.width/(float)SCALE)][ceil(i_dispmap.height/(float)SCALE)];
	for(int x = 0; x < i_dispmap.width/(float)SCALE; ++x)
		for(int y = 0; y < i_dispmap.height/(float)SCALE; ++y)
			h[x][y] = (int) -brightness(i_dispmap.pixels[SCALE*floor(x+y*i_dispmap.width)]);


	resShape.beginShape(QUADS);
		//Choosing texture
		if(i_texture != null)
		{
			resShape.noStroke();
			resShape.texture(i_texture);
		}
		else
		{
			resShape.noFill();
			resShape.stroke(255);
		}

		resShape.textureMode(IMAGE);
		for(int x = 0; x < i_dispmap.width/(float)SCALE -1; ++x)
		{
			for(int y = 0; y < i_dispmap.height/(float)SCALE -1; ++y)
			{
				resShape.vertex(
					SCALE*x, 
					h[x][y], 
					SCALE*y,
					SCALE*x,SCALE*y //Texture
					);
				resShape.vertex(
					SCALE*(x+1), 
					h[x+1][y], 
					SCALE*y,
					SCALE*(x+1),SCALE*y //Texture
					); 
				resShape.vertex(
					SCALE*(x+1), 
					h[x+1][y+1], 
					SCALE*(y+1),
					SCALE*(x+1),SCALE*(y+1) //Texture
					);
				resShape.vertex(
					SCALE*x, 
					h[x][y+1], 
					SCALE*(y+1),
					SCALE*x,SCALE*(y+1) //Texture
					); 
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