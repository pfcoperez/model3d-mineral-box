cellL = 42;
cellH = 20;
nColumns = 5;
nRows = 5;
tilt = 30;
holderUnit = 5;

wallThickness = 1;
legsThickness = wallThickness*2;

outerCellL = cellL + wallThickness;
outerCellH = cellH + wallThickness;
outerW = outerCellL*(nColumns)+wallThickness;
outerL = outerCellL*(nRows)+wallThickness;

depth = outerL*cos(tilt);
legsH = outerL*sin(tilt);

echo(H=legsH)
echo(outerW = outerW);
echo(outerL = outerL);
echo(depth = depth);

module rows(n) {
    for(i = [0:1:n]) {
        translate([0, i*outerCellL, 0]) {
            cube([outerW, wallThickness, outerCellH]);
        }
    }
}

module columns(n) {
    for(i = [0:1:n]) {
        translate([i*outerCellL, 0, 0]) {
            cube([wallThickness, outerL, outerCellH]);
        }
    }
}

module bottomUnit() {
    linear_extrude(wallThickness) {
            polygon([[0,0], [holderUnit,0], [0,holderUnit]]);
    }
    translate([0, outerCellL, 0]) {
        linear_extrude(wallThickness) {
            polygon([[0,0], [holderUnit,0], [0,-holderUnit]]);
        }
    }
    translate([outerCellL, 0, 0]) {
        linear_extrude(wallThickness) {
            polygon([[-holderUnit,0], [0,holderUnit], [0,0]]);
        }
    }
    translate([outerCellL, outerCellL, 0]) {
        linear_extrude(wallThickness) {
            polygon([[0,0], [-holderUnit,0], [0,-holderUnit]]);
        }
    }
}

module bottom() {
    for(i = [0:1:nRows-1]) {
        for(j = [0:1:nColumns-1]) {
            translate([i*outerCellL, j*outerCellL, wallThickness]) {
                bottomUnit();
            }
        }
    }
}

//module bottom() {
//    cube([outerW, outerL, wallThickness]);
//}

module grid() {
    union() {
        rows(nRows);
        columns(nColumns);
        translate([0,0,-wallThickness]) {
            bottom();
        }
    }
}

module leg() {
    rotate([0, -90, 0]) {
    linear_extrude(legsThickness) {
           difference() {
               polygon([[0,0], [0,depth], [legsH,depth]]);
               polygon([[10,10], [10,depth-10], [legsH-10,depth-10]]);
           }
        }
    }
}

module beam() {
    cube([outerW, legsThickness, 10]);
}

module supports() {
    yFactor = 0;
    zFactor = 0;
    union() {
        translate([legsThickness, yFactor, zFactor]) {
            leg();
        }
        translate([outerW, yFactor, zFactor]) {
            leg();
        }
        translate([0,depth-legsThickness+yFactor, zFactor]) {
            beam();
        }
    }
}

module whole() {
    union() {
        rotate([tilt, 0, 0]) {
            grid();
        }
        supports();
    }
}

module wholeWithoutLegs() {
    grid();
} 

whole();
//wholeWithoutLegs();