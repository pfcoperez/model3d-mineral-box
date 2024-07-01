l=40;
h=10;
r=1;
dFactor=4;

$fn=25;

cube([l, l, 1]);

translate([l/2, l/4, 0]) {
    cylinder(h, r);
}

translate([l/dFactor, l/3, 0]) {
    cylinder(h, r);
}

translate([(dFactor-1)*l/dFactor, l/3, 0]) {
    cylinder(h, r);
}