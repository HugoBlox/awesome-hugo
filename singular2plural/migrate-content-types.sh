#!/usr/bin/env zsh
#
# Hugo Blox Content Type Migration Script
#
# This script migrates a Hugo Blox Builder site from the old singular content type structure
# (post, publication, project, event, teaching) to the new standardized structure
# (blog, publications, projects, events, courses).
#
# Usage:
#   ./migrate-content-types.sh /path/to/your/site
#
# Author: Hugo Blox Team
# License: MIT

set -e

# Display colorized output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to display usage information
usage() {
  echo "Usage: $0 /path/to/your/site [--dry-run]"
  echo ""
  echo "Options:"
  echo "  --dry-run  Print actions without executing them"
  exit 1
}

# Process arguments
if [[ $# -lt 1 ]]; then
  usage
fi

SITE_PATH="$1"
DRY_RUN=false

if [[ $# -eq 2 && "$2" == "--dry-run" ]]; then
  DRY_RUN=true
fi

# Check if the site path exists
if [[ ! -d "$SITE_PATH" ]]; then
  echo "${RED}Error: Site path $SITE_PATH does not exist${NC}"
  exit 1
fi

echo "${BLUE}🚀 Migrating Hugo Blox site at $SITE_PATH to standardized content types${NC}"
echo ""

# Define content type migrations
declare -A CONTENT_MIGRATIONS=(
  ["post"]="blog"
  ["publication"]="publications"
  ["project"]="projects"
  ["event"]="events"
  ["teaching"]="courses"
)

# Migrate content directories
migrate_content_directories() {
  local content_path="$SITE_PATH/content"
  
  if [[ ! -d "$content_path" ]]; then
    echo "${YELLOW}⚠️ Content directory not found at $content_path${NC}"
    return
  fi
  
  echo "${BLUE}📂 Migrating content directories...${NC}"
  
  for old_type in "${!CONTENT_MIGRATIONS[@]}"; do
    local new_type="${CONTENT_MIGRATIONS[$old_type]}"
    local old_dir="$content_path/$old_type"
    local new_dir="$content_path/$new_type"
    
    if [[ -d "$old_dir" ]]; then
      if [[ ! -d "$new_dir" ]]; then
        if [[ "$DRY_RUN" == "true" ]]; then
          echo "  [DRY RUN] Would create directory: $new_dir"
        else
          mkdir -p "$new_dir"
          echo "  ${GREEN}✅ Created $new_type directory${NC}"
        fi
      fi
      
      # Get list of items in the old directory
      if [[ "$(ls -A "$old_dir" 2>/dev/null)" ]]; then
        for item in "$old_dir"/*; do
          if [[ -e "$item" ]]; then
            local base_name=$(basename "$item")
            local new_item_path="$new_dir/$base_name"
            
            if [[ -e "$new_item_path" ]]; then
              echo "  ${YELLOW}⚠️ $base_name already exists in $new_type/, skipping...${NC}"
              continue
            fi
            
            if [[ "$DRY_RUN" == "true" ]]; then
              echo "  [DRY RUN] Would move: $item to $new_item_path"
            else
              mv "$item" "$new_item_path"
              echo "  ${GREEN}✅ Moved $old_type/$base_name to $new_type/$base_name${NC}"
            fi
          fi
        done
        
        # Remove old directory if empty
        if [[ ! "$(ls -A "$old_dir" 2>/dev/null)" ]]; then
          if [[ "$DRY_RUN" == "true" ]]; then
            echo "  [DRY RUN] Would remove empty directory: $old_dir"
          else
            rmdir "$old_dir"
            echo "  ${GREEN}✅ Removed empty $old_type/ directory${NC}"
          fi
        fi
      fi
    fi
  done
}

# Update folder references in content files
update_folder_references() {
  echo ""
  echo "${BLUE}📄 Updating folder references in content files...${NC}"
  
  # Find all markdown files
  local md_files=$(find "$SITE_PATH" -name "*.md" -o -name "*.markdown")
  
  for md_file in $md_files; do
    local updated=false
    local content=$(<"$md_file")
    local new_content="$content"
    
    # Update folder references
    for old_type in "${!CONTENT_MIGRATIONS[@]}"; do
      local new_type="${CONTENT_MIGRATIONS[$old_type]}"
      
      # Check for folders: - old_type pattern
      if grep -q "folders:.*\n[[:space:]]*-[[:space:]]*$old_type" "$md_file"; then
        if [[ "$DRY_RUN" == "true" ]]; then
          echo "  [DRY RUN] Would update folder reference in $(realpath --relative-to="$SITE_PATH" "$md_file")"
        else
          new_content=$(echo "$new_content" | sed -E "s/(folders:.*\n[[:space:]]*-[[:space:]]*)$old_type/\1$new_type/g")
          updated=true
        fi
      fi
      
      # Check for page_type: old_type pattern
      if grep -q "page_type:[[:space:]]*$old_type" "$md_file"; then
        if [[ "$DRY_RUN" == "true" ]]; then
          echo "  [DRY RUN] Would update page_type reference in $(realpath --relative-to="$SITE_PATH" "$md_file")"
        else
          new_content=$(echo "$new_content" | sed -E "s/(page_type:[[:space:]]*)$old_type/\1$new_type/g")
          updated=true
        fi
      fi
    done
    
    # Write back if changes were made
    if [[ "$updated" == "true" && "$new_content" != "$content" ]]; then
      echo "$new_content" > "$md_file"
      echo "  ${GREEN}✅ Updated references in $(realpath --relative-to="$SITE_PATH" "$md_file")${NC}"
    fi
  done
}

# Update config files
update_config_files() {
  echo ""
  echo "${BLUE}⚙️ Updating configuration files...${NC}"
  
  # Find config files
  local config_files=$(find "$SITE_PATH" -name "hugo.yaml" -o -name "config.yaml" -o -name "config.toml" -o -name "hugo.toml")
  
  for config_file in $config_files; do
    local file_ext="${config_file##*.}"
    
    if [[ "$file_ext" == "yaml" || "$file_ext" == "yml" ]]; then
      # Check if permalinks section exists
      if grep -q "permalinks:" "$config_file"; then
        if [[ "$DRY_RUN" == "true" ]]; then
          echo "  [DRY RUN] Would remove permalink overrides from $(realpath --relative-to="$SITE_PATH" "$config_file")"
        else
          # Simple removal of authors permalink override
          sed -i'.bak' -E '/permalinks:.*\n[[:space:]]*authors:[[:space:]]*.*/d' "$config_file"
          # Remove tags/categories permalink overrides
          sed -i'.bak' -E '/permalinks:.*\n[[:space:]]*tags:[[:space:]]*.*/d' "$config_file"
          sed -i'.bak' -E '/permalinks:.*\n[[:space:]]*categories:[[:space:]]*.*/d' "$config_file"
          # Clean up empty permalinks section
          sed -i'.bak' -E '/permalinks:[[:space:]]*$/d' "$config_file"
          
          # Remove backup files
          rm -f "${config_file}.bak"
          
          echo "  ${GREEN}✅ Removed permalink overrides from $(realpath --relative-to="$SITE_PATH" "$config_file")${NC}"
        fi
      fi
    fi
  done
}

# Create Netlify redirects
create_netlify_redirects() {
  echo ""
  echo "${BLUE}🔄 Creating Netlify redirects for backward compatibility...${NC}"
  
  local netlify_file="$SITE_PATH/netlify.toml"
  local redirects=""
  
  for old_type in "${!CONTENT_MIGRATIONS[@]}"; do
    local new_type="${CONTENT_MIGRATIONS[$old_type]}"
    redirects+="
[[redirects]]
  from = \"/$old_type/*\"
  to = \"/$new_type/:splat\"
  status = 301
  force = true
"
  done
  
  if [[ "$DRY_RUN" == "true" ]]; then
    echo "  [DRY RUN] Would add the following redirects to netlify.toml:"
    echo "$redirects"
  else
    if [[ -f "$netlify_file" ]]; then
      # Append to existing file
      echo -e "\n# Redirects for content type migration" >> "$netlify_file"
      echo "$redirects" >> "$netlify_file"
      echo "  ${GREEN}✅ Added redirects to netlify.toml${NC}"
    else
      # Create new file
      echo -e "# Hugo Blox Builder - Netlify Configuration\n# See https://docs.hugoblox.com/\n\n# Redirects for content type migration" > "$netlify_file"
      echo "$redirects" >> "$netlify_file"
      echo "  ${GREEN}✅ Created netlify.toml with redirects${NC}"
    fi
  fi
}

# Main execution
if [[ "$DRY_RUN" == "true" ]]; then
  echo "${YELLOW}Running in DRY RUN mode - no changes will be made${NC}"
fi

migrate_content_directories
update_folder_references
update_config_files
create_netlify_redirects

if [[ "$DRY_RUN" == "true" ]]; then
  echo ""
  echo "${YELLOW}Dry run completed. No changes were made.${NC}"
else
  echo ""
  echo "${GREEN}✨ Migration completed successfully!${NC}"
  echo ""
  echo "Recommendations:"
  echo "1. Run 'hugo server' to test your site locally"
  echo "2. Review your site to make sure everything works as expected"
  echo "3. Commit the changes to your Git repository"
fi

echo ""
echo "For more details on the content type standardization, see:"
echo "https://github.com/HugoBlox/awesome-hugo/blob/main/singular2plural/CONTENT-TYPES.md"
