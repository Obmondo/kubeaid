#!/bin/bash

# Get the latest tag from the changelog file
changelog_file="CHANGELOG.md"
latest_tag=$(grep -oP '^## \K[0-9]+\.[0-9]+\.[0-9]+' "$changelog_file" | head -n1)

echo "$latest_tag"

# Get the commit log since the latest tag
commit_log=$(git log "$latest_tag"..origin/master --oneline --no-merges)

# Format the commit log into bullet points
formatted_commit_log=$(echo "$commit_log" | awk '{print "- " $0}') # to keep sha in front
# formatted_commit_log=$(echo "$commit_log" | awk '{sha=$1; $1=""; print "-" $0" "sha}') # to keep sha later

# Create a temporary file for the formatted commit log
temp_file="temp.md"
{
  echo "### Improvements"
  echo "$formatted_commit_log"
  echo ""
} > "$temp_file"

# Update the changelog file
awk -v tag="## ${latest_tag}" -v file="$temp_file" '
  $0 == tag { 
    while ((getline line < file) > 0) {
      print line
    }
  }
  { print }
' "$changelog_file" > "${changelog_file}.tmp" && mv "${changelog_file}.tmp" "$changelog_file"

rm "$temp_file"

commit_msg="Add commit since ${latest_tag} tag to CHANGELOG.md"

git add CHANGELOG.md
git commit -m "$commit_msg"
