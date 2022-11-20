set terminal epslatex input color solid size 6, 4.25

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

# singlet, triplet states
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

# configuration coefficients
array mc[70]
do for [is = 1:35] {
  mc[is] = sprintf("1s%is", is)
}
do for [is = 2:36] {
  mc[34 + is] = sprintf("2s%is", is)
}
mc_core(is) = (is <= 35) ? 1 : 2
mc_filter(a, b, x) = (a eq b) ? x : NaN

# style: palette
set palette defined (0 "blue" , 1 "red")
unset colorbox

# style: line
m = ns
if (m > 1) {
  do for [i = 1:m] {
    set linetype i \
      lc palette frac ((i - 1.0) / (m - 1.0)) \
      ps 0.5 \
      lw 2
  }
} else {
  set linetype 1 lc palette frac 0.0 ps 0.5
}
set linetype cycle m
set style data linespoints


# plot: partial cross sections -------------------------------------------------

# style: key
unset key
set datafile missing NaN

# style: axes, grid
set xrange [0.40:0.65]
set yrange [0:*]
set zrange [0:*]
set xtics 0.05
set mxtics 5
set grid xtics ytics ztics mxtics vertical
set xyplane at 0
set border 4095

set xlabel ""
set ylabel ""
set zlabel ""
set format x "\\scriptsize %.2f"
set format y ""
set format z "\\scriptsize {$%.1t \\times 10^{%T}$}"

set view 90, 0

# style: title, key
key_state(k) = sprintf("\\tiny %i", k)
title_state(k) = sprintf("$n = %i$", k)
title_plot = sprintf("\
$\\lrset{{}^{1}\\mathrm{S}_{0} \\to \\ket*{\\Phi_{n}^{\\lr{%i, %i}}}}$ \
Partial Cross Sections (Orthographic View)", c, n)

do for [k = 2:ns-1] {
  print k, ks[k]

  # output file
  str_base = sprintf("%i_%i/singlet/%i/figure", c, n, k)
  str_tex = sprintf("%s.tex", str_base)
  system sprintf("mkdir -p %s", str_base)
  set output str_tex

  set multiplot \
    title title_plot \
    layout 3,1 rowsfirst \
    margins 0.2, 0.8, 0.1, 0.9 \
    spacing 0, 0.075

  do for [ik=k-1:k+1] {
    # partial cross section
    set label title_state(ik) left at graph 1.05, graph 0, graph 0.5

    if (ik-k == 0) {
      set zlabel "\\footnotesize Cross Section [a.u.]" \
        rotate by 90 \
        offset -2, 0
    } else {
      set zlabel ""
    }

    if (ik-k == 1) {
      set xlabel "\\footnotesize Exponential Falloff Parameter" \
        offset 0, -1
    } else {
      set xlabel ""
    }

    splot data_pcs(ks[ik]) u 1:2:3 w lines
    unset label
  }

  unset multiplot

  # tex file
  set output
  str_find = sprintf('\includegraphics{%s}', str_base)
  str_repl = sprintf('\includegraphics{%s/%s}', str_dir, str_base)
  system "sed -i 's|".str_find."|".str_repl."|' ".str_tex

  # pause -1
}