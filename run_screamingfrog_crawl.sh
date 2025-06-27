#!/bin/bash

# This script runs a Screaming Frog SEO Spider crawl and exports all possible data.

# Usage: ./run_screamingfrog_crawl.sh <URL_TO_CRAWL>

if [ -z "$1" ]; then
    echo "Usage: $0 <URL_TO_CRAWL>"
    exit 1
fi

URL_TO_CRAWL=$1
OUTPUT_DIR="/home/autogpt/sfScripts/screamingfrog_output/"

# IMPORTANT: Replace with the actual path to your Screaming Frog CLI executable
# For Linux, it might be 'screamingfrogseospider' if it's in your PATH, or a full path like '/opt/screamingfrogseospider/ScreamingFrogSEOSpiderCli'
# For macOS: /Applications/Screaming\ Frog\ SEO\ Spider.app/Contents/MacOS/ScreamingFrogSEOSpiderLauncher
# For Windows: "C:\Program Files (x86)\Screaming Frog SEO Spider\ScreamingFrogSEOSpiderCli.exe"
SCREAMING_FROG_CLI="screamingfrogseospider" # Assuming it's in PATH or adjust to full path

echo "Starting Screaming Frog crawl for: ${URL_TO_CRAWL}"
echo "Output will be saved to: ${OUTPUT_DIR} (Screaming Frog will create a timestamped subfolder)"

mkdir -p "${OUTPUT_DIR}" # Ensure the base output directory exists

# List of tabs to export (based on common and comprehensive options)
# This list can be expanded further by checking the Screaming Frog GUI
EXPORT_TABS="Internal:All,External:All,Response Codes:All,Page Titles:All,Meta Description:All,H1:All,H2:All,Images:All,Canonicals:All,Directives:All,Pagination:All,AMP:All,Structured Data:All,Security:All,JavaScript:All,CSS:All,Flash:All,Resources:All,Links:All,Anchor Text:All,User-Defined:All"

# List of bulk exports (based on common and comprehensive options)
# This list can be expanded further by checking the Screaming Frog GUI
BULK_EXPORTS="All Inlinks,All Outlinks,All Redirects,All Canonicals,All Hreflang,All AMP,All Structured Data,All Images,All CSS,All JavaScript,All Flash,All Resources,All External Links,All Internal Links,All Broken Links,All Missing Alt Text Images,All Missing H1,All Missing H2,All Missing Meta Descriptions,All Missing Page Titles,All Duplicate Page Titles,All Duplicate Meta Descriptions,All Duplicate H1,All Duplicate H2"

# Save specific reports
SAVE_REPORTS="Crawl Overview,Issues Overview"

"${SCREAMING_FROG_CLI}" \
    --headless \
    --crawl "${URL_TO_CRAWL}" \
    --save-crawl \
    --output-folder "${OUTPUT_DIR}" \
    --timestamped-output \
    --export-format "csv" \
    --export-tabs "${EXPORT_TABS}" \
    --bulk-export "${BULK_EXPORTS}" \
    --save-report "${SAVE_REPORTS}"

if [ $? -eq 0 ]; then
    echo "Screaming Frog crawl completed successfully."
    echo "Output directory: ${OUTPUT_DIR} (Screaming Frog created a timestamped subfolder within this directory)."
    echo "To generate the PowerPoint presentation, navigate to the latest timestamped folder in ${OUTPUT_DIR} and run:"
    echo "python3 generate_powerpoint.py <LATEST_TIMESTAMPED_FOLDER>/issues_overview.csv"
    echo "Example: python3 generate_powerpoint.py ${OUTPUT_DIR}20250627_123456/issues_overview.csv"
else
    echo "Screaming Frog crawl failed."
    exit 1
fi
