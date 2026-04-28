//Set Parent Directory
Parent = "Path_to_experiment_folder";

//Input Directory
Input = Parent+"input_images_subfolder 2D Aligned/"
//Input = Parent+"Deconvolved Avg/"

//Get list of all files from Input
filelist = getFileList(Input);

Array.sort(filelist);

//Output Directory
Output = Parent+"input_images_subfolder 2D Avg/"
//Output = Parent+"Deconvolved Avg BgS/"
File.makeDirectory(Output);


setTool("rectangle");
for (i = 0; i < lengthOf(filelist); i++) {
    if (endsWith(filelist[i], ".tif")) {
    	//Open file and get name
    	//print(filelist[i]);
    	open(Input+filelist[i]);
    	name = File.nameWithoutExtension;
    	run("Z Project...", "projection=[Average Intensity]");
    	//name = removeStringFromName(name, "_timelapse");
   		
    	saveAs("Tiff", Output+name);
    	close("*"); 	
    }
}

function removeStringFromName(filename, delimiter) {
    index = indexOf(filename, delimiter);
    if (index > -1) {
        part1 = substring(filename, 0, index);
        part2 = substring(filename, index + lengthOf(delimiter), lengthOf(filename));
        return part1 + part2;
    } else {
        return filename; // Return full name if delimiter is not found
    }
}

