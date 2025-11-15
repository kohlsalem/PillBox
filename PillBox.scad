/***********************************************
* Flexible Mini Pill Box - fully configurable  *
***********************************************/

 /* This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.
    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.
    You should find a copy of the GNU General Public License
    at http://www.gnu.org/licenses/>. */

/***************************************
* Customizer Section, remove till here,*
* set pills manually below             *
****************************************/
/*********************************
* Configuration                  *
*********************************/

// Vector of pills to be used 
//
// the first element defines the type to be rendered, the following elements describe the pill
//
// ["B", Length, Width, Height] - Boxlike Cavity. 
//      Exaple: ["B",11  ,6  ,3.8],  //Ramipril
//
// ["C", Diameter, Height ]   - Cylindrical Cavity, Layed in a ZigZag pattern if needed, 
//      Example: ["C",7.7     ,3.8], //Lercandipin
//
// ["S", Diameter, Height ]   - Square Rhomb Pattern. Adjacent pattern get connected. Pretty decorative. THe sice will be at least the requested one, due to laws of geometry it might become bigger
//      Example: ["S",7.7     ,3.8], //Lercandipin
//
pills = [
/*   ["B", 12.4, 6.3  ,3.8],  //Ramipril
   ["B", 8  ,6.3,3.8],
   ["C", 7.7    ,3.8],   //Lercandipin
*/   ["B", 26, 10, 10],  
   ["B", 26, 10, 10], 
];

// Nr of pills per Row
size = 7;  

//Nr of Boxes :-)
NrOfBoxes = 4; 

// Size of the inner wall between pills
innerwallthickness = 1;   
// Size of the outer wall between pills
outerwallthickness = 1.5; 
// Size of the cover
coverthickness=1;         
// offset between box and cover, depends on printer quality :-)
coveroffset=0.04;          

//Chamfer on the bottom to hold the cover in case of odd ratios you might want to give a fixed number
chamfer = outerwallthickness*1.5; 

// Values between 0=box and 0.5=halfround for roundig up the "B" Cavities
pillroundoverfactor=0.3;//[0:0.5]  

// Set this to 0.01 for higher definition curves (renders slower) or to 0.15 (faster)
$fs = 0.01;

//**************************************************************************
// There should be no need to touch anything below here
//**************************************************************************

//print several boxes
boxes(NrOfBoxes);

module boxes(numberofboxes){
    
  for( i=[1: numberofboxes]){
      
    translate([(i-1)*(5+boxx+2*(coverthickness+coveroffset)), 0, 0]) {  
      //Print the Box (Yeah)
      pillbox();

      //cover is rendered closed, open it for better printability
      translate([0,boxy+5,boxy+coverthickness]) { 
      rotate([-90,0,0]){
        // print the cover
        cover(i);
      }}
    }
    
  } 
}


// if an inner wall is angled in 45°, its actual size is a bit wider. this is the difference
innerwallthickness45correct = innerwallthickness-sqrt(2*innerwallthickness^2)/2;

//Height (Z) for a given Pill
function GetPillHeight(pill) =
           pill[0] == "B" ? pill[3] : 
           pill[0] == "C" ? pill[2] : 
           pill[0] == "S" ? pill[2] : 
           assert(false,"Unknown Pilltype");
          

//this shall be the actual thickness of the theoreticall inner round pill of a square rhomb
function SWidthFromMax(pill)= sqrt((MaxPillWidth() + innerwallthickness45correct)^2*2);


//Width (y) for a given Pill 
function GetPillWidth(pill) =
           pill[0] == "B" ? pill[2] : 
           pill[0] == "C" ? pill[1] : 
           // this shall be the actual thickness of the theoreticall inner round pill of the rhomb
           // which equals to the small size of the rhomb‚
           pill[0] == "S" ? (pill[1]<SWidthFromMax(pill))? SWidthFromMax(pill):pill[1] : 
           assert(false,"Unknown Pilltype");


