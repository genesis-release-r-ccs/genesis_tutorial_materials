# ===================================================
# PyMol script for creating a PNG image of mdAAA.pdb
# =================================================== 

delete trj
load ../1_makepdb/mdAAA.pdb, trj
load ../1_makepdb/md0.pdb, ref
delete ref

# Set view
width  = 480
height = 480
cmd.viewport(width, height)
bg_color white
set ray_shadow, off
set ray_opaque_background, on

set_view (\
     0.700811803,    0.321628720,   -0.636726499,\
    -0.506851256,    0.852599680,   -0.127194136,\
     0.501961410,    0.411864907,    0.760529041,\
    -0.000017758,   -0.000041828, -106.357391357,\
   -18.747209549,    0.224934518,   -8.418970108,\
    86.687660217,  126.027915955,   20.000000000 )

# Select group
select PROA, chain A
select PROB, chain B

# Set representation
show cartoon, PROA or PROB
show lines,   PROA or PROB

# Set color
color slate,  PROA
color salmon, PROB
util.cnc("all")

# Create PNG image
cmd.ray(width, height)
png mdBBB.png

