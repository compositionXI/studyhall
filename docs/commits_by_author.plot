set terminal png transparent size 640,240
set size 1.0,1.0

set terminal png transparent size 640,480
set output 'commits_by_author.png'
set key left top
set xdata time
set timefmt "%s"
set format x "%Y-%m-%d"
set grid y
set ylabel "Commits"
set xtics rotate
set bmargin 6
plot 'commits_by_author.dat' using 1:2 title "Jake Mauer" w lines, 'commits_by_author.dat' using 1:3 title "Brent Collier" w lines, 'commits_by_author.dat' using 1:4 title "Joe Hunt" w lines, 'commits_by_author.dat' using 1:5 title "Ian Yang" w lines, 'commits_by_author.dat' using 1:6 title "Peter Jackson" w lines, 'commits_by_author.dat' using 1:7 title "yincan" w lines, 'commits_by_author.dat' using 1:8 title "Intridea" w lines