// Compair 2 Lists (2 Pills, but hey, generically is more geeky)  
function CompList(a,b)=
         len(a)!=len(b)?false:
         len(a)==0?true:
         min([for(n=[0,len(a)-1] ) a[n]==b[n]]);
           
//Does a list of lists contain a given list.   
function ContainsList(list,searchfor)=  max([for(elem=list)CompList(elem,searchfor),false]);
            
//Relative "logical" "Theoretical" Width (y) for a given Pill 
//since Round pills get layed zigzag, this is the relative distance between 2 pills, not the actual size  
//Most nasty recursion brake i could ever imagine :-)
function GetPillRelativeWidth(pill,exclude=[]) =
           ContainsList(exclude,pill)?0:  //recursion break
           pill[0] == "B" ? pill[2] : 
           //               Theoretically it would be the radius of the pill, but may be we have more space anyways                
           pill[0] == "C" ? max([pill[1]/2,max([for(p=pills)(p!=pill)?GetPillRelativeWidth(p,concat(exclude,[pill])):0])]) -
                                innerwallthickness/2: 
                            // relative width WITH 45 degree wall correct
           pill[0] == "S" ? max([sqrt(pill[1]^2*2)/2+innerwallthickness45correct,
                                max([for(p=pills)(p!=pill)?GetPillRelativeWidth(p,concat(exclude,[pill]) ):0])]): 
           assert(false,"Unknown Pilltype");

                                 
// Avoid Negative and unknown        
function PLUS(x)=(x==undef)?0:(x>0)?x:0;           
    
//Length (x) for a given Pill           
function GetPillLength(pill) = 
           pill[0] == "B" ? pill[1] :  
           pill[0] == "C" ?  pill[1] + sqrt(PLUS((pill[1]+innerwallthickness/2)^2-MaxPillWidth()^2)) :
                                //pill[1] + PLUS(sqrt( (pill[1]+innerwallthickness)^2 - (GetPillRelativeWidth(pill)+innerwallthickness+innerwallthickness/2)^2 )) : 
                           
                                // shift upwards + one innercirclediameter one radius+innerwall
           pill[0] == "S" ? 
                  //without Kerning this gived lligned lines: "2*MaxPillWidth()+innerwallthickness ":   
                  //However, we do need enought space, which is 
                   GetPillWidth(pill)+MaxPillWidth()+innerwallthickness :             
           assert(false,"Unknown Pilltype");


//Determine maximum hight of all defined pills 
function MaxPillHeight() = max([for (pill=pills) GetPillHeight(pill)]);

//tweek to handle the difference between logical and actual width of zigzaged objects properly. 
function ActuallExtraPadding() = (max([for(pill=pills) GetPillWidth(pill)]) -
                                  max([for(pill=pills)GetPillRelativeWidth(pill)]))/2;

   // for optical reasons, "ZigZaged"elements might overlap a bit, up to innerwallthinkness. This is art, not programming. it looks better and is still good. 
function WallExtraPadding() = (ActuallExtraPadding()>(outerwallthickness-innerwallthickness)) ?ActuallExtraPadding()-(outerwallthickness-innerwallthickness):0;

//Determine maximum pill width of all defined pills 
function MaxPillWidth() = max([for(pill=pills)GetPillRelativeWidth(pill)]);

//return the first n elements of a vector
function FirstElements(vec,n) = n<len(vec)?[ for (i = [0:n-1])vec[i]]:vec; 

//Determine the sum all values of a vector
function sum(v,i=0) = (i < len(v)-1) ? v[i]+sum(v,i+1) : v[i];

//Dertermine length of the row
//function SumLengthRows(n=len(pills)) = sum([for (pill=FirstElements(pills,n+1)) GetPillLength(pill)]);
function SumLengthRows(n=len(pills)-1) = sum([for(count=[0:n]) GetPillLength(pills[count])-Kerning(count)]);

