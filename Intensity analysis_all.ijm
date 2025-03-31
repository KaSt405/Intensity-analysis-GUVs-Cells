// ---------------------------------Input--------------------------------

// Not for time series! 
// z-stacks will be converted to a maximum intensity projection

// Select channel number for area determination for intensity measurement; enter 1, 2, 3 or 4
channel_area = 2

// Select channels for intensity measurements; 0 = no; 1 = yes
channel_1_intensity = 1
channel_2_intensity = 0
channel_3_intensity = 0
channel_4_intensity = 0

// Close windows at the end; 0 = no; 1 = yes
winclose = 1

//------------------------------------------------------------------------

// Get the list of open image titles
image_list = getList("image.titles");

// Get file dimensions
Stack.getDimensions(width, height, channels, slices, n);

// Print the titles of the open images
for (im = 0; im < image_list.length; im++) {
    print("Open Image title: " + image_list[im]);
    // Renaming images before processing
    selectWindow(image_list[im]);
    rename("raw_data_stack_" + im); 
}

// Create Maximum Intensity Projection
if(slices > 1) {run("Z Project...", "projection=[Max Intensity]");}

// Split channels into individual images
if (channels > 1) {run("Split Channels");}

// Add a small delay to make sure the split channels open
wait(500); 

// Renaming the channels to the new format
if (channels >= 1) {if (slices > 1) {selectWindow("C1-MAX_raw_data_stack_0");} else {selectWindow("C1-raw_data_stack_0");}
rename("C1");}
if (channels >= 2) {if (slices > 1) {selectWindow("C2-MAX_raw_data_stack_0");} else {selectWindow("C2-raw_data_stack_0");}
rename("C2");}
if (channels >= 3) {if (slices > 1) {selectWindow("C3-MAX_raw_data_stack_0");} else {selectWindow("C3-raw_data_stack_0");}
rename("C3");}
if (channels >= 4) {if (slices > 1) {selectWindow("C4-MAX_raw_data_stack_0");} else {selectWindow("C4-raw_data_stack_0");}
rename("C4");}

// Duplicate channel for thresholding
if (channel_area == 1) {selectWindow("C1");}
if (channel_area == 2) {selectWindow("C2");}
if (channel_area == 3) {selectWindow("C3");}
if (channel_area == 4) {selectWindow("C4");}
run("Duplicate...", "title=channel_duplicated");

// Apply Gaussian filter to the duplicated image
selectWindow("channel_duplicated");
run("Gaussian Blur...", "sigma=1");

// Select the duplicated channel and prompt the user for a threshold value
selectWindow("channel_duplicated");

// Prompt the user for the lower and upper threshold values
minThreshold = getNumber("Enter the minimum threshold value:", 600);
maxThreshold = getNumber("Enter the maximum threshold value:", 4096);

// Apply the user-defined threshold to the duplicated channel
setThreshold(minThreshold, maxThreshold);

// Create selection from thresholded areas in the duplicated channel
run("Create Selection");

// Open the ROI Manager
run("ROI Manager...");

// Add the selection to the ROI Manager
roiManager("add");

// Apply the selection to C1 and measure pixel intensities
if (channels >= 1) {if (channel_1_intensity == 1) 
{selectWindow("C1");
roiManager("Select", 0);
run("Measure");}}

// Apply the selection to C2 and measure pixel intensities
if (channels >= 2) {if (channel_2_intensity == 1) 
{selectWindow("C2");
roiManager("Select", 0);
run("Measure");}}

// Apply the selection to C3 and measure pixel intensities
if (channels >= 3) {if (channel_3_intensity == 1) 
{selectWindow("C3");
roiManager("Select", 0);
run("Measure");}}

// Apply the selection to C4 and measure pixel intensities
if (channels >= 4) {if (channel_4_intensity == 1) 
{selectWindow("C4");
roiManager("Select", 0);
run("Measure");}}

// Close windows
if (winclose == 1) {close("ROI Manager");
close("Log");
selectWindow("channel_duplicated");
close();
if (isOpen("raw_data_stack_0")) 
	{selectWindow("raw_data_stack_0");
	close();}
if (isOpen("C1")) 
	{selectWindow("C1");
	close();}
if (isOpen("C2")) 
	{selectWindow("C2");
	close();}
if (isOpen("C3")) 
	{selectWindow("C3");
	close();}
if (isOpen("C4")) 
	{selectWindow("C4");
	close();}}