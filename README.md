# PillBox
OpenSCAD fully Configurable Pillbox

pills = [
    ["B", 11, 6 ,3.8],  
    ["B", 10, 7 ,5  ], 
]

 <img width="368" alt="img1" src="https://user-images.githubusercontent.com/16637260/235460541-2912dd80-aa78-4d94-a623-643566f6f244.png">

Normal "Box size" holes will be defined with Vectors, "B" indicates box, followed by length, width and deepness.



    ["B", 11, 6 ,3.8],  
    ["B", 10, 7 ,5  ],  
    ["B", 10, 7 ,5  ],  
<img width="395" alt="img2" src="https://user-images.githubusercontent.com/16637260/235460582-43ba87cc-d000-4958-8838-ff1caf050af8.png">


more medication nedded? just add another row. The rest will allign

    ["C", 7.7 ,3.8],  
    ["B", 11,6 ,3.8],  
<img width="373" alt="img3" src="https://user-images.githubusercontent.com/16637260/235460605-dba25235-f9d0-4781-8b51-d5e5e15dedda.png">


Any of the medis round? Use "C" for circel, followed by diameter and deepness.

  ["C", 6 ,3.8],
  ["B", 11,6 ,3.8],  
<img width="370" alt="img4" src="https://user-images.githubusercontent.com/16637260/235460645-c5c9441a-2415-46b1-ace0-b90194b35bef.png">

Since round pills tend to be bigger, more space is needed To compensate that, the layout will be "zig-zagged". The geometries will be be allign perfectly to the given sizes

  ["C", 5 ,3.8],
  ["B", 11,6 ,3.8], 

<img width="333" alt="img5" src="https://user-images.githubusercontent.com/16637260/235460683-8ce06000-17af-43e2-95d6-88b5b22dab3b.png">
if there is enough space, a straight line will be used.

  ["C", 7.7 ,3.8],   
  ["C", 7.7 ,3.8],
  ["B", 11,6 ,3.8],  
<img width="425" alt="img6" src="https://user-images.githubusercontent.com/16637260/235460748-18b117f1-ef68-4c6c-a48b-8936d57c7cc8.png">

if several cirlce lines are used, the lines do a kerning into each other.

  ["S", 7.7 ,3.8],
  ["B", 11,6 ,3.8],  //Ramipril    
<img width="388" alt="img7" src="https://user-images.githubusercontent.com/16637260/235460777-a6e4a06e-cd68-4129-91b9-cf8776007fc6.png">


Does the circle look to ugly? How about a pattern using square rhombs insted?


  ["S", 7.7 ,3.8],
  ["S", 7.7 ,3.8],
  ["B", 11,6 ,3.8],  //Ramipril    
<img width="434" alt="img8" src="https://user-images.githubusercontent.com/16637260/235460799-adb5eb82-b935-4e9e-88c8-7062fe42c8af.png">
several of this rhombs fit perfectly into each other. (took me >10h to get it right).

Additional parameters to set: 
size = 7;  // Nr of pills

innerwallthickness = 1;   // Size of the inner wall between pills
outerwallthickness = 1.5; // Size of the outer wall between pills
coverthickness=1;         // Size of the cover

coveroffset=0.0;          // offset between box and cover, depends on printer quality :-)

chamfer = outerwallthickness*1.5; //Chamfer on the bottom to hold the cover in case of odd ratios you might want to give a fixed number

pillroundoverfactor=0.3;  // Values between 0=box and 0.5=halfround for roundig up the "B" Cavities

$fs = 0.01; // Set this to 0.01 for higher definition curves (renders slower) or to 0.15 (faster)

 
