if (!isOpen("ROI Manager")) exit("Open ROI Manager first.");

n = roiManager("count");
if (n == 0) exit("No ROIs in ROI Manager.");

run("Clear Results");

// === Parse from filename ===
title = getTitle();
/*
parts = split(title, " ");

date = "";
condition = "";
dish = "";
cell = "";

// Parse components from filename
if (lengthOf(parts) > 0) date = parts[0];
if (lengthOf(parts) > 1) condition = parts[1];
for (j = 0; j < lengthOf(parts); j++) {
    if (startsWith(parts[j], "Dish")) {
        dish = substring(parts[j], 4);
    }
    if (startsWith(parts[j], "Cell")) {
        subparts = split(parts[j], "_");  // e.g. "Cell1_C0.tif" → ["Cell1", "C0.tif"]
        cell_part = subparts[0];          // "Cell1"
        cell = substring(cell_part, 4);   // extract number part → "1"
    }
}

retainedIndices = newArray();
*/
row = 0;
stackSize = nSlices;

for (i = 0; i < n; i++) {
    for (s = 1; s <= stackSize; s++) {
        roiManager("select", i);
        setSlice(s);

        mean = getValue("Mean");
        if (mean <= 0) continue;

        retainedIndices = Array.concat(retainedIndices, i);

        getSelectionBounds(x, y, w, h);
        cx = x + w / 2;
        cy = y + h / 2;

        setResult("Spine_ID", row, i + 1);
        setResult("Frame", row, s);
        setResult("Intensity", row, mean);
        row++;
    }
}
/*
// === Remove duplicate retainedIndices ===
retainedUnique = newArray();
for (i = 0; i < lengthOf(retainedIndices); i++) {
    keep = true;
    for (j = 0; j < lengthOf(retainedUnique); j++) {
        if (retainedIndices[i] == retainedUnique[j]) {
            keep = false;
            break;
        }
    }
    if (keep) {
        retainedUnique = Array.concat(retainedUnique, retainedIndices[i]);
    }
}

// === Delete non-retained ROIs ===
for (i = n - 1; i >= 0; i--) {
    keep = false;
    for (j = 0; j < lengthOf(retainedUnique); j++) {
        if (i == retainedUnique[j]) {
            keep = true;
            break;
        }
    }
    if (!keep) {
        roiManager("select", i);
        roiManager("Delete");
    }
}
*/
updateResults();
// Get working directory of the image
dir = getDirectory("image");
// Get title (Dish1, Dish2, etc.)
title = getTitle();
// Remove extension if present
dot = lastIndexOf(title, ".");
if (dot != -1)
    title = substring(title, 0, dot);

// Build output filename
out_results = dir + title + "_F.csv";
out_roi = dir + title + "_F_RoiSet.zip";
// Save
saveAs("Results", out_results);
roiManager("deselect");
roiManager("Save", out_roi)
close("*");
close("Results");
close("Roi manager");