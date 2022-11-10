# set terminal epslatex input color solid size 6, 4.25

# output: directory
str_dir = "figures/pcs"

# utility
get(file, r, c) = system('awk ''{if (NR == '.r.') print $'.c.'}'' '.file.'')
lgsc(x) = sgn(x) * log(abs(x) + 1)

# parameters
c = 2
n = 35

# derived parameters
data_he(k) = sprintf("%i_%i/he_state_%i.dat", c, n, k)
data_pcs(k) = sprintf("%i_%i/pcs_sorted_%i.dat", c, n, k)

#
array ks[136]
array kt[136]
is = 1
it = 1
do for [k = 1:136] {
  s = int(get(data_he(k), 1, 5))
  if (s == 0) {
    ks[is] = k
    is = is + 1
  } else {
    kt[it] = k
    it = it + 1
  }
}
ns = is - 1
nt = it - 1

# style: key
set key top right box opaque outside

# style: palette
set palette defined (0 "blue" , 1 "red")
unset colorbox

# style: line
m = ns
if (m > 1) {
  do for [i = 1:m] {
    set linetype i \
    lc palette frac ((i - 1.0) / (m - 1.0)) \
    ps 0.5
  }
} else {
  set linetype 1 lc palette frac 0.0 ps 0.5
}
set linetype cycle m
set style data linespoints


# plot: partial cross sections -------------------------------------------------

# style: key
# set key samplen 1 spacing 0.6 width -2.8 height 0.5

# style: axes, grid
# set xrange [0.40:0.65]
# set yrange [-3:1]
# set xlabel "\\footnotesize Exponential Falloff Parameter"
# set ylabel "\\footnotesize Energy [a.u.]"
# set format x "\\scriptsize %.2f"
# set format y "\\scriptsize %.1f"
# set grid xtics ytics

# style: title, key
# set title sprintf("${}^{1}S_{0}$ He Energy Spectrum")
key_state(k) = sprintf("\\tiny %i", k)

# output file
# str_base = sprintf("%i_%i/singlet/figure", c, n)
# str_tex = sprintf("%s.tex", str_base)
# set output str_tex

set view 100, 10
set xrange [0.40:0.65]
set yrange [0:*]
set zrange [0:0.002]
set ticslevel 0
do for [k = 1:ns] {
  splot data_pcs(ks[k]) u 1:2:3 w lines t key_state(k)
  pause -1
}

# tex file
# set output
# str_find = sprintf('\includegraphics{%s}', str_base)
# str_repl = sprintf('\includegraphics{%s/%s}', str_dir, str_base)
# system "sed -i 's|".str_find."|".str_repl."|' ".str_tex
