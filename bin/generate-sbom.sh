#!/bin/bash
set -e

usage() {
  echo "Usage: $0 [-v] [-o output_file]"
  echo "  -v               Verbose output"
  echo "  -o output_file   Output SBOM file (default: sbom.md)"
  echo ""
  echo "This script scans all Helm charts in ./argocd-helm-charts (for now, it only scans this specific dir), "
  echo "extracts Docker images, and generates a SBOM."
  exit 1
}

VERBOSE=0
OUTPUT_FILE="sbom.md"

while getopts "vo:h" opt; do
  case $opt in
    v) VERBOSE=1 ;;
    o) OUTPUT_FILE="$OPTARG" ;;
    h) usage ;;
    *) usage ;;
  esac
done
shift $((OPTIND - 1))

log_verbose() {
  [[ $VERBOSE -eq 1 ]] && echo "$1"
}

get_todays_date() {
  date +"%B %d, %Y"
}

# extract and clean image names from rendered manifests
# returns list of sorted image names
extract_images() {
  local rendered_file="$1"

  # Step 1: match lines containing "image:" 
  # Step 2: but excludes the ones starting with #
  # Step 3: extracts everything after "image:" 
  # Step 4: remove all types of quotes: double, backtick, single
  # Step 5: remove whitespace from both sides
  # Step 6: remove lines that are now completely empty (just whitespaces or nothing)
  # Step 7: sort and remove duplicates
  grep -E "image:" "$rendered_file" \
    | grep -v "^\s*#" \
    | sed 's/.*image:\s*//' \
    | sed 's/["`'"'"']//g' \
    | sed 's/^[[:space:]]*//;s/[[:space:]]*$//' \
    | grep -v "^[[:space:]]*$" \
    | sort -u 
}

CHARTS_DIR="./argocd-helm-charts"
if [[ ! -d "$CHARTS_DIR" ]]; then
  echo "ERROR: Charts directory not found at $CHARTS_DIR"
  exit 1
fi

log_verbose "INFO: Scanning Helm charts in: $CHARTS_DIR"
log_verbose "INFO: Looking for all container images"

# array of chart data "chart_name|images_separated_by_§|has_images"
# e.g. "nginx|nginx:1.21§nginx:1.20|true"     (chart with 2 images)
declare -a CHART_DATA

# temporary file with collection of generic default values.
# required to satisfy some charts that fail to render if certain values are not present.
temp_values=$(mktemp)
cat > "$temp_values" <<EOF
networkpolicies: {}
networkPolicies: {}
postgresql:
  enabled: false
EOF

