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

	//Height computations
	int h[][] = new int[ceil(i_dispmap.width)][ceil(i_dispmap.height)];
	for(int x = 0; x < i_dispmap.width; ++x)
		for(int y = 0; y < i_dispmap.height; ++y)
			h[x][y] = (int) -brightness(i_dispmap.pixels[floor(x+y*i_dispmap.width)]);

	resShape.colorMode(HSB);

	resShape.beginShape(QUADS);
		resShape.noStroke();
		//Choosing texture
		if(i_texture != null)
			resShape.texture(i_texture);

		resShape.textureMode(IMAGE);
		for(int x = 0; x < i_dispmap.width-1; ++x)
		{
			for(int y = 0; y < i_dispmap.height-1; ++y)
			{
				if(i_texture == null) 
				{
					int c = (int) map(x+y,0,i_dispmap.width+i_dispmap.height-1, 0, 255);
					resShape.fill(c,255,255);
				}
				//normal();
				resShape.vertex(
					x, 
					h[x][y], 
					y,
					x,y //Texture
					);
				//normal();
				resShape.vertex(
					(x+1), 
					h[x+1][y], 
					y,
					(x+1),y //Texture
					);
				//normal();
				resShape.vertex(
					(x+1), 
					h[x+1][y+1], 
					(y+1),
					(x+1),(y+1) //Texture
					);
				//normal();
				resShape.vertex(					
					x, 
					h[x][y+1], 
					(y+1),
					x,(y+1) //Texture
					); 
			}
		}
	resShape.endShape();

	return resShape;
}

void saveShapeDispMap(PShape s, String filename, int s_size)
{
	colorMode(HSB);

	PImage i_dispmap = createImage(s_size, s_size, HSB);

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

PShape sphereFromDispMap(PImage i_texture, PImage i_dispmap)
{
	PShape resShape = createShape();

	if(i_dispmap == null) 
	{
		print("No file found, aborting..");
		return resShape;
	}

	//Loading the images' pixels
	i_dispmap.loadPixels();

	//Height computations
	int h[][] = new int[ceil(i_dispmap.width)][ceil(i_dispmap.height)];
	for(int x = 0; x < i_dispmap.width; ++x)
		for(int y = 0; y < i_dispmap.height; ++y)
			h[x][y] = (int) -brightness(i_dispmap.pixels[floor(x+y*i_dispmap.width)]);

	resShape.colorMode(HSB);

	resShape.beginShape(QUADS);
		resShape.noStroke();
		//Choosing texture
		if(i_texture != null)
			resShape.texture(i_texture);

		resShape.textureMode(IMAGE);
		for(int x = 0; x < i_dispmap.width-1; ++x)
		{
			for(int y = 0; y < i_dispmap.height-1; ++y)
			{
				if(i_texture == null) 
				{
					int c = (int) map(x+y,0,i_dispmap.width+i_dispmap.height-1, 0, 255);
					resShape.fill(c,255,255);
				}
				//normal(); //later		
				resShape.vertex(
					(SPHERE_SIZE-h[x][y])*cos(PI*x/(float)i_dispmap.width)*sin(PI*y/(float)i_dispmap.height), 
					(SPHERE_SIZE-h[x][y])*sin(PI*x/(float)i_dispmap.width)*sin(PI*y/(float)i_dispmap.height), 
					(SPHERE_SIZE-h[x][y])*cos(PI*y/(float)i_dispmap.height),
					x,y //Texture
					);
				//normal(); //later
				resShape.vertex(
					(SPHERE_SIZE-h[x+1][y])*cos(PI*(x+1)/(float)i_dispmap.width)*sin(PI*y/(float)i_dispmap.height), 
					(SPHERE_SIZE-h[x+1][y])*sin(PI*(x+1)/(float)i_dispmap.width)*sin(PI*y/(float)i_dispmap.height), 
					(SPHERE_SIZE-h[x+1][y])*cos(PI*y/(float)i_dispmap.height),
					(x+1),y //Texture
					);
				//normal(); //later
				resShape.vertex(
					(SPHERE_SIZE-h[x+1][y+1])*cos(PI*(x+1)/(float)i_dispmap.width)*sin(PI*(y+1)/(float)i_dispmap.height), 
					(SPHERE_SIZE-h[x+1][y+1])*sin(PI*(x+1)/(float)i_dispmap.width)*sin(PI*(y+1)/(float)i_dispmap.height), 
					(SPHERE_SIZE-h[x+1][y+1])*cos(PI*(y+1)/(float)i_dispmap.height),
					(x+1),(y+1) //Texture
					);
				//normal(); //later
				resShape.vertex(					
					(SPHERE_SIZE-h[x][y+1])*cos(PI*x/(float)i_dispmap.width)*sin(PI*(y+1)/(float)i_dispmap.height), 
					(SPHERE_SIZE-h[x][y+1])*sin(PI*x/(float)i_dispmap.width)*sin(PI*(y+1)/(float)i_dispmap.height), 
					(SPHERE_SIZE-h[x][y+1])*cos(PI*(y+1)/(float)i_dispmap.height),
					x,(y+1) //Texture
					); 
			}
		}
	resShape.endShape();

	return resShape;
}