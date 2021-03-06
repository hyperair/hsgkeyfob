include <MCAD/units/metric.scad>
use <MCAD/shapes/polyhole.scad>

rounding_r = 5;
thickness = 2;

target_length = 30;

length = 40;
ridge_width = 1;
ridge_height = 0;

keyhole_d = 4;
keyhole_pos = [4, target_length - 4];

$fa = 1;
$fs = 0.5;

function hypotenuse (l) = sqrt (l * l + l * l);

module stars ()
scale (target_length / length)
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
scale (target_length / length)
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
circle (d=keyhole_d);

module smoothen (r)
smoothen_concave (r)
smoothen_convex (r)
children ();

module smoothen_concave (r)
offset (-r, join_type="round")
offset (r, join_type="round")
children ();

module smoothen_convex (r)
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
    smoothen_concave (r=0.2) {
        inner_shell (ridge_width)
        base ();

        // keyhole collar
        intersection () {
            base ();

            difference () {
                translate (keyhole_pos)
                circle (r=keyhole_d / 2 + ridge_width * 1.5);

                hole ();
            }
        }
    }
}
