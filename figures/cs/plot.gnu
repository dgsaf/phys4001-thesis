set terminal epslatex input color solid size 6, 4

# parameters
n_plots = 6

array arr_n[n_plots]
arr_n[1] = 20
arr_n[2] = 25
arr_n[3] = 30
arr_n[4] = 35
arr_n[5] = 40
arr_n[6] = 50

c_min = 2

array arr_c_max[n_plots]
arr_c_max[1] = 6
arr_c_max[2] = 6
arr_c_max[3] = 6
arr_c_max[4] = 5
arr_c_max[5] = 5
arr_c_max[6] = 4

# data files
data_pecs(ic) = sprintf("pecs/pecs_%isks.dat", ic)
data_ccc(ic, c, n) = sprintf("%i/%i_%i/tiecs_%isks.dat", n, c, n, ic)

# style
set palette defined (0 "blue" , 1 "red")
unset colorbox

n_lt = 2
if (n_lt > 1) {
  do for [i = 1:n_lt] {
    set linetype i \
      lc palette frac ((i - 1.0) / (n_lt - 1.0)) \
      ps 0.5
    }
} else {
  set linetype 1 lc palette frac 0.0 ps 0.5
}
set linetype cycle n_lt
set style data linespoints

set xrange [0:500]
set yrange [0:0.05]

set xlabel "\\footnotesize Projectile Electron Energy [eV]"
set ylabel "\\footnotesize Cross Section [a.u.]" \
  offset 4, 0

set format x "\\scriptsize %.0f"
set format y "\\scriptsize %.4f"

set mxtics 4
set mytics 2
set grid xtics ytics mxtics mytics

set key top right box opaque samplen 1 spacing 0.6 width -16.0 height 0.5
key_pecs(ic) = sprintf("\\tiny PECS %isks", ic)
key_ccc(ic, c, n) = sprintf(\
"\\tiny $\\mathrm{CCC}\\lr{%i, %i, 0.50}$ %isks", c, n, ic)
key_scaled(str, k) = sprintf("%s ($\\times %i$)", str, k)

title_plot(n) = sprintf("${}^{1}\\mathrm{S}_{0}$ TICS ($N = %i$)", n)

# plot parameter
scale = 10

# plots
do for [i=1:n_plots] {
  c = arr_c_max[i]
  n = arr_n[i]

  # # output file
  str_fig = sprintf("%i/figure.tex", n)
  set output str_fig

  # plot
  set title title_plot(n) \
    offset 0, -0.5

  plot \
    data_pecs(1) \
      u 1:2 ls 1 lc rgb "black" t key_pecs(1), \
    data_ccc(1, c, n) \
      u 1:2 ls 1 t key_ccc(1, c, n), \
    data_pecs(2) \
      u 1:(scale*$2) ls 2 lc rgb "black" t key_scaled(key_pecs(2), scale), \
    data_ccc(2, c, n) \
      u 1:(scale*$2) ls 2 t key_scaled(key_ccc(2, c, n), scale)

  # # tex file
  set output
  str_find = sprintf('\includegraphics{%i/figure}', n)
  str_repl = sprintf('\includegraphics{figures/cs/%i/figure}', n)
  system "sed -i 's|".str_find."|".str_repl."|' ".str_fig
}
