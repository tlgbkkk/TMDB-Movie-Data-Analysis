#!/bin/bash
awk '
	BEGIN { 
		FPAT = "([^,]*)|(\"([^\"]|\"\")*\")"; 
		OFS = "\t" 
	} 
	NR > 1 {
		gsub(/^"|"$/, "", $6);
		if ($5 != "" && $6 != ""){ print $5, $6 }
	}
' tmdb-movies.csv | sort -rn > sort_by_revenue.txt

echo "Movie with highest revenue: "
head -n 1 sort_by_revenue.txt | awk -F$'\t' '{ print $2 "\nRevenue: " $1 }'
echo ""
echo "Movie with lowest revenue: "
tail -n 1 sort_by_revenue.txt | awk -F$'\t' '{ print $2 "\nRevenue: " $1 }'

