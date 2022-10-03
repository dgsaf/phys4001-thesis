# set terminal png size 1000, 800
# set output "ie_XX.png"


# parameters ------------------------------------------------------------------

# `dir_plot` : directory for plots
dir_plot = system("dirname ".ARG0)


# arguments -------------------------------------------------------------------

# `c_min` :
# `c_max` :
# `n` :
# `ic` : he+ state
c_min = 2
c_max = 6
n = 20
ic = 2

# utility functions -----------------------------------------------------------
dir_exists(dir) = int(system("[ -d '".dir."' ] && echo '1' || echo '0'"))
file_exists(file) = int(system("[ -f '".file."' ] && echo '1' || echo '0'"))


# derived parameters ----------------------------------------------------------

# associated pecs file (may or may not exist)
pecs_file = sprintf("%s/pecs_%isks.dat", dir_plot, ic)

# calculation data files
data(c, n) = sprintf("%s/%i_%i/tiecs_%isks.dat", dir_plot, c, n, ic)

# format calc title
format_CN(c, n) = sprintf("CCC(%i, %i)", c, n)

n_calcs = c_max - c_min + 1

# plot style ------------------------------------------------------------------

set xrange [0:500]
# set yrange [0:0.0018]
set yrange [0:*]
set xlabel "Incident Energy [eV]"
set ylabel "Cross Section [a.u.]"
# set grid xtics ytics

set palette defined (0 "blue" , 1 "red")
unset colorbox
set key top right box opaque

if (n_calcs > 1) {
  do for [i = 1:n_calcs] {
    set linetype i \
    lc palette frac ((i - 1.0) / (n_calcs - 1.0)) \
    ps 0.5
  }
} else {
  set linetype 1 lc palette frac 0.0 ps 0.5
}
set linetype cycle n_calcs
set style data linespoints


# plot ------------------------------------------------------------------------

set title sprintf("1^{1}S -> %isks", ic)

if (file_exists(pecs_file)) {
  plot \
    pecs_file u 1:2 ls 1 lc rgb "black" t "PECS", \
    for [i=1:n_calcs] \
      c = c_min + i - 1 \
      data(c, n) u 1:2 ls i t format_CN(c, n)
} else {
  plot \
    for [i=1:n_calcs] \
      c = c_min + i - 1 \
      data(c, n) u 1:2 ls i t format_CN(c, n)
}
pause -1
