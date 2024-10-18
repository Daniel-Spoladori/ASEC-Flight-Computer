// Screen resolution variables
float resolutionX = 1920;      // Window width in pixels (some reason if you variable in size function on line 19 it breaks so change in both)
float resolutionY = 1080;       // Window height in pixels (some reason if you variable in size function on line 19 it breaks so change in both)

// Refresh rate (frames per second)
int refreshRate = 500;          // Number of screen updates per second

// Scale limits for dials
float speedCutOff = 8000;      // Maximum speed value the dial can display in m/s (~8000 m/s, roughly orbital speed)
float altitudeCutOff = 500000; // Maximum altitude value the dial can display in meters(~100000 m is considered the edge of space)

// Dial appearance settings
float dialThickness = 30;      // Thickness of the inner part of the dial
float dialStart = 35;          // Start angle of the dial
float dialEnd = 200;           // End angle of the dial
float dialCutOff = 175;       // Angle where the red area starts (representing cutoff)

// Declared PFont variables to hold the custom font
PFont californiaFont;
PFont bankGothic;
void setup() {
	size(1920, 1080); // Set the window size
	//fullScreen(); // Set window for full screen

	frameRate(refreshRate); // Set the refresh rate
	background(0, 255, 0); // Set the background color to green (for chromakey purposes)

	// Load the fonts to their respective variables
	californiaFont = createFont("CaliforniaGothic.ttf", 128);
	bankGothic = createFont("BankGothic.ttf", 128);
	

	noStroke(); // Disable outlines for shapes
}
 
void draw() {
	textFont(californiaFont); // Loads the font
}

// Function to draw a dial, given its position (x1, y1), size, scale of values, label, and current value
void dial(float x1, float y1, float dialSize, float dialScale, String text, float value, String unit, float textSize1, float textPadding1, float textSize2){

	noStroke(); // Disable outlines for the arcs

	// Adjust x and y coordinates to move the anchor point to top left making easier to work with it
	x1 = x1 + (dialSize / 2);  
	y1 = y1 + (dialSize / 2);


	// Draw the gray background part of the dial
	fill(152, 172, 195); // Set fill color to gray-blue
	arc(x1, y1, dialSize, dialSize, radians(-270 + dialStart), radians(-270 + dialEnd), PIE);


	// Map the current value (value) to an angle on the dial between dialStart and dialCutOff
	float angle = map(value, 0, dialScale, dialStart, dialCutOff);

	// Prevent overflowing and visual glitches in the dial 
	if (angle >= dialEnd) {
		angle = dialEnd;
	}


	// Draw the white part of the dial up to the current value (angle)
	fill(230, 230, 255); // Set fill color to light white-blue
	arc(x1, y1, dialSize, dialSize, radians(-270 + dialStart), radians(-270 + angle), PIE);


	/* Draw the red part of the dial starting from the cutoff point (dialCutOff) to the end of the dial
	This area represents values beyond the display scale */
	fill(150, 70, 70); // Set fill color to red (cutoff zone)
	arc(x1, y1, dialSize, dialSize, radians(-270 + dialCutOff), radians(-270 + dialEnd), PIE);


	/* Draw the red used part of the dial starting from the cutoff point (dialCutOff) to the corresponding speed
	This area represents values beyond the display scale */
	if (angle > dialCutOff) {
		fill(255, 0, 0); // Set fill color to red (cutoff used zone)
		arc(x1, y1, dialSize, dialSize, radians(-270 + dialCutOff), radians(-270 + angle), PIE);

	}


	// Draw the unused arc part of the dial (green circle) to mask the outside area
	fill(0, 255, 0); // Set fill color to green (matches the background for chromakey)
	arc(x1, y1, dialSize, dialSize, radians(-270 + dialEnd), radians(-270 + 360 + dialStart), PIE);

	// Draw the center part of the dial (green circle) to mask the inner area, creating a ring-like appearance
	fill(0, 255, 0); // Set fill color to green (matches the background for chromakey)
	circle(x1, y1, dialSize - dialThickness);


	fill(230, 230, 255); // Set the fill color for the text (light blue color)


	textAlign(CENTER, CENTER); // Align the text horizontally and vertically to the center
	textSize(textSize1); // Set the text size
	text(text, x1, y1 - textPadding1 / 2); // Draw the first text (dial type) with a small padding adjustment

	textSize(textSize2); // Set the text size

	/* Draw the second text (value + unit) with a small padding adjustment
		The value is converted to an integer (rounded), concatenated with the unit, and then displayed */
	text(str(int(value)) + unit, x1, y1 + textPadding1 / 2);
}

void bars(float x1, float y1, float x2, float y2, float barScale, String text, float value, float textSize1, float corner, float barCorner){

	noStroke();  // Disable outlines for the bar rectangles

	// Adjust x2 and y2 to represent with cordinates and not scale
	x2 = x2 - x1;
	y2 = y2 - y1;

	// Draw the background bar (gray-blue)
	fill(152, 172, 195);  // Set fill color to gray-blue
	rect(x1, y1, x2, y2, corner);  // Draw the background rectangle with specified corner rounding

	// Map the current value (value) to the width of the bar (x1 to x2)
	float angle = map(value, 0, barScale, x1, x2);

	// Ensure that the mapped value doesn't exceed the maximum scale (cutoff point)
	if (angle >= barScale) {
		angle = barScale;
	}

	// Draw the inner bar representing the actual value (light white-blue)
	fill(230, 230, 255);  // Set fill color to light white-blue
	rect(x1, y1, angle, y2, corner, barCorner, barCorner, corner);  // Draw the value bar

	// Draw the label text to the left of the bar
	textAlign(RIGHT);  // Align the text to the right of the x position
	textSize(textSize1);  // Set the text size for the label
	text(text, x1 - 10, y1 + textSize1 / 1.9);  // Display the text at the specified position with some vertical adjustment
}
