import sys
import os
import subprocess



BASE_URL = "https://www.football-data.co.uk/mmz4281"

# Common division codes
DIVISIONS = {
    # England
    "E0": "Premier League",
    "E1": "Championship",
    "E2": "League One",
    "E3": "League Two",
    # Germany
    "D1": "Bundesliga 1",
    "D2": "Bundesliga 2",
    # Spain
    "SP1": "La Liga",
    "SP2": "La Liga 2",
    # Italy
    "I1": "Serie A",
    "I2": "Serie B",
    # France
    "F1": "Ligue 1",
    "F2": "Ligue 2",
    # Netherlands
    "N1": "Eredivisie",
    # Scotland
    "SC0": "Scottish Premiership",
}



# ── Helpers ───────────────────────────────────────────────────────────────────
 
def season_code(start_year: int) -> str:
    """ removes last two digits from a given year to create the season period
        website source formats urls using the season period which straddles two years
        2023 → 23 -> "2324"
        2020 → 20 -> "2021"
    """
    y1 = str(start_year)[-2:]           
    y2 = str(start_year + 1)[-2:]       
    return f"{y1}{y2}"


def build_url(season_start: int, division: str) -> str:
    code = season_code(season_start)
    return f"{BASE_URL}/{code}/{division}.csv"


def download(url: str, output_path: str, verbose: bool = True) -> bool:
    """Run curl to download *url* and save it to *output_path*.
 
    Returns True on success, False on failure.
    """
    cmd = [
        "curl",
        "--silent" if not verbose else "--progress-bar",
        "--fail",           # non-zero exit on HTTP errors (4xx / 5xx)
        "--location",       # follow redirects
        "--output", output_path,
        url,
    ]
 
    if verbose:
        print(f"  curl {url}")
 
    result = subprocess.run(cmd)
 
    if result.returncode != 0:
        print(f"  [ERROR] curl exited with code {result.returncode} for {url}")
        
        # file clean up after an error
        if os.path.exists(output_path) and os.path.getsize(output_path) == 0:
            os.remove(output_path)
        return False
 
    size_kb = os.path.getsize(output_path) / 1024
    print(f"  [OK] Saved → {output_path}  ({size_kb:.1f} KB)")
    return True



# ── Main downloader ───────────────────────────────────────────────────────────
 
def download_dataset(
    season_start: int,
    division: str = "E0",
    output_dir: str = "football_data",
) -> str | None:
    """Download a single season/division CSV.
 
    Args:
        season_start: The year the season starts (e.g. 2023 for 2023/24).
        division:     Division code (e.g. "E0" for Premier League).
        output_dir:   Local folder where the file is saved.
 
    Returns:
        Path to the downloaded file, or None on failure.
    """
    os.makedirs(output_dir, exist_ok=True)

    url = build_url(season_start, division)
    filename = f"{season_code(season_start)}_{division}.csv"
    output_path = os.path.join(output_dir, filename)

    league_name = DIVISIONS.get(division, division)
    print(f"\nDownloading {league_name} — {season_start}/{str(season_start+1)[-2:]}")
 
    success = download(url, output_path)
    return output_path if success else None
 

def download_multiple(
    seasons: list[int],
    divisions: list[str],
    output_dir: str = "fdata",
    ) -> list[str]:
    """
    Download several season/division combinations.

    Returns a list of successfully downloaded file paths.
    """

    downloaded = []
    total = len(seasons) * len(divisions)
    print(f"Downloading {total} file(s) to '{output_dir}/'…")

    for season in seasons:
        for div in divisions:
            
            path = download_dataset(season, div, output_dir)
            if path:
                downloaded.append(path)
 
    print(f"\n✓ {len(downloaded)}/{total} files downloaded successfully.")
    return downloaded



# ── Entry point ───────────────────────────────────────────────────────────────

if __name__ == "__main__":

    # ── APIs  ────────────────────────────────────────
    SEASONS   = [2020, 2021]          # season start years
    LEAGUES   = ["E0"]          # division codes (see dict above)
    OUTPUT    = "data"       # local output folder
    # ─────────────────────────────────────────────────────────────────────────
 
    files = download_multiple(SEASONS, LEAGUES, OUTPUT)
 
    if not files:
        print("No files were downloaded. Check your season/division codes.")
        sys.exit(1)
 
    print("\nDownloaded files:")
    for f in files:
        print(f"  {f}")


""" 
TODO

pipeline_fetch.py -> cli tool

"""
