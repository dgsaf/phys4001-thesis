set terminal epslatex input color solid size 6, 4


# parameters ------------------------------------------------------------------

# `c_min` :
# `c_max` :
# `n` :
# `ic` : he+ state
c_min = 2
c_max = 4
n = 50
ic = 2


# utility functions -----------------------------------------------------------
dir_exists(dir) = int(system("[ -d '".dir."' ] && echo '1' || echo '0'"))
file_exists(file) = int(system("[ -f '".file."' ] && echo '1' || echo '0'"))


# derived parameters ----------------------------------------------------------

# associated pecs file (may or may not exist)
pecs_file = sprintf("pecs/pecs_%isks.dat", ic)

# calculation data files
data(c, n) = sprintf("%i/%i_%i/tiecs_%isks.dat", n, c, n, ic)

# number of calculations
n_calcs = c_max - c_min + 1

# output file
str_fig = sprintf("%i/figure.tex", n)
set output str_fig


# plot style ------------------------------------------------------------------

set xrange [0:500]
set yrange [0:0.0018]
set xlabel "\\footnotesize Incident Energy [eV]"
set ylabel "\\footnotesize Cross Section [a.u.]" \
  offset 4,0
set grid xtics ytics

set format x "\\scriptsize %.0f"
set format y "\\scriptsize %.4f"

set palette defined (0 "blue" , 1 "red")
unset colorbox
set key top right box opaque \
  samplen 1 spacing 0.6 width -6.5 height 0.5

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
title_PECS = "\\tiny PECS"
title_CN(c, n) = sprintf("\\tiny CCC(%i, %i)", c, n)


# plot ------------------------------------------------------------------------

set title sprintf("$1^{1}$S $\\to$ %isks", ic) \
  offset 0, -0.5

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

str_find = sprintf('\includegraphics{%i/figure}', n)
str_repl = sprintf('\includegraphics{figures/cs_tics_ie_n/%i/figure}', n)
system "sed -i 's|".str_find."|".str_repl."|' ".str_fig