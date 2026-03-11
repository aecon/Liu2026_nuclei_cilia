#!/usr/bin/env bash
set -euo pipefail

#ILASTIK="/home/neptun/Downloads/ilastik-1.4.0.post1-Linux/run_ilastik.sh"
#PROJECT="/media/neptun/SpeedDrive/Michele/nuclei_area/nuclei_with_TopHat.ilp"



# Check usage

usage() {
    echo "Usage:"
    echo "  ILASTIK=/path/to/run_ilastik.sh PROJECT=/path/to/project.ilp $0 <directory>"
    exit 1
}

if [ "$#" -ne 1 ]; then
    usage
fi

if [ -z "${ILASTIK:-}" ]; then
    echo "Error: ILASTIK is not set."
    usage
fi

if [ -z "${PROJECT:-}" ]; then
    echo "Error: PROJECT is not set."
    usage
fi



# Check if directory, and paths to ilastik and project file exist

dir="$1"

if [ ! -d "$dir" ]; then
    echo "Error: directory does not exist: $dir"
    exit 1
fi

if [ ! -x "$ILASTIK" ]; then
    echo "Error: ilastik executable not found or not executable: $ILASTIK"
    exit 1
fi

if [ ! -f "$PROJECT" ]; then
    echo "Error: ilastik project file not found: $PROJECT"
    exit 1
fi



# Run ilastik on _tophat.tif files that are not processed yet

find "$dir" -type f -name '*_tophat.tif' -print0 |
while IFS= read -r -d '' file; do
    base="${file%.tif}"
    if [[ -f "${base}_probabilities.tif" ]]; then
        echo "Probabilities file exists: ${base}_probabilities.tif"
    else
        echo "Processing: $file"
        dir_path=$(dirname "${file}")
        "$ILASTIK" \
            --headless \
            --project="$PROJECT" \
            --export_source="Probabilities" \
            --output_format=tif \
            --pipeline_result_drange="(0.0,1.0)" \
            --export_drange="(0,255)" \
            --export_dtype=uint8 \
            --output_filename_format="${dir_path}/{nickname}_probabilities.tif" \
            --raw_data "$file"
    fi
done

# Re-zip all probability files together
probabilities_zip="$dir/probabilities.zip"
if [ -f "$probabilities_zip" ]; then
    echo "Removing existing $probabilities_zip"
    rm "$probabilities_zip"
fi
find "$dir" -type f -name '*_probabilities.tif' | zip "$probabilities_zip" -@
echo "Created new $probabilities_zip"



