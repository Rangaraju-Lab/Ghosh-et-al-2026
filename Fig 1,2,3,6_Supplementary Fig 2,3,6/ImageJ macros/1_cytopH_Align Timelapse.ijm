// Set Parent Directory
Parent = "Path_to_experiment_folder";

// Input Directory
Input = Parent + "input_images_subfolder/";

// Output Directory
Output = Parent + "input_images_subfolder 2D Aligned/";
File.makeDirectory(Output);

// Get file list and sort
filelist = getFileList(Input);
Array.sort(filelist);




// Loop through .tif files
for (i = 0; i < lengthOf(filelist); i++) {
    if (endsWith(filelist[i], "C0.tif") && indexOf(filelist[i], "BASE") != -1) {

        open(Input + filelist[i]);
        baseline = getTitle();
        
		open(Input + filelist[i+2]);
		nh4cl = getTitle();
		
		dish = replace(baseline, ".*(Dish[0-9]+).*", "$1");
		
		run("Concatenate...", "  Aligned] image1=[" + baseline + "] image2=[" + nh4cl + "]");
        // Run alignment
        run("Linear Stack Alignment with SIFT", 
            "initial_gaussian_blur=1.60 steps_per_scale_octave=3 minimum_image_size=512 maximum_image_size=1024 " + 
            "feature_descriptor_size=8 feature_descriptor_orientation_bins=8 closest/next_closest_ratio=0.6 " + 
            "maximal_alignment_error=10 inlier_ratio=0.2 expected_transformation=Rigid interpolate");

        aligned = getTitleContaining("Align");
        selectWindow(aligned);

        run("Grays");

        // Save with original filename
        saveAs("Tiff", Output + dish);

        // Close all open windows
        close("*");
    }
}

// Helper function to find aligned window
function getTitleContaining(str) {
    list = getList("image.titles");
    for (i = 0; i < list.length; i++) {
        if (indexOf(list[i], str) >= 0) {
            return list[i];
        }
    }
    return "";
}
