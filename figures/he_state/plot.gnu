set terminal epslatex input color solid size 6, 4.25

# output: directory
str_dir = "figures/he_state"

# utility
get(file, r, c) = system('awk ''{if (NR == '.r.') print $'.c.'}'' '.file.'')
lgsc(x) = sgn(x) * log(abs(x) + 1)

# parameters
c = 2
n = 35

# derived parameters
data(k) = sprintf("%i_%i/he_state_%i.dat", c, n, k)

#
array ks[136]
array kt[136]
is = 1
it = 1
do for [k = 1:136] {
  s = int(get(data(k), 1, 5))
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


# plot: singlet ----------------------------------------------------------------

# style: key
set key samplen 1 spacing 0.6 width -2.8 height 0.5

# style: axes, grid
set xrange [0.40:0.65]
set yrange [-3:1]
set xlabel "\\footnotesize Exponential Falloff Parameter"
set ylabel "\\footnotesize Energy [a.u.]"
set format x "\\scriptsize %.2f"
set format y "\\scriptsize %.1f"
set grid xtics ytics

# style: title, key
set title sprintf("${}^{1}S_{0}$ He Energy Spectrum")
key_state(k) = sprintf("\\tiny %i", k)

# output file
str_base = sprintf("%i_%i/singlet/figure", c, n)
str_tex = sprintf("%s.tex", str_base)
set output str_tex

plot \
  for [k = 1:ns] \
    data(ks[k]) u 1:3 ls k t key_state(k)

# tex file
set output
str_find = sprintf('\includegraphics{%s}', str_base)
str_repl = sprintf('\includegraphics{%s/%s}', str_dir, str_base)
system "sed -i 's|".str_find."|".str_repl."|' ".str_tex


# plot: triplet ----------------------------------------------------------------

# style: key
set key samplen 1 spacing 0.6 width -2.8 height 0.5

# style: axes, grid
set xrange [0.40:0.65]
set yrange [-3:1]
set xlabel "\\footnotesize Exponential Falloff Parameter"
set ylabel "\\footnotesize Energy [a.u.]"
set format x "\\scriptsize %.2f"
set format y "\\scriptsize %.1f"
set grid xtics ytics

# style: title, key
set title sprintf("${}^{3}S_{1}$ He Energy Spectrum")
key_state(k) = sprintf("\\tiny %i", k)

# output file
str_base = sprintf("%i_%i/triplet/figure", c, n)
str_tex = sprintf("%s.tex", str_base)
set output str_tex

plot \
  for [k = 1:nt] \
    data(kt[k]) u 1:3 ls k t key_state(k)

# tex file
set output
str_find = sprintf('\includegraphics{%s}', str_base)
str_repl = sprintf('\includegraphics{%s/%s}', str_dir, str_base)
system "sed -i 's|".str_find."|".str_repl."|' ".str_tex


# plot: singlet mixing ---------------------------------------------------------

# style: key
set key samplen 1 spacing 0.6 width -2.8 height 0.5

# style: axes, grid
set xrange [0.40:0.65]
set yrange [-1:0]
set xlabel "\\footnotesize Exponential Falloff Parameter"
set ylabel "\\footnotesize Energy [a.u.]"
set format x "\\scriptsize %.2f"
set format y "\\scriptsize %.1f"
set grid xtics ytics

# style: title, key
set title sprintf("${}^{1}S_{0}$ He Energy Spectrum - Mixing Region")
key_state(k) = sprintf("\\tiny %i", k)

# output file
str_base = sprintf("%i_%i/singlet_mixing/figure", c, n)
str_tex = sprintf("%s.tex", str_base)
set output str_tex

plot \
  for [k = 1:ns] \
    data(ks[k]) u 1:3 ls k t key_state(k)

# tex file
set output
str_find = sprintf('\includegraphics{%s}', str_base)
str_repl = sprintf('\includegraphics{%s/%s}', str_dir, str_base)
system "sed -i 's|".str_find."|".str_repl."|' ".str_tex