//Kerning - define how far 2 zigzagged rows can be moved together. 
function Kerning(n)= 
               // if this is the overall last row - no kerning
               (n>=(size-1))? 0 :
               // all but the last consecutive S get kerned
               (pills[n][0]=="S")&&(pills[n][0]==pills[n+1][0]) ? GetPillWidth(pills[n]) - MaxPillWidth() :
               // all but the last consecutive C get kerned
               (pills[n][0]=="C")&&(pills[n][0]==pills[n+1][0]) ? 
                    min([ // 3 differenc colision points to be considered, the min of them  
                        //Inner n to Outer n+1
                        pills[n][1]/2+pills[n+1][1]/2 + innerwallthickness/2 - sqrt((pills[n][1]/2+pills[n+1][1]/2+innerwallthickness/2)^2- MaxPillWidth()^2),
                        //Inner n to Outer n
                        sqrt(PLUS((pills[n][1]+innerwallthickness/2)^2-MaxPillWidth()^2)),
                         //Inner n+1 to Outer n+1
                        sqrt(PLUS((pills[n+1][1]+innerwallthickness/2)^2-MaxPillWidth()^2))
                    ]):
               0;



// If kerning happended before or after this row, there is no need to clip the rhombs
function ExtendBefore(row)= 
                    row<=0                            ? 0 :
                    row> len(pills)-1                 ? 0 :
                    (pills[row][0]==pills[row-1][0]) ? MaxPillWidth():0;//Any value will do, but this should work even with huge sizes

function ExtendAfter(row)= 
                    row< 0                            ? 0 :
                    row>=len(pills)-1                 ? 0 :
                    (pills[row][0]==pills[row+1][0]) ? MaxPillWidth():0;//Any value will do, but this should work even with huge sizes




// outer dimansions of the box
boxx=SumLengthRows()+(len(pills)-1)*innerwallthickness+2*outerwallthickness;
boxy=MaxPillWidth()*size+innerwallthickness*(size-1)+2*outerwallthickness+2*WallExtraPadding();
boxz=MaxPillHeight()+outerwallthickness-0.00001;//under sone circumstances a rounding error left the box slightly closed. 

    
// rendering of the box    
module pillbox(){

    // one row of Pill Cavities
   
