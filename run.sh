#!/bin/bash
DATA_URL="https://raw.githubusercontent.com/yinghaoz1/tmdb-movie-dataset-analysis/master/tmdb-movies.csv"
INPUT_FILE="tmdb-movies.csv"
OUTPUT_DATE="sorted_by_date_desc.csv"
OUTPUT_RATING="movies_rating_above_75.csv"

if [ ! -f "$INPUT_FILE" ]
then
    echo "Downloading data..."
    curl -s -O $DATA_URL
    echo "Done: $INPUT_FILE"
else
    echo "Data found: $INPUT_FILE"
fi

echo -e "\n1. Sorting by date desc..."
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
' "$INPUT_FILE" | (read -r header; echo "$header"; sort -t$'\t' -k1,1rn) | cut -f2- > "$OUTPUT_DATE"
echo "Exported: $OUTPUT_DATE"



echo -e "\n2. Filting movies with average rating above 7.5..."
awk '
	BEGIN { 
		FPAT = "([^,]*)|(\"([^\"]|\"\")*\")"; 
		OFS = "\t" 
	} 
	NR == 1 { print $0 }
	NR > 1 && $18 > 7.5 { print $0 }
' "$INPUT_FILE" > "$OUTPUT_RATING"
echo "Exported: $OUTPUT_RATING"



echo -e "\n3. Finding highest revenue movie and lowest revenue movie..."
awk '
	BEGIN { 
		FPAT = "([^,]*)|(\"([^\"]|\"\")*\")"; 
		OFS = "\t" 
	} 
	NR > 1 {
		gsub(/^"|"$/, "", $6);
		if ($5 != "" && $6 != "") {
			print $5, $6 
		}
	}
' "$INPUT_FILE" | sort -rn > sorted_by_revenue.txt

echo "Movie with highest revenue: "
head -n 1 sorted_by_revenue.txt | awk -F$'\t' '{ print $2 "\nRevenue: " $1 }'
echo "Movie with lowest revenue: "
tail -n 1 sorted_by_revenue.txt | awk -F$'\t' '{ print $2 "\nRevenue: " $1 }'



echo -e "\n4. Calculating total revenue of all movies..."
awk '
	BEGIN {
		FS = "\t"
		TOTAL = 0	
	}
	{ TOTAL += $1 }
	END { print "Total revenue: " TOTAL }
' sorted_by_revenue.txt


