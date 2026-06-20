import drawsvg as draw
import argparse
import math


parser = argparse.ArgumentParser("grasper drawer", 
                               description="draws a base template for a laser cut flexible coil.\
                                Does not draw the flex hinge pattern, that must be manually overlaid."
                               )
parser.add_argument(
    "--length", 
    type=float,
    required=True,
    help="Total length, along the diagonal center line, of the grasper [mm]."
)
parser.add_argument(
    "--width",
    type=float,
    required=True,
    help="Width of the grapser [mm]."
)
parser.add_argument(
    "--angle",
    type=float,
    required=False,
    default=45.0,
    help="Angle of the device, measured between the width axis and the diagonal lenght axis [degrees]."
)
parser.add_argument(
    "--mount",
    type=float,
    required=False,
    help="Space between mounting holes along the width, defaults to half the width [mm]"
)
parser.add_argument(
    "--diam",
    type=float,
    required=False,
    help="Diameter of the cable guide mount holes. Default is one eighth the width [mm]."
)
parser.add_argument(
    "--n",
    type=int,
    required=False,
    default=8,
    help="Number of mounting holes to place for cable guides."
)
parser.add_argument(
    "--guide-diam",
    type=float,
    required=False,
    default=1.0,
    help="Diameter of cable guide holes [mm]."
)
parser.add_argument(
    "--thickness",
    type=float,
    required=True,
    help="Material thickness [mm]."
)
parser.add_argument(
    "--guide-height",
    type=float,
    required=False,
    help="Cable guide height, defaults to thrice the material thickness [mm]."
)

args = parser.parse_args()


# Load parameters and initialize document
h = args.length
w = args.width
theta = args.angle * math.pi / 180.0
n = args.n
mount = w / 2.0
if hasattr(args, "mount") and not (args.mount is None):
    mount = args.mount
diam = w / 8.0
if hasattr(args, "diam") and not (args.diam is None):
    diam = args.diam
t = args.thickness
b = t * 3.0
if hasattr(args, "guide_height") and not (args.guide_height is None):
    b = args.guide_height
c = args.guide_diam / 2.0


doc = draw.Drawing(
    width=w + h*math.cos(theta),
    height= h*math.sin(theta)
)
# doc.set_pixel_scale(

# )

# Draw base polygon outline
p0 = [0, 0]
p1 = [w, 0]
p2 = [h*math.cos(theta) + w, h*math.sin(theta)]
p3 = [h*math.cos(theta), h*math.sin(theta)]
doc.append(draw.Lines(
    *p0,
    *p1,
    *p2,
    *p3,
    close=True,
    fill="none",
    stroke="black",
    stroke_width=1
))

# Draw mount holes
d = h / (n+1)
for i in range(n):
    ri = [
        (d * (i+1) * math.cos(theta)) + (w / 2.0),
        d * (i+1) * math.sin(theta)
    ]
    mr = draw.Circle(
        ri[0] + mount/2.0,
        ri[1],
        diam / 2.0,
        fill="none",
        stroke="black",
        stroke_width=1
    )
    ml = draw.Circle(
        ri[0] - mount/2.0,
        ri[1],
        diam / 2.0,
        fill="none",
        stroke="black",
        stroke_width=1
    )
    doc.extend([mr, ml])


# Save coil drawing
doc.save_svg(
    "coil.svg"
)


# Draw wire guides in separate document
doc2 = draw.Drawing(
    width=1000,
    height=1000
)

def _draw_guide(offset):
    alpha = 60 * math.pi / 180.0
    z = 2
    a = (mount + diam) - (4 * b / math.tan(alpha))

    p0 = [offset[0], offset[1]]
    p1 = [
        p0[0],
        p0[1] + t + z
    ]
    p2 = [
        p1[0] + b / math.tan(alpha),
        p1[1] + b
    ]
    p3 = [
        p2[0] + b / math.tan(alpha),
        p2[1] - b
    ]
    p4 = [
        p3[0] + a,
        p3[1]
    ]
    p5 = [
        p4[0] + b / math.tan(alpha),
        p4[1] + b
    ]
    p6 = [
        p5[0] + b / math.tan(alpha),
        p5[1] - b
    ]
    p7 = [
        p6[0],
        p6[1] - t - z
    ]
    p8 = [
        p7[0] - diam,
        p7[1]
    ]
    p9 = [
        p8[0],
        p8[1] + t
    ]
    p10 = [
        p9[0] - (mount - diam),
        p9[1]
    ]
    p11 = [
        p10[0],
        p10[1] - t
    ]

    poly = draw.Lines(
        *p0,
        *p1,
        *p2,
        *p3,
        *p4,
        *p5,
        *p6,
        *p7,
        *p8,
        *p9,
        *p10,
        *p11,
        close=True,
        fill="none",
        stroke="black",
        stroke_width=1
    )

    gr = [
        p5[0],
        p5[1] - b / 2.0
    ]
    gl = [
        p2[0],
        p2[1] - b / 2.0
    ]

    circle1 = draw.Circle(
        gr[0], gr[1],
        c,
        fill="none",
        stroke="black",
        stroke_width=1
    )

    circle2 = draw.Circle(
        gl[0], gl[1],
        c,
        fill="none",
        stroke="black",
        stroke_width=1
    )

    return (poly, circle1, circle2)


for i in range(n):
    u = (mount + diam) * 2
    v = (t + b) * 2
    doc2.extend(
        _draw_guide([(i // 2) * u, i % 2 * v])
    )

doc2.save_svg("guides.svg")