    module RowOfSamePill( row){
        pill=pills[row];
        if(pill[0]=="B"){  
            for(count=[0:size-1]){
                translate([0,count*(MaxPillWidth()+innerwallthickness),0])//Move to the right position in row 
                // one rectangular cavity holdinng one pill of given size
                roundedbox([pill[1], pill[2], pill[3]],min([pill[1], pill[2]])*pillroundoverfactor);
         
            }
        } else if(pill[0]=="C"){ 
        
            for(count=[0:size-1]){
                radius=pill[1]/2;
                if(count%2==0){
                    translate([0,count*(MaxPillWidth()+innerwallthickness),0])//Move to the right position in row 
                    translate([radius,radius,0]) // move the cylinder laft alligned, as a box would have been
                    cylinder( h = pill[2], r=pill[1]/2 );
                }else{
              
                    // The right sideward move to zigzag.                   
                    translate([sqrt(PLUS((pill[1]+innerwallthickness/2)^2-MaxPillWidth()^2)),0,0])
                    
                    translate([0,count*(MaxPillWidth()+innerwallthickness),0])//Move to the right position in row 
                  
                    translate([radius,radius,0]) // move the cylinder left alligned, as a box would have been
                    cylinder( h = pill[2], r=pill[1]/2 );
                }
              
            }
        } else if(pill[0]=="S"){ 
           //cut away rhomb overlap
            
            intersection(){
                union(){
                    rhombsize=GetPillWidth(pill); // yes, the size of the rhomb equals the logical width of hte row
                                                  // it is anyway just turned by 45 
                    
                    move = MaxPillWidth()+innerwallthickness;
                   
                    for(col=[-1:size]){ // one more on each sid for deco purposes
                      radius=pill[1]/2;
                      
                       if(col%2==0){
                         translate([0,col*move,0])//Move to the right position in row 
                         rhombbox( rhombsize, pill[2] );
                        
                         if(col>=0 && col <size && false && // except for the outer deco ends,looks xxx 
                           !( row>0 && pills[row-1]=="S") ){      // Only if the neigbor is not kerned
                             // add a deco box in the corner
                             translate([2*move,col*move,0])  
                             rhombbox( rhombsize, pill[2] );
                         }                     
                                  
                      }else{

                          translate([move,col*move,0])//Move to the right position in row 
                          rhombbox( rhombsize, pill[2] );
                          
                         if(col>=0 && col <size && false &&// except for the outer ends,looks bad   
                            !( row<(len(pills)-1) && pills[row+1]=="S") ){                       
                             // add a deco box in the corner
                             translate([-move,col*move,0])  
                             rhombbox( rhombsize, pill[2] );    
                         }
                      }//if even       
               
                      
                    }//for 
                    //deco for even and uneven ends
          
                }
        
                //cut away overlapping rhombs
                // If kerning happended before or after this row, there is no need to clip the rhombs
                translate([-ExtendBefore(row),0,0])
                cube([GetPillLength(pill)+ExtendAfter(row)+ExtendBefore(row),
                        size*(MaxPillWidth()+innerwallthickness)+2*WallExtraPadding(),
                        pill[2]+1]);  
            
            }//intersection
      }
    }
    
  
    module ColumnsOfDifferentPills(pills){
        for(row=[0:len(pills)-1]){
            echo("Translate",SumLengthRows(row) - (GetPillLength(pills[row]) -Kerning(row)) + row*innerwallthickness);
            translate([
                // x= length of all rows so far - the current * + inner per row; we start with 0 so that works
                SumLengthRows(row) - (GetPillLength(pills[row]) -Kerning(row)) + row*innerwallthickness, 
          
                // x=center the pill hole per row. 
                (MaxPillWidth()-GetPillWidth(pills[row]))/2+WallExtraPadding()+ 
                //As always, S needs some extra handling :-/ (drives me nuts)
                ((pills[row][0]=="S")?innerwallthickness45correct/2:0),
                //Y - well, the should end on the same top postion, shouldnt they?
                MaxPillHeight()-GetPillHeight(pills[row])
            ])  
            RowOfSamePill(row);//One neatly packed row 
        }  
    }

    
    difference(){ // Body minus Holes
        
        // somehow the body needs to be tossed around abit to match the cavities  
        translate([0,boxy,0]) { rotate([90,0,0]){
        
            linear_extrude(boxy){ // extrude the box form side profile
                polygon(
                        points=
                            [[0,chamfer],
                             [0,boxz],
                             [boxx,boxz], 
                             [boxx,chamfer], 
                              
                             [boxx-chamfer,0],
                             [chamfer,0],
                             [0,chamfer]]
                            );
            } // extrude
        }} // translate/rotate
        
        translate([outerwallthickness,outerwallthickness,outerwallthickness])
        ColumnsOfDifferentPills(pills);
    }// difference
}

// rendering of the cover 
module cover(label){  
     //chamferthicknesscorrection, i don not want to get the chamfered part thinned out 
     ctc = sqrt(2*coverthickness^2)-coverthickness;

     translate([-coverthickness-coveroffset,boxy,0]) { rotate([90,0,0]){
     union(){ 
       linear_extrude(boxy){ // extrude the box form side profile 
          polygon(
              points=
            [[0,chamfer-ctc],
             [0,boxz+coveroffset+coverthickness],
             [boxx+2*coveroffset+2*coverthickness, boxz+coveroffset+coverthickness], 
             [boxx+2*coveroffset+2*coverthickness, chamfer-ctc], 
             [boxx+2*coveroffset+2*coverthickness-chamfer+ctc, 0], 
             [boxx+2*coveroffset+  coverthickness-chamfer, 0],            
             [boxx+2*coveroffset+  coverthickness, chamfer],  
             [boxx+2*coveroffset+  coverthickness, boxz+coveroffset],  
             [coverthickness, boxz+coveroffset],  
             [coverthickness, chamfer],      
             [coverthickness+chamfer, 0],   
             [chamfer-ctc, 0],           
             [0,chamfer-ctc]]
            );
         }//extrude 
        
       translate([0,-0,-coverthickness]){  
              difference(){
               linear_extrude(coverthickness){ //endcap
                  polygon(
                      points=
                    [[0,chamfer-ctc],
                     [0,boxz+coveroffset+coverthickness],
                     [boxx+2*coveroffset+2*coverthickness, boxz+coveroffset+coverthickness], 
                     [boxx+2*coveroffset+2*coverthickness, chamfer-ctc], 
                     [boxx+2*coveroffset+2*coverthickness-chamfer+ctc, 0], 
                     [boxx+2*coveroffset+  coverthickness-chamfer, 0],  
                   //  [boxx+2*coveroffset+  coverthickness-chamfer-(boxx-2*chamfer)/4, boxz/1.5],                 
                     //[coverthickness+chamfer+(boxx-2*chamfer)/4, boxz/1.5],
                     [coverthickness+chamfer, 0],
                     [chamfer-ctc, 0],               
                     [0,chamfer-ctc]]
                    );
                  }//extrude
                  3PCylinder([boxx+2*coveroffset+  coverthickness-chamfer, 0],
                             [(boxx+2*coveroffset+  2*coverthickness)/2,boxz*0.7],
                             [coverthickness+chamfer, 0],
                              coverthickness);
              }
        }
        if (label != 0) { 
          translate([
                  (boxx + 2*coveroffset + 2*coverthickness) / 2,
                   boxz+0.2,
                   boxy*0.5
                   ]) {
            rotate([-90, 180, 0]) {
              linear_extrude(coverthickness+0.2) {
                text(
                      str(label),
                      size = min(boxy * 0.6,boxx*1),
                      halign = "center",
                      valign = "center",
                      font = "Liberation Sans:style=Bold"
                );
              }
            }
          }
        }
      }//union
          
  }}//transrotate
}

// a rhombus shaped stare box, but moved to a origin as a normal box  of same sice would be
module rhombbox(x,h){    
    newwidth=sqrt(x^2*2);
    //difference(){
    translate([x/2,-(newwidth-x)/2,0])rotate([0,0,45])cube([x,x,h]);
    // in case you do not believe the pill would fit, have a look
    //translate([x/2,x/2,0])cylinder(h=1, r=x/2);
   // }
}

// Create a cube with rounded eges along z
module roundedbox(size = [1, 1, 1], radius = 0.5) {

  if(radius == 0){
     cube(size);
  } else {
      
      // basically: create a hull around 4 round corner posts
      hull(){  
          translate([radius           , radius, 0])           cylinder(h=size[2], r= radius );
          translate([size[0] - radius , radius, 0])           cylinder(h=size[2], r= radius );
          translate([radius           , size[1] - radius, 0]) cylinder(h=size[2], r= radius );
          translate([size[0] - radius , size[1] - radius, 0]) cylinder(h=size[2], r= radius );
      }
  }
}


//cylinder with a circle crossing 3 points
module 3PCylinder(a,b,c,h){
    A=a[0]*(b[1]-c[1])-a[1]*(b[0]-c[0])+b[0]*c[1]-c[0]*b[1];
    B=(a[0]^2+a[1]^2)*(c[1]-b[1])      +(b[0]^2+b[1]^2)*(a[1]-c[1])      +(c[0]^2+c[1]^2)*(b[1]-a[1]);
    C=(a[0]^2+a[1]^2)*(b[0]-c[0])      +(b[0]^2+b[1]^2)*(c[0]-a[0])      +(c[0]^2+c[1]^2)*(a[0]-b[0]);
    D=(a[0]^2+a[1]^2)*(c[0]*b[1]-b[0]*c[1])+(b[0]^2+b[1]^2)*(a[0]*c[1]-c[0]*a[1])+(c[0]^2+c[1]^2)*(b[0]*a[1]-a[0]*b[1]);
    xm= -B/(2*A);
    ym= -C/(2*A);
    r=sqrt((B^2+C^2-4*A*D)/(4*A^2));
    translate([xm,ym]) cylinder(h=h, r=r);
}
