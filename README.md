# TMDB Movie Data Analysis 🎬

A robust Bash-based data processing pipeline designed to download, clean, and analyze thousands of movie records from the TMDB dataset.

## 🗝 Key Features
The script automates a comprehensive 7-step analysis workflow:

1.  **Data Cleaning & Sorting**: Handles complex CSV issues like multi-line rows, quotes inside quotes and then sorts the entire library by release date (newest first).
2.  **High-Rating Filter**: Automatically extracts "Must-Watch" movies with an average rating above 7.5.
3.  **Financial Insights**: Identifies the all-time highest and lowest revenue-generating movies.
4.  **Revenue Totals**: Calculates the gross accumulated revenue across the entire dataset.
5.  **Top 10 Rankings**: Generates a clean, formatted leaderboard of the top 10 most successful movies.
6.  **Talent Spotlight**: Scans the dataset to find the most prolific Director and Actor.
7.  **Genre Distribution**: Breaks down the movie count for every genre (Action, Drama, Comedy, etc.) with a frequency-sorted list.

## 📂 Project Structure

```text
.
├── run.sh                      # Start the Bash script (The Orchestrator)
├── tmdb-movies.csv             # Source dataset (Downloaded automatically)
├── sorted_by_date_desc.csv     # Output: Cleaned data sorted by date (Generated after run)
├── movies_rating_above_75.csv  # Output: Filtered top-rated movies (Generated after run)
├── movies_analysis.txt         # Output: Final analysis report & logs (Generated after run)
└── README.md                   # Project documentation
```

## 🛠 Set Up & Use

1.  **Clone** to your local environment.
2.  **Set execution permissions**:
    ```bash
    chmod +x movie_analysis.sh
    ```
3.  **Run the analysis**:
    ```bash
    ./run.sh
    ```

## 📂 Output Files
Upon successful execution, the following files will be generated:
* `sorted_by_date_desc.csv`: The cleaned dataset, organized by date.
* `movies_rating_above_75.csv`: A specialized list of critically acclaimed movies.
* `movies_analysis.txt`: A full text-based report and execution log.

## ⚙️ Configuration & Customization

The script is designed to be flexible. You can easily change the input and output file names by modifying the variables at the top of the `run.sh` file:

| Variable | Default Value | Description |
| :--- | :--- | :--- |
| `INPUT_FILE` | `tmdb-movies.csv` | The source dataset file name. |
| `OUTPUT_DATE` | `sorted_by_date_desc.csv` | Cleaned data sorted by release date. |
| `OUTPUT_RATING` | `movies_rating_above_75.csv` | Filtered list of top-rated movies. |
| `OUTPUT_REPORT` | `movies_analysis.txt` | The final summary report and logs. |

To use your own file names, simply open the script in any text editor and update these values in the configuration section.

## 📋 Requirements
* **Operating System**: Linux, macOS.
* **Shell**: Bash.
* **Utilities**: `awk`, `curl`, `sort`, `column`, `nl`.

## 📊 More Advanced Analysis Ideas

This project can be expanded with the following analytical modules to extract deeper insights from the TMDB dataset:

### 1. Financial Performance & ROI
* **Return on Investment (ROI)**: Determine the efficiency of movie investments by calculating the ratio `Revenue / Budget`. This helps highlight low-budget indie films that achieved massive global success.

### 2. The "Power Duo" Discovery (Director-Actor)
* **Collaboration Mapping**: Scan the `director` and `cast` columns simultaneously to find frequent partnerships. 
* **Dynamic Duos**: Identify which Director-Actor pairings result in the highest average movie ratings or the most significant box office returns (e.g., the Tim Burton & Johnny Depp effect).

### 3. Production Company Benchmarking
* **Studio Dominance**: Group data by `production_companies` to rank studios by total market share.
* **Quality vs. Quantity**: Compare major studios (Universal, Disney, Warner Bros) based on their average `vote_average` to see which company consistently produces the highest quality content.

### 4. Keyword & Tagline Word Cloud
* **Trend Spotting**: Perform a frequency analysis on the `keywords` column to visualize the most popular themes across different decades (e.g., the rise of "superhero" or "dystopia").
