// Screen resolution variables
float resolutionX = 1920; // Window width in pixels (some reason if you variable in size function on line 19 it breaks so change in both)
float resolutionY = 1080; // Window height in pixels (some reason if you variable in size function on line 19 it breaks so change in both)

// Refresh rate (frames per second)
int refreshRate = 500; // Number of frames updates per second

// Scale limits for dials
float speedCutOff = 10000; // Maximum speed value the dial can display in m/s (~8000 m/s, roughly orbital speed)
float altitudeCutOff = 200000; // Maximum altitude value the dial can display in meters (~100000 m is considered the edge of space)

// Dial appearance settings
float dialThickness = 30; // Thickness of the inner part of the dial
float dialStart = 35; // Start angle of the dial
float dialEnd = 240; // End angle of the dial
float dialCutOff = 230; // Angle where the red area starts (representing cutoff)

String format; //hold the format sign for time display

// Declared PFont variables to hold the custom font
PFont californiaFont; // Font for California Gothic style
PFont bankGothic; // Font for Bank Gothic style

void setup() {
	size(1920, 1080); // Set the window size
	fullScreen(); // Set window for full screen

	frameRate(refreshRate); // Set the refresh rate
	background(0, 255, 0); // Set the background color to green (for chromakey purposes)

	// Load the fonts to their respective variables
	californiaFont = createFont("CaliforniaGothic.ttf", 64); // Load California Gothic font
	bankGothic = createFont("BankGothic.ttf", 64); // Load Bank Gothic font
	
	noStroke(); // Disable outlines for shapes
}
 
void draw() {

	//Bad code here (my goal here was speed so i didnt stopped for make it more human readable)

	int time = -60; // Initialize time variable
	fill(0, 255, 0); // Set fill color to green (matches the background)
	rect(0, 0, resolutionX, resolutionY); // Clear entire window

	textFont(californiaFont); // Loads the California Gothic font

	// Draws the speed and altitude dials with specific parameters
	dial(40, resolutionY - 220, 200, speedCutOff, "Speed", 8000, "m/s", 40, 40, 35);
	dial(240, resolutionY - 220, 200, altitudeCutOff, "Altitude", 100000, "m", 40, 40, 35);

	textFont(bankGothic); // Loads the Bank Gothic font

	// Draws bars for fuel
	bars(500, resolutionY - 150, resolutionX / 2.3, resolutionY - 140, 100, "Lqf", 45, 28, 10, 10);
	bars(500, resolutionY - 90, resolutionX / 2.3, resolutionY - 100, 100, "Lox", 45, 28, 10, 10);

	textFont(californiaFont); // Loads the California Gothic font
	textAlign(CENTER,BOTTOM); // Center the text allign
	
	textSize(70); // Set text size
	text("ASEC", resolutionX / 2, resolutionY - 100); // Display our program
	
	textSize(40); // Set text size
	text("GATC™", resolutionX / 2, resolutionY - 40); // Display our company name

	// Determine time format based on the value of time
	if(time < 0){
		time = time * -1; // Make time positive
		format= "-"; // Set format to "-" if time was negative
	}else {
		format = "+"; // Set format to "+" if time is positive
	}

	textAlign(CENTER,BOTTOM); // Center the text allign
	textFont(californiaFont); // Load California Gothic font
	textSize(30); // Set text size
	
	// Display the time in the format "T: +HH:MM:SS"
	text(("T: " + format + timeFormat(time, false)), resolutionX / 2, resolutionY - 180);


	textAlign(LEFT,BOTTOM); // Center the text allign
	textFont(californiaFont); // Load California Gothic font
	textSize(28); // Set text size

	String phase = "Maximum Aerodinamic Pressure (MAX Q)";
	text("Phase: " + phase, resolutionX / 1.75, resolutionY - 180);
	text(("Stage nº: " + str(2)), resolutionX / 1.75, resolutionY - 145);
	text(("Acceleration: " + str(1.31) + "G"), resolutionX / 1.75, resolutionY - 110);
	text(("Engine TWR: " + str(1.25)), resolutionX / 1.75, resolutionY - 75);
	text(("Throttle %: " + str(1 * 100)), resolutionX / 1.75, resolutionY - 40);

}

