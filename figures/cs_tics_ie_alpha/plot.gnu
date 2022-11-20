set terminal epslatex input color solid size 6, 4

# figure directory
str_dir = "figures/cs_tics_ie_alpha"

# parameters
c = 2
n = 35

n_alpha = 26
array arr_alpha[n_alpha]
do for [i=1:n_alpha] {
  arr_alpha[i] = 0.40 + (0.01 * (i - 1))
}

# data files
data_pecs(ic) = sprintf("pecs/pecs_%isks.dat", ic)
data_ccc(ic, alpha) = sprintf(\
"%i_%i/%i_%i_%.2f/tiecs_%isks.dat", c, n, c, n, alpha, ic)

# style
set palette defined (0 "blue" , 1 "red")
unset colorbox

n_lt = n_alpha
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
set yrange [0:0.003]

set xlabel "\\footnotesize Projectile Electron Energy [eV]"
set ylabel "\\footnotesize Cross Section [a.u.]" \
  offset 4, 0

set format x "\\scriptsize %.0f"
set format y "\\scriptsize %.4f"

set mxtics 4
set mytics 2
set grid xtics ytics mxtics mytics

set key top right box opaque samplen 1 spacing 0.6 width -10.0 height 0.5
key_pecs(ic) = sprintf("\\tiny PECS")
key_ccc(ic, alpha) = sprintf(\
"\\tiny $\\mathrm{CCC}\\lr{%i, %i, %.2f}$", c, n, alpha)

title_plot(c, n) = sprintf(\
"${}^{1}\\mathrm{S}_{0} \\to \\mathrm{2sks}$ TICS ($C = %i$, $N = %i$)", c, n)

# output file
str_base = sprintf("%i_%i/figure", c, n)
str_tex = sprintf("%s.tex", str_base)
# system sprintf("mkdir -p %s", str_base)
set output str_tex

# plot
set title title_plot(c, n) \
  offset 0, -0.5

plot \
  data_pecs(2) \
    u 1:2 ls 1 lc rgb "black" t key_pecs(2), \
  for [i=1:n_alpha] data_ccc(2, arr_alpha[i]) \
    u 1:2 ls i t key_ccc(2, arr_alpha[i])

# tex file
set output
str_find = sprintf('\includegraphics{%s}', str_base)
str_repl = sprintf('\includegraphics{%s/%s}', str_dir, str_base)
system "sed -i 's|".str_find."|".str_repl."|' ".str_tex
