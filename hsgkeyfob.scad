include <MCAD/units/metric.scad>
use <MCAD/shapes/polyhole.scad>

rounding_r = 5;
thickness = 1;

length = 39.5;
ridge_width = 1;
ridge_height = 2;

keyhole_d = 5;
keyhole_pos = [5, length - 5];

$fa = 1;
$fs = 0.5;

function hypotenuse (l) = sqrt (l * l + l * l);

module stars ()
translate ([0, 11.5])
import ("hsg.dxf", layer="everything");

module inner_shell (w)
{
    difference () {
        children ();

        offset (-w)
        children ();
    }
}

module base ()
hull () {
    translate ([0, length])
    mirror (Y)
    square ([epsilon, epsilon], center=true);

    translate ([rounding_r, rounding_r])
    circle (r=rounding_r);

    translate ([length - rounding_r, rounding_r])
    circle (r=rounding_r);

    translate ([length - rounding_r, length - rounding_r])
    circle (r=rounding_r);
}

module hole ()
translate (keyhole_pos)
polyhole (d=5, h=-1);

module smoothen (r)
offset (-r, join_type="round")
offset (r, join_type="round")
offset (r, join_type="round")
offset (-r, join_type="round")
children ();

color ("red") {
    linear_extrude (height=thickness)
    difference () {
        base ();

        smoothen (r=0.2)
        stars ();

        hole ();
    }

    // ridge
    linear_extrude (height=ridge_height)
    inner_shell (ridge_width)
    base ();

    // keyhole collar

    linear_extrude (height=ridge_height)
    intersection () {
        base ();

        difference () {
            translate ([0, length])
            circle (r=hypotenuse (keyhole_pos[0] + keyhole_d / 2));

            hole ();
        }
    }
}
