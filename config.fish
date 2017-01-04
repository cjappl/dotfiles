#######################################################################
# CJAPPL fish_config 
#######################################################################
#                        .OO
#                       .OOOO
#                      .OOOO'
#                      OOOO'          .-~~~~-.
#                      OOO'          /   (o)(o)
#              .OOOOOO `O .OOOOOOO. /      .. |
#          .OOOOOOOOOOOO OOOOOOOOOO/\    \____/
#        .OOOOOOOOOOOOOOOOOOOOOOOO/ \\   ,\_/
#       .OOOOOOO%%OOOOOOOOOOOOO(#/\     /.
#      .OOOOOO%%%OOOOOOOOOOOOOOO\ \\  \/OO.
#     .OOOOO%%%%OOOOOOOOOOOOOOOOO\   \/OOOO.
#     OOOOO%%%%OOOOOOOOOOOOOOOOOOO\_\/\OOOOO
#     OOOOO%%%OOOOOOOOOOOOOOOOOOOOO\###)OOOO
#     OOOOOO%%OOOOOOOOOOOOOOOOOOOOOOOOOOOOOO
#     OOOOOOO%OOOOOOOOOOOOOOOOOOOOOOOOOOOOOO
#     `OOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO'
#   .-~~\OOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO'
#  / _/  `\(#\OOOOOOOOOOOOOOOOOOOOOOOOOOOO'
# / / \  / `~~\OOOOOOOOOOOOOOOOOOOOOOOOOO'
#|/'  `\//  \\ \OOOOOOOOOOOOOOOOOOOOOOOO'
#       `-.__\_,\OOOOOOOOOOOOOOOOOOOOO'
#           `OO\#)OOOOOOOOOOOOOOOOOOO'
#             `OOOOOOOOO''OOOOOOOOO'
#               `""""""'  `""""""'
#######################################################################

#######################################################################
# => Environment variables
#######################################################################

# remote logins (ssh)
set SHREDDER root@10.202.19.23

# PATHS (cd)
set LEGACY ~/Documents/Code/First_workspace/depot/qa/tests/products/DCinema/main # Dcinema legacy area
set ETMS ~/Documents/Code/ETMS/cineops # ETMS
set NBA ~/Documents/Code/personal/nbabets/
set WEBUI ~/Documents/Code/First_workspace/depot/qa/dcinema/
set AGENT /Volumes/projects/BuildsArea/InternalBuilds/Cinema/D-Cinema/CineOps/
set CBUILDS /Volumes/projects/BuildsArea/InternalBuilds/Cinema/D-Cinema/

#######################################################################
# => Aliases and functions
#######################################################################

alias ccadd "ccollab addchangelist new" # add new changelist
# alias clear_db "/Users/cjappl/Documents/Code/ETMS/cineops/ops/dockerfile/solr-pub/solr-data/seed-db --db-url http://cjappl-cineops-db.eng.dolby.net:8983/solr/cineops --delete-all"

# grep for python files recursively from dir and lower
function greppy -a pattern dir
    grep $pattern -nr --include \*.py $dir 
end

# tar function 
function tar -a dir
    /usr/bin/tar xfv $dir 
end

function forecast_for -a city
    curl wttr.in/$city
end

alias .1 "cd .." 
alias .2 "cd ../.." 
alias .3 "cd ../../.." 
alias .4 "cd ../../../.." 
alias .5 "cd ../../../../.." 
alias .6 "cd ../../../../../.." 

# finding my ip address
alias ip_addr "ifconfig en0 inet | grep inet"
