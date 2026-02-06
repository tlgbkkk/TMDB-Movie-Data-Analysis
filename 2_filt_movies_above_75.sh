#!/bin/bash
awk '
	BEGIN { 
		FPAT = "([^,]*)|(\"([^\"]|\"\")*\")"; 
		OFS = "\t" 
	} 
	NR == 1 { print $0 }
	NR > 1 && $18 > 7.5 { print $0 }
' tmdb-movies.csv > movies_having_avg_rating_above_75.csv
