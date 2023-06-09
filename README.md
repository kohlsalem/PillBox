# PillBox
The PillBox is a compact, space-saving solution that allows you to store and organize your medication easily. Its slim design takes up minimal space, making it perfect for use at home or on the go. Say goodbye to cluttered medicine cabinets and hello to a more organized and efficient way of storing your medication with the PillBox.

This box is a fully configurable OpenSCAD model.

Various options can be used,e.g.:

pills = [
    ["B", 11, 6 ,3.8],  
    ["B", 10, 7 ,5  ], 
]

Normal "Box size" holes will be defined with Vectors, "B" indicates box, followed by length, width and deepness.
<img width="368" alt="img1" src="https://user-images.githubusercontent.com/16637260/235460541-2912dd80-aa78-4d94-a623-643566f6f244.png">




    ["B", 11, 6 ,3.8],  
    ["B", 10, 7 ,5  ],  
    ["B", 10, 7 ,5  ],  

more medication nedded? just add another row. The rest will allign
<img width="395" alt="img2" src="https://user-images.githubusercontent.com/16637260/235460582-43ba87cc-d000-4958-8838-ff1caf050af8.png">

    ["C", 7.7 ,3.8],  
    ["B", 11,6 ,3.8],  

Any of the medis round? Use "C" for circel, followed by diameter and deepness.
<img width="373" alt="img3" src="https://user-images.githubusercontent.com/16637260/235460605-dba25235-f9d0-4781-8b51-d5e5e15dedda.png">



  ["C", 6 ,3.8],
  ["B", 11,6 ,3.8],  

Since round pills tend to be bigger, more space is needed To compensate that, the layout will be "zig-zagged". The geometries will be be allign perfectly to the given sizes
<img width="370" alt="img4" src="https://user-images.githubusercontent.com/16637260/235460645-c5c9441a-2415-46b1-ace0-b90194b35bef.png">


  ["C", 5 ,3.8],
  ["B", 11,6 ,3.8], 

if there is enough space, a straight line will be used.
<img width="333" alt="img5" src="https://user-images.githubusercontent.com/16637260/235460683-8ce06000-17af-43e2-95d6-88b5b22dab3b.png">

  ["C", 7.7 ,3.8],   
  ["C", 7.7 ,3.8],
  ["B", 11,6 ,3.8],  

if several cirlce lines are used, the lines do a kerning into each other.
<img width="425" alt="img6" src="https://user-images.githubusercontent.com/16637260/235460748-18b117f1-ef68-4c6c-a48b-8936d57c7cc8.png">

  ["S", 7.7 ,3.8],
  ["B", 11,6 ,3.8],  ´
  
Does the circle look to ugly? How about a pattern using square rhombs insted?
<img width="388" alt="img7" src="https://user-images.githubusercontent.com/16637260/235460777-a6e4a06e-cd68-4129-91b9-cf8776007fc6.png">

  ["S", 7.7 ,3.8],
  ["S", 7.7 ,3.8],
  ["B", 11,6 ,3.8],  ´   
  
several of this rhombs fit perfectly into each other. (took me >10h to get it right).
<img width="434" alt="img8" src="https://user-images.githubusercontent.com/16637260/235460799-adb5eb82-b935-4e9e-88c8-7062fe42c8af.png">

Additional parameters to set: 
size = 7;  // Nr of pills

innerwallthickness = 1;   // Size of the inner wall between pills
outerwallthickness = 1.5; // Size of the outer wall between pills
coverthickness=1;         // Size of the cover

coveroffset=0.0;          // offset between box and cover, depends on printer quality :-)

chamfer = outerwallthickness*1.5; //Chamfer on the bottom to hold the cover in case of odd ratios you might want to give a fixed number

pillroundoverfactor=0.3;  // Values between 0=box and 0.5=halfround for roundig up the "B" Cavities

$fs = 0.01; // Set this to 0.01 for higher definition curves (renders slower) or to 0.15 (faster)

If you never used OpenSCAD, it is relatively straight forward: 

* Download and install the latest version of OpenSCAD from the official website: https://www.openscad.org/downloads.html. Choose the appropriate version for your operating system and follow the installation instructions.

* After installation, launch OpenSCAD and click on the "File" menu, then select "Open" and navigate to the location where you saved the "PillBox.scad" file. Open the file.

* Configure your pillbox as described above

* To generate an STL file, click on the "Design" menu, then select "Compile and Render (F6)". This will compile the model and generate a preview.

* If the preview looks correct, click on the "File" menu, then select "Export" and choose "STL file" from the list of options. You can choose a name and location for the STL file and then click "Save".

* The STL file is now ready to be imported into a 3D printing software or sliced for printing on a 3D printer.
 
