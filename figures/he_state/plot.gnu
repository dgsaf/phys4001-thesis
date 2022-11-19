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
set xtics 0.05
set mxtics 5
set mytics 2
set grid xtics ytics mxtics mytics

# style: title, key
set title sprintf("${}^{1}\\mathrm{S}_{0}$ Helium Pseudoenergies \
$\\lrset{\\epsilon_{n}^{\\lr{2, 35}}}$")
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
set title sprintf("${}^{3}\\mathrm{S}_{1}$ Helium Pseudoenergies \
$\\lrset{\\epsilon_{n}^{\\lr{2, 35}}}$")
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
set title sprintf("${}^{1}\\mathrm{S}_{0}$ Helium Pseudoenergies \
$\\lrset{\\epsilon_{n}^{\\lr{2, 35}}}$ - Auto-Ionising Region")
key_state(k) = sprintf("\\tiny %i", k)

# output file
str_base = sprintf("%i_%i/singlet_mixing/figure", c, n)
str_tex = sprintf("%s.tex", str_base)
set output str_tex

set label "\\scriptsize 1s31s" at 0.405,-0.85 left
set label "\\scriptsize 1s30s" at 0.485,-0.85 left
set label "\\scriptsize 1s29s" at 0.555,-0.85 left

set label "\\scriptsize 1s31s" at 0.435,-0.65 left
set label "\\scriptsize 1s30s" at 0.515,-0.65 left
set label "\\scriptsize 1s29s" at 0.595,-0.65 left

set label "\\scriptsize 2s2s" at 0.402,-0.750 left
set label "\\scriptsize 2s2s" at 0.455,-0.750 left
set label "\\scriptsize 2s2s" at 0.535,-0.750 left
set label "\\scriptsize 2s2s" at 0.615,-0.750 left

set label "\\scriptsize 2s3s" at 0.405,-0.600 left
set label "\\scriptsize 2s3s" at 0.470,-0.600 left
set label "\\scriptsize 2s3s" at 0.550,-0.600 left
set label "\\scriptsize 2s3s" at 0.625,-0.600 left

plot \
  for [k = 1:ns] \
    data(ks[k]) u 1:3 ls k t key_state(k)

# tex file
set output
str_find = sprintf('\includegraphics{%s}', str_base)
str_repl = sprintf('\includegraphics{%s/%s}', str_dir, str_base)
system "sed -i 's|".str_find."|".str_repl."|' ".str_tex

# major configuration ----------------------------------------------------------
array mc[70]
do for [is = 1:35] {
  mc[is] = sprintf("1s%is", is)
}
do for [is = 2:36] {
  mc[34 + is] = sprintf("2s%is", is)
}
mc_core(is) = (is <= 35) ? 1 : 2
mc_filter(a, b, x) = (a eq b) ? x : NaN

set yrange [0.5:1]
# # view 1
# do for [is = 1:70] {
#   set title sprintf("%s MCC", mc[is])
#   plot for [ik = 1:ns] \
#     data(ks[ik]) u 1:(mc_filter(mc[is], stringcolumn(4), $2)) \
#     ls ik dashtype mc_core(is) t sprintf("%i", ik)
#   pause -1
# }
#
# # view 2
# do for [ik = 1:ns] {
#   set title sprintf("Singlet State %i", ik)
#   plot for [is = 1:70] \
#     data(ks[ik]) u 1:(mc_filter(mc[is], stringcolumn(4), $2)) \
#     ls (is) dashtype mc_core(is) t sprintf("%s", mc[is])
#   pause -1
# }
