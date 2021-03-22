PShape shapeFromDispMap(PImage i_texture, PImage i_dispmap, PImage i_normmap)
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
	float h[][] = new float[i_dispmap.width][i_dispmap.height];
	for(int x = 0; x < i_dispmap.width; ++x)
		for(int y = 0; y < i_dispmap.height; ++y)
			h[x][y] = -(255./i_dispmap.width)*brightness(i_dispmap.pixels[x+y*i_dispmap.width]);

	//Normal computations
	PVector n[][] = new PVector[i_dispmap.width][i_dispmap.height];
	if(i_normmap != null)
	{
		for(int x = 0; x < i_normmap.width; ++x)
			for(int y = 0; y < i_normmap.height; ++y)
			{
				color c = i_normmap.pixels[x+y*i_normmap.width];
				n[x][y] = new PVector(
					red(c),
					green(c),
					blue(c)
					);
			}
	}
	else //Temporary test, not final.
	{
		for(int x = 0; x < i_dispmap.width-1; ++x)
			for(int y = 0; y < i_dispmap.height-1; ++y)
				n[x][y] = n[x+1][y] = n[x][y+1] = n[x+1][y+1] = compute_normal(1, -1, h[x+1][y]-h[x][y+1], 1, 1, h[x+1][y+1]-h[x][y]);
	}

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
				resShape.normal(n[x][y].x, n[x][y].y, n[x][y].z);
				resShape.vertex(
					x, 
					h[x][y], 
					y,
					x,y //Texture
					);

				resShape.normal(n[x][y+1].x, n[x][y+1].y, n[x][y+1].z);
				resShape.vertex(					
					x, 
					h[x][y+1], 
					(y+1),
					x,(y+1) //Texture
					); 

				resShape.normal(n[x+1][y+1].x, n[x+1][y+1].y, n[x+1][y+1].z);
				resShape.vertex(
					(x+1), 
					h[x+1][y+1], 
					(y+1),
					(x+1),(y+1) //Texture
					);

				resShape.normal(n[x+1][y].x, n[x+1][y].y, n[x+1][y].z);
				resShape.vertex(
					(x+1), 
					h[x+1][y], 
					y,
					(x+1),y //Texture
					);				
			}
		}
	resShape.endShape();

	return resShape;
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
					(SPHERE_SIZE-h[x][y])*cos(TWO_PI*x/(float)(i_dispmap.width-1))*sin(PI*y/(float)(i_dispmap.height-1)), 
					(SPHERE_SIZE-h[x][y])*sin(TWO_PI*x/(float)(i_dispmap.width-1))*sin(PI*y/(float)(i_dispmap.height-1)), 
					(SPHERE_SIZE-h[x][y])*cos(PI*y/(float)(i_dispmap.height-1)),
					x,y //Texture
					);
				//normal(); //later
				resShape.vertex(
					(SPHERE_SIZE-h[x+1][y])*cos(TWO_PI*(x+1)/(float)(i_dispmap.width-1))*sin(PI*y/(float)(i_dispmap.height-1)), 
					(SPHERE_SIZE-h[x+1][y])*sin(TWO_PI*(x+1)/(float)(i_dispmap.width-1))*sin(PI*y/(float)(i_dispmap.height-1)), 
					(SPHERE_SIZE-h[x+1][y])*cos(PI*y/(float)(i_dispmap.height-1)),
					(x+1),y //Texture
					);
				//normal(); //later
				resShape.vertex(
					(SPHERE_SIZE-h[x+1][y+1])*cos(TWO_PI*(x+1)/(float)(i_dispmap.width-1))*sin(PI*(y+1)/(float)(i_dispmap.height-1)), 
					(SPHERE_SIZE-h[x+1][y+1])*sin(TWO_PI*(x+1)/(float)(i_dispmap.width-1))*sin(PI*(y+1)/(float)(i_dispmap.height-1)), 
					(SPHERE_SIZE-h[x+1][y+1])*cos(PI*(y+1)/(float)(i_dispmap.height-1)),
					(x+1),(y+1) //Texture
					);
				//normal(); //later
				resShape.vertex(					
					(SPHERE_SIZE-h[x][y+1])*cos(TWO_PI*x/(float)(i_dispmap.width-1))*sin(PI*(y+1)/(float)(i_dispmap.height-1)), 
					(SPHERE_SIZE-h[x][y+1])*sin(TWO_PI*x/(float)(i_dispmap.width-1))*sin(PI*(y+1)/(float)(i_dispmap.height-1)), 
					(SPHERE_SIZE-h[x][y+1])*cos(PI*(y+1)/(float)(i_dispmap.height-1)),
					x,(y+1) //Texture
					); 
			}
		}
	resShape.endShape();

	return resShape;
}


//The "save" functions only work for a plane shape, trying to use them with another kind of shape will raise an OutOfBound exception.
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

void saveShapeNormMap(PShape s, String filename, int s_size)
{
	colorMode(RGB);

	PImage i_dispmap = createImage(s_size, s_size, RGB);

	i_dispmap.loadPixels();
		for(int pos = 0; pos < s.getVertexCount(); ++pos)
		{
			PVector position = s.getVertex(pos);
			PVector normal = s.getNormal(pos);

			int p_coord = floor(position.x + position.z*s_size);
			color p_color = color(
				abs(normal.x), 
				abs(normal.y), 
				abs(normal.z)
				);

			if(i_dispmap.pixels[p_coord] == color(255,255,255)) i_dispmap.pixels[p_coord] = p_color;//Applying color
			else i_dispmap.pixels[p_coord] = lerpColor(p_color, i_dispmap.pixels[p_coord], 0.5); //Mixing with previous color
		}
	i_dispmap.updatePixels();
	i_dispmap.save(filename);
}