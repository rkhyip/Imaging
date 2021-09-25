macro "42 <randon point generator> Action Tool - Cg00 O00ff C00g P5464 P94a4 P76778687 P496b9bb9"
{
print("\\Clear");

if(isOpen("ROI Manager")){
	selectWindow("ROI Manager");
	run("Close");
}

//get File info 
//consider doing through bioformats so we don't need to open the file
	getDimensions(width, height, channels, slices, frames);
	w=width;
	h=height;
	c=channels;
	z=slices;
	f=frames;
	
	getVoxelSize(width, height, depth, unit);
	px=width;
	py=height;
	pz=depth;
	un=unit;
//


/*/   For testing
	w = 12000;
	h = 5000; 
	z = 150;
	px = 1;
	py = 1; 
	pz = 1;
	un = "pan galactic gargle blasters";
//*/


//create new image with acquired paramers
	newImage("Particle Array", "8-bit black", w, h, z);
	setVoxelSize(px, py, pz, un);

	spot=getNumber("Point diameter (pixels) must be odd", 5); //why must be odd?
	centre=floor(spot/2);
	r = round(spot/2);
	total=getNumber("Number of Points", 50);
	hasSelection = false;
	waitForUser("Draw an ROI and click OK.\n\nPoints will only be placed within this region.                \n\nOr just press OK to use whole image area");
	if(selectionType()==-1){
		run("Select All");
	}
	roiManager("Add");
	selectWindow("Particle Array");
	startTime = getTime();
	totalTime = 0;
	for (n=1;n<=total;n++){
		//place center of sphere
		hasSpot = false;
		while(!hasSpot){
			rx=round(random*w);
			ry=round(random*h);
			rz=round(random*z);	
			roiManager("Select",0);
			if(selectionContains(rx,ry)){
				//draw sphere
				for(h0=(-1*r);h0<=r;h0++){
					sl = rz+h0;
					if((sl > 0) && (sl < nSlices())){
						Stack.setSlice(rz+h0);
						h1 = abs(r - h0);
						inner = h1 * ((2 * r) - h1);
						spot = sqrt(inner);					
						if(spot!=0){
							makeOval(rx-spot, ry-spot, 2*spot, 2*spot);
							run("Fill","slice");
						}
					}
				}
				hasSpot = true;
				now = getTime();
				totalTime = now-startTime;
				timePerSpot = totalTime / n;
				spotsRemaining = total-n;
				timeRemaining = timePerSpot * spotsRemaining;
				print("\\Update1:Appoximate time remaining (still "+spotsRemaining+" spots to do)");
				convert_ms_ToSensibleTime(timeRemaining);
			}
		}
	} 
}
	

function convert_ms_ToSensibleTime(ms){
	sec = ms / 1000;
	if(sec < 60){
		print("\\Update2:"+floor(sec) +" seconds");
	}
	if(sec > 60){
		min = floor(sec / 60);
		sec = floor(sec % 60); 
		print("\\Update2:"+min + " minutes and "+ sec +" seconds");
	}
}

	


