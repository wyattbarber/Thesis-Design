include <helpers.scad>
include <params.scad>

translate([0, 0, conn_length])
rotate([0, 90, 0])
connector(conn_outer, connector_width, conn_length);

translate([connector_width + 5, 0, conn_length])
rotate([0, 90, 0])
connector(conn_outer, connector_width, conn_length);

translate([(connector_width + 5)*2, 0, conn_length])
rotate([0, 90, 0])
connector(conn_outer, connector_width, conn_length);