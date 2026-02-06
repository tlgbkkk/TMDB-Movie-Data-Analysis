#!/bin/bash
DATA_URL="https://raw.githubusercontent.com/yinghaoz1/tmdb-movie-dataset-analysis/master/tmdb-movies.csv"
INPUT_FILE="tmdb-movies.csv"
OUTPUT_FILE="movies_analysis.txt"
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
echo -e "\n"
{	
	echo Starting TMDB Movie Data Analysis

	echo -e "\n1. Sorting by date desc..."
	awk '
		NR == 1 { print $0; next }
		/^[0-9]/ {
			if (saved != "") print saved
			saved = $0
		}
		!/^[0-9]/ {
			saved = saved " " $0
		}
		END {
			if (saved != "") print saved
		}
	' "$INPUT_FILE" | awk '
		BEGIN { 
			FPAT = "([^,]*)|(\"([^\"]|\"\")*\")"
			OFS = "\t" 
		} 
		NR == 1 { print $0 }
		NR > 1 {	
			split($16, d, "/")
			epoch = mktime($19 " " d[1] " " d[2] " 00 00 00")
			print epoch, $0
		}
	' | (read -r header; echo "$header"; sort -t$'\t' -k1,1rn) | cut -f2- > "$OUTPUT_DATE"
	echo "Exported: $OUTPUT_DATE"



	echo -e "\n2. Filting movies with average rating above 7.5..."
	awk '
		BEGIN { FPAT = "([^,]*)|(\"([^\"]|\"\")*\")" }
		NR == 1 { print $0 }
		NR > 1 && $18 > 7.5 { print $0 }
	' "$OUTPUT_DATE" > "$OUTPUT_RATING"
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
	head -n 1 sorted_by_revenue.txt | awk -F$'\t' '{ print $2 "\nRevenue: " $1 "$"}'
	echo
	echo "Movie with lowest revenue: "
	tail -n 1 sorted_by_revenue.txt | awk -F$'\t' '{ print $2 "\nRevenue: " $1 "$"}'



	echo -e "\n4. Calculating total revenue of all movies..."
	awk '
		BEGIN {
			FS = "\t"
			TOTAL = 0	
		}
		{ TOTAL += $1 }
		END { print "Total revenue: " TOTAL "$"}
	' sorted_by_revenue.txt



	echo -e "\n5. Finding top 10 movies with highest revenue..."
	nl sorted_by_revenue.txt | head | awk -F$'\t' '{ print $1 ". " $3 " \t| Revenue: " $2 "$"}' | column -t -s $'\t'



	echo -e "\n6. Finding director and actor with the most movies..."
	awk -F',' '
		NR > 1 {
			n = split($9, dir_arr, "|")
			for (i = 1; i <= n; i++) 
				if (length(dir_arr[i]) > 0) 
					Dirs[dir_arr[i]]++
			n = split($7, act_arr, "|");
			for (i = 1; i <= n; i++)
				if (length(act_arr[i]) > 0)
					Acts[act_arr[i]]++
		}
		END {
			max_d_films = 0
			top_d_name = ""
			for (d in Dirs)
				if (Dirs[d] > max_d_films){
					max_d_films = Dirs[d]
					top_d_name = d
				}

			max_a_films = 0
			top_a_name = ""
			for (a in Acts)
				if (Acts[a] > max_a_films){
					max_a_films = Acts[a]
					top_a_name = a
				}
			printf "Director w the most movies: %s (%d movies)\n", top_d_name, max_d_films
			printf "Actors w the most movies: %s (%d movies)\n", top_a_name, max_a_films
		}
	' "$OUTPUT_DATE"



	echo -e "\n7. Calculating the number of movies for each genre..."
	awk '
		BEGIN { FPAT = "([^,]*)|(\"([^\"]|\"\")*\")" }
		NR > 1 {
			n = split($14, genre_arr, "|")
			for (i = 1; i <= n; i++)
				if (length(genre_arr[i]) > 0)
					Genres[genre_arr[i]]++
		}
		END {
			for (g in Genres)
				print g "\t" Genres[g]
		}
	' "$OUTPUT_DATE" | sort -t$'\t' -k2,2rn | column -t -s $'\t' | nl



	rm sorted_by_revenue.txt
	echo -e "\n\nDONE."
	echo -e "Output Analysis Files: " $OUTPUT_DATE ", " $OUTPUT_RATING
} | tee "$OUTPUT_FILE"
echo -e "\nFull of this analysis at: " $OUTPUT_FILE
exit 0