for chart in "$CHARTS_DIR"/*; do
  # skip if not a dir
  if [[ ! -d "$chart" ]]; then
    continue
  fi

  # extract dir name from the full path
  # example: "./argocd-helm-charts/cert-manager" -> "cert-manager"
  chart_name=$(basename "$chart")
  log_verbose "Info: Rendering chart: $chart_name"
  
  # temporary file to store the rendered manifest.
  rendered=$(mktemp)
    
  # Render the chart by skipping schema validation.
  if helm template "$chart_name" "$chart" --skip-schema-validation > "$rendered" 2>/dev/null; then
    log_verbose "Strategy 1: Basic skip validation worked"
    
  # Provide dummy default values to satisfy some charts. (used by - redmine)
  elif helm template "$chart_name" "$chart" -f "$temp_values" --skip-schema-validation > "$rendered" 2>/dev/null; then
    log_verbose "Strategy 2: Default values + no validation worked"

  # Customer params for problematic charts.
  elif case "$chart_name" in
    "azure-workload-identity-webhook")
      # This chart requires a dummy tenant ID.
      helm template "$chart_name" "$chart" --set workload-identity-webhook.azureTenantID="00000000-0000-0000-0000-000000000000" --skip-schema-validation --disable-openapi-validation --no-hooks > "$rendered" 2>/dev/null
      ;;
    "sonarqube")
      # This chart requires a monitoring passcode and edition settings.
      helm template "$chart_name" "$chart" --set sonarqube.monitoringPasscode="temp-passcode" --set sonarqube.edition="" --set sonarqube.community.enabled=true --skip-schema-validation --disable-openapi-validation --no-hooks > "$rendered" 2>/dev/null
      ;;
    "traefik")
      # This chart needs to know that the ServiceMonitor API is available.
      helm template "$chart_name" "$chart" --api-versions monitoring.coreos.com/v1 --skip-schema-validation --disable-openapi-validation --no-hooks > "$rendered" 2>/dev/null
      ;;
    "odoo")
      # This chart fails on a nil pointer if redirectToWWW.enabled is not set.
      helm template "$chart_name" "$chart" --set redirectToWWW.enabled=false --skip-schema-validation --disable-openapi-validation --no-hooks > "$rendered" 2>/dev/null
      ;;
    "metallb")
      # This chart fails on a nil pointer if ipaddresspool.layer is not set.
      helm template "$chart_name" "$chart" --set ipaddresspool.layer="" --skip-schema-validation --disable-openapi-validation --no-hooks > "$rendered" 2>/dev/null
      ;;
    *)
      false
      ;;
  esac; then
    log_verbose "Strategy 3: Chart-specific fix worked for '$chart_name'"
  else
    echo "ERROR: All strategies failed for $chart_name" >&2
    rm -f "$rendered"
        continue
  fi
 
  # extract all images from the rendered manifests
  images=$(extract_images "$rendered")
  
  if [[ -n "$images" ]]; then
    log_verbose "Found images in $chart_name"

    # Example:
    # Input (multi-line):   nginx:1.21.0
    #                      redis:6.2.0 
    # After: nginx:1.21.0§redis:6.2.0
    images_single_line=$(echo "$images" | tr '\n' '§')

    # store in format: "chart_name|images_with_§_delimiters|has_images_flag"
    CHART_DATA+=("$chart_name|$images_single_line|true")
  else
    log_verbose "WARN: No images found in $chart_name"
    # still add the chart to CHART_DATA but mark it as having no images
    CHART_DATA+=("$chart_name||false")
  fi

  rm -f "$rendered"
done

rm -f "$temp_values"

generate_sbom() {
  # total no. of charts
  local chart_count=${#CHART_DATA[@]}
  log_verbose "INFO Generating SBOM with $chart_count charts..."
  
  {
    echo "# KubeAid Project - Software Bill of Materials (SBOM)"
    echo "**Date:** $(get_todays_date)"
    echo ""
    echo "## Summary of Dependencies:"
    echo ""
    
    # create the summary list showing ALL charts
    for entry in "${CHART_DATA[@]}"; do
      local chart_name
      chart_name=$(echo "$entry" | cut -d'|' -f1)  # get the first field (chart name)
      echo "- $chart_name"
    done
    
    echo ""
    echo "## Dependency Details"
    echo ""
    
    # create section for charts and its images
    for entry in "${CHART_DATA[@]}"; do
      # parse the chart data back into individual variables
      local chart_name images_line has_images
      chart_name=$(echo "$entry" | cut -d'|' -f1)
      images_line=$(echo "$entry" | cut -d'|' -f2)
      has_images=$(echo "$entry" | cut -d'|' -f3)
      
      if [[ "$has_images" == "true" ]]; then
        echo "### $chart_name"
        echo ""
        echo "* **Images:**"
        
        # convert the single-line images back to multiple lines
        # replace '§' with '\n'
        # read each line and format as md buttel points
        echo "$images_line" | tr '§' '\n' | while IFS= read -r image; do
          if [[ -n "$image" ]]; then
            echo "    - $image"
          fi
        done

        echo ""
      fi      
    done
  } > "$OUTPUT_FILE"
}

# create SBOM if we have chart data
if [[ ${#CHART_DATA[@]} -gt 0 ]]; then
  generate_sbom
else
  echo "WARN: No charts found. SBOM not generated."
fi
