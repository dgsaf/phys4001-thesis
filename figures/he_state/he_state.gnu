# set terminal png size 1800, 1080
# set output "energy_singlet_mixing.png"

# utility
get(file, r, c) = system('awk ''{if (NR == '.r.') print $'.c.'}'' '.file.'')

# parameters
dir_top = "/home/tom/Dropbox/university/2021_1/phyiscs_honours_dissertation_1/magnus_backup"
dir_falloff = sprintf("%s/falloff", dir_top)
lgsc(x) = sgn(x) * log(abs(x) + 1)
c = 2
n = 35

# derived parameters
data(k) = sprintf("%s/he_state_%i.dat", dir_falloff, k)

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

# print "singlet"
# do for [k = 1:ns] {
#   print sprintf("%i => %i", k, ks[k])
# }
# print "triplet"
# do for [k = 1:nt] {
#   print sprintf("%i => %i", k, kt[k])
# }

# plot style
set xrange [0.40:0.65]
set yrange [-1:0]
set xlabel "Exponential Falloff Parameter"
set ylabel "Energy [a.u.]"
set grid xtics ytics
set palette defined (0 "blue" , 1 "red")
unset colorbox
set key top right box opaque outside

# line style
m = ns
if (m > 1) {
  do for [i = 1:m] {
    set linetype i \
    lc palette frac ((i - 1.0) / (m - 1.0)) \
    ps 0.75
  }
} else {
  set linetype 1 lc palette frac 0.0 ps 0.5
}
set linetype cycle m
set style data linespoints

#
set title sprintf("Singlet Helium State Energies")
plot \
  for [k = 1:ns] \
    data(ks[k]) u 1:3 ls k t sprintf("%i (%i)", k, ks[k])
    # data(ks[k]) u 1:(lgsc($3)) ls k t sprintf("%i", k)
pause -1
