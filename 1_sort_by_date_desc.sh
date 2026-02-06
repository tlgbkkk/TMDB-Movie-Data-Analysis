#!/bin/bash
awk '
	BEGIN { 
		FPAT = "([^,]*)|(\"([^\"]|\"\")*\")"; 
		OFS = "\t" 
	} 
	NR == 1 { print $0 }
	NR > 1 {
		split($16, d, "/");
		epoch = mktime($19 " " d[1] " " d[2] " 00 00 00");
		print epoch, $0
	}
' tmdb-movies.csv | (read -r header; echo "$header"; sort -t$'\t' -k1,1rn) | cut -f2- > sorted_by_date_desc.csv