// Function to draw a dial
void dial(float x1, float y1, float dialSize, float dialScale, String text, float value, String unit, float textSize1, float textPadding1, float textSize2){

	noStroke(); // Disable outlines

	// Adjust x and y coordinates to move the anchor point to top left making easier to work with it
	x1 = x1 + (dialSize / 2);  // Center x-coordinate for the dial
	y1 = y1 + (dialSize / 2);  // Center y-coordinate for the dial

	// Draw the gray background part of the dial
	fill(152, 172, 195); // Set fill color to gray-blue
	arc(x1, y1, dialSize, dialSize, radians(-270 + dialStart), radians(-270 + dialEnd), PIE); // Draw the background arc

	// Map the current value (value) to an angle on the dial between dialStart and dialCutOff
	float angle = map(value, 0, dialScale, dialStart, dialCutOff); // Map value to angle

	// Prevent overflowing and visual glitches in the dial 
	if (angle >= dialEnd) { // If angle exceeds the dial end
		angle = dialEnd; // Cap it at the maximum angle
	}

	// Draw the white part of the dial up to the current value (angle)
	fill(230, 230, 255); // Set fill color to light white-blue
	arc(x1, y1, dialSize, dialSize, radians(-270 + dialStart), radians(-270 + angle), PIE); // Draw filled arc for current value

	/* Draw the red part of the dial starting from the cutoff point (dialCutOff) to the end of the dial
	This area represents values beyond the display scale */
	fill(150, 70, 70); // Set fill color to red (cutoff zone)
	arc(x1, y1, dialSize, dialSize, radians(-270 + dialCutOff), radians(-270 + dialEnd), PIE); // Draw cutoff arc

	/* Draw the red used part of the dial starting from the cutoff point (dialCutOff) to the corresponding speed
	This area represents values beyond the display scale */
	if (angle > dialCutOff) { // If current angle exceeds cutoff angle
		fill(255, 0, 0); // Set fill color to red (cutoff used zone)
		arc(x1, y1, dialSize, dialSize, radians(-270 + dialCutOff), radians(-270 + angle), PIE); // Draw filled arc for used cutoff area
	}

	// Draw the unused arc part of the dial (green circle) to mask the outside area
	fill(0, 255, 0); // Set fill color to green (matches the background for chromakey)
	arc(x1, y1, dialSize, dialSize, radians(-270 + dialEnd), radians(-270 + 360 + dialStart), PIE); // Draw masking arc

	// Draw the center part of the dial (green circle) to mask the inner area, creating a ring-like appearance
	fill(0, 255, 0); // Set fill color to green (matches the background for chromakey)
	circle(x1, y1, dialSize - dialThickness); // Draw inner circle to create ring effect

	fill(230, 230, 255); // Set the fill color for the text (light blue color)

	textAlign(CENTER, CENTER); // Align the text horizontally and vertically to the center
	textSize(textSize1); // Set the text size for the
	text(text, x1, y1 - textPadding1 / 2); // Draw the first text (dial type) with a small padding adjustment

	textSize(textSize2); // Set the text size for the value display

	/* Draw the second text (value + unit) with a small padding adjustment
		The value is converted to an integer (rounded), concatenated with the unit, and then displayed */
	text(str(int(value)) + unit, x1, y1 + textPadding1 / 2); // Display value and unit
}

// Function to draw the bars
void bars(float x1, float y1, float x2, float y2, float barScale, String text, float value, float textSize1, float corner, float barCorner){

	noStroke();  // Disable outlines

	// Adjust x2 and y2 to represent with coordinates and not scale
	x2 = x2 - x1; // Calculate width based on coordinates
	y2 = y2 - y1; // Calculate height based on coordinates

	// Draw the background bar (gray-blue)
	fill(102, 122, 145);  // Set fill color to gray-blue
	rect(x1, y1, x2, y2, corner);  // Draw the background rectangle

	// Map the current value (value) to the width of the bar (x1 to x2)
	float angle = map(value, 0, barScale, x1, x2); // Map value to bar length

	// Ensure that the mapped value doesn't exceed the maximum scale (cutoff point)
	if (angle >= barScale) { // If mapped angle exceeds the bar scale
		angle = barScale; // Cap it at the maximum scale
	}

	// Draw the inner bar representing the actual value (light white-blue)
	fill(230, 230, 255);  // Set fill color to light white-blue
	rect(x1, y1, angle, y2, corner, barCorner, barCorner, corner);  // Draw the value bar

	// Draw the text to the left of the bar
	textAlign(RIGHT, CENTER);  // Align the text
	textSize(textSize1);  // Set the text size for the
	text(text, x1 - 10, y1 + y2 / 2);  // Display the text at the specified position with some vertical adjustment
}

// Function format the time
String timeFormat(int time, boolean semicolon){
	String timeHours = str(floor(time / 3600)); // Calculate hours from total time
	String timeMinutes = str(floor((time % 3600) / 60)); // Calculate minutes from remaining seconds
	String timeSeconds = str(floor(time % 60)); // Calculate remaining seconds

	// I know its a bad practice but I do not want to face my trauma / regex. Feel sorry for the mess (I personally think its more human being readable
	if (timeHours.length() == 1) timeHours = "0" + timeHours; // Add leading zero if needed
	if (timeMinutes.length() == 1) timeMinutes = "0" + timeMinutes; // Add leading zero if needed
	if (timeSeconds.length() == 1) timeSeconds = "0" + timeSeconds; // Add leading zero if needed

	// Return formatted time based on whether a semicolon is needed
	if(semicolon){
		return timeHours + ":" + timeMinutes + ":" + timeSeconds; // Format with colons
	}else{
		if (time >= 3600) { // If time is one hour or more
			return timeHours + ":" + timeMinutes + ":" + timeSeconds; // Return full format
		}
		if (time >= 60) { // If time is one minute or more
			return timeMinutes + ":" + timeSeconds; // Return minutes and seconds
		}else{
			return timeSeconds; // Return only seconds
		}
	}
}
