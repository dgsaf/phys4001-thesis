set terminal epslatex input color solid


# parameters ------------------------------------------------------------------


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
pecs_file = sprintf("pecs_%isks.dat", ic)

# calculation data files
data(c, n) = sprintf("%i_%i/tiecs_%isks.dat", c, n, ic)

# output file
set output "figure.tex"

# number of calculations
n_calcs = c_max - c_min + 1

# plot style ------------------------------------------------------------------

set xrange [0:500]
set yrange [0:*]
set xlabel "Incident Energy [eV]"
set ylabel "Cross Section [a.u.]"
set grid xtics ytics

set format x "\\scriptsize %.0f"
set format y "\\scriptsize %.4f"

set palette defined (0 "blue" , 1 "red")
unset colorbox
set key top right box opaque \
  samplen 1 spacing 0.8 width -5.5

if (n_calcs > 1) {
  do for [i = 1:n_calcs] {
    set linetype i \
    lc palette frac ((i - 1.0) / (n_calcs - 1.0)) \
    ps 0.75
  }
} else {
  set linetype 1 lc palette frac 0.0 ps 0.75
}
set linetype cycle n_calcs
set style data linespoints

# format calc title
title_PECS = "\\scriptsize PECS"
title_CN(c, n) = sprintf("\\scriptsize CCC(%i, %i)", c, n)


# plot ------------------------------------------------------------------------

set title sprintf("$1^{1}$S $\\to$ %isks", ic)

if (file_exists(pecs_file)) {
  plot \
    pecs_file u 1:2 ls 1 lc rgb "black" t title_PECS, \
    for [i=1:n_calcs] \
      c = c_min + i - 1 \
      data(c, n) u 1:2 ls i t title_CN(c, n)
} else {
  plot \
    for [i=1:n_calcs] \
      c = c_min + i - 1 \
      data(c, n) u 1:2 ls i t title_CN(c, n)
}
# pause -1

# tex file ---------------------------------------------------------------------
set output
!sed -i \
  's|\includegraphics{figure}|\includegraphics{figures/cs_tics_ie_20/figure}|' \
  figure.tex