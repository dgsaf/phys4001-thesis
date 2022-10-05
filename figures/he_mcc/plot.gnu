set terminal epslatex input color solid size 6, 4.25


# parameters ------------------------------------------------------------------

# `c` : core functions
# `n` : basis functions
c = 2
n = 35

# `in` : lowest energy electron state
in = 2


# utility functions -----------------------------------------------------------
dir_exists(dir) = int(system("[ -d '".dir."' ] && echo '1' || echo '0'"))
file_exists(file) = int(system("[ -f '".file."' ] && echo '1' || echo '0'"))


# derived parameters ----------------------------------------------------------

# calculation data files
data(n1, n2) = sprintf("%i_%i/%is%is.dat", c, n, n1, n2)

# output file
str_fig = sprintf("%i_%i/%is/figure.tex", c, n, in)
set output str_fig


# plot style ------------------------------------------------------------------

set xrange [*:*]
set yrange [0.5:1.0]
set xlabel "\\footnotesize Exponential Falloff Parameter"
set ylabel "\\footnotesize Major Configuration Coefficient"
set grid xtics ytics

set format x "\\scriptsize %.2f"
set format y "\\scriptsize %.1f"

set palette defined (0 "blue" , 1 "red")
unset colorbox
set key top right box opaque outside \
  samplen 1 spacing 0.6 width -5.0 height 0.5

if (n > 1) {
  do for [i = 1:n] {
    set linetype i \
    lc palette frac ((i - 1.0) / (n - 1.0)) \
    ps 0.5
  }
} else {
  set linetype 1 lc palette frac 0.0 ps 0.5
}
set linetype cycle n
set style data linespoints

# format key
key_state(n1, n2) = sprintf("\\tiny %is %is", n1, n2)


# plot ------------------------------------------------------------------------

set title sprintf("He State Major Configuration Coefficients")

plot \
  for [n1=in:in] for [n2=n1:n] \
    data(n1, n2) u 1:2 ls n2 t key_state(n1, n2)


# tex file ---------------------------------------------------------------------
set output

str_find = sprintf('\includegraphics{%i_%i/%is/figure}', c, n, in)
str_repl = sprintf('\includegraphics{figures/he_mcc/%i_%i/%is/figure}', c, n, in)
system "sed -i 's|".str_find."|".str_repl."|' ".str_fig