#!/usr/bin/env bash
# Generate Android keystore based on android/key.properties or interactive input
# Usage: ./scripts/generate_keystore.sh [--yes]
# If --yes is provided the script will not prompt for confirmation when overwriting.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="${SCRIPT_DIR}/.."
KEYPROPS_FILE="${PROJECT_ROOT}/android/key.properties"

# Default output
STORE_FILE_REL="android/upload-keystore.jks"
STORE_FILE="${PROJECT_ROOT}/${STORE_FILE_REL}"

# Helper: trim
trim() { echo "$1" | sed -e 's/^\s*//' -e 's/\s*$//'; }

# Load from key.properties if it exists
STORE_PASSWORD=""
KEY_PASSWORD=""
KEY_ALIAS=""
STORE_FILE_PROP=""

if [ -f "$KEYPROPS_FILE" ]; then
  echo "Found $KEYPROPS_FILE, parsing..."
  while IFS='=' read -r key value; do
    key=$(trim "$key")
    value=$(trim "$value")
    case "$key" in
      storePassword) STORE_PASSWORD="$value" ;;
      keyPassword) KEY_PASSWORD="$value" ;;
      keyAlias) KEY_ALIAS="$value" ;;
      storeFile) STORE_FILE_PROP="$value" ;;
    esac
  done < <(grep -E '^(storePassword|keyPassword|keyAlias|storeFile)=' "$KEYPROPS_FILE" || true)
fi

# If storeFile property is set, override relative path
if [ -n "$STORE_FILE_PROP" ]; then
  # If storeFile is not an absolute path, treat as relative to android/
  if [[ "$STORE_FILE_PROP" = /* ]]; then
    STORE_FILE="$STORE_FILE_PROP"
  else
    STORE_FILE="${PROJECT_ROOT}/android/${STORE_FILE_PROP}"
  fi
fi

# Prompt for missing values
read_env_or_prompt() {
  local var_name="$1"; shift
  local prompt="$1"; shift
  local current_val
  current_val="$(eval echo \"\$$var_name\")"
  if [ -z "$current_val" ]; then
    read -r -p "$prompt: " input_val
    eval "$var_name=\"\$input_val\""
  fi
}

read_env_or_prompt STORE_PASSWORD "Keystore password (storePassword)"
read_env_or_prompt KEY_PASSWORD "Key password (keyPassword)"
read_env_or_prompt KEY_ALIAS "Key alias (keyAlias)"

# Confirm overwrite
FORCE=no
if [ "${1-}" = "--yes" ] || [ "${1-}" = "-y" ]; then
  FORCE=yes
fi

if [ -f "$STORE_FILE" ]; then
  if [ "$FORCE" != "yes" ]; then
    read -r -p "Keystore file $STORE_FILE already exists. Overwrite? (y/N): " yn
    case "$yn" in
      [Yy]*) true ;;
      *) echo "Aborted."; exit 1 ;;
    esac
  else
    echo "Overwriting existing keystore: $STORE_FILE"
  fi
fi

# Ensure directory exists
mkdir -p "$(dirname "$STORE_FILE")"

# Build distinguished name: allow user to override or use safe defaults
DEFAULT_DNAME="CN=Unknown, OU=Unknown, O=Unknown, L=Unknown, S=Unknown, C=CN"
read -r -p "Distinguished Name for key (DN) [default: $DEFAULT_DNAME]: " DNAME_IN
if [ -z "$DNAME_IN" ]; then
  DNAME="$DEFAULT_DNAME"
else
  DNAME="$DNAME_IN"
fi

# Check keytool
if ! command -v keytool >/dev/null 2>&1; then
  echo "Error: keytool not found. Please ensure JDK is installed and keytool is in PATH." >&2
  exit 2
fi

# Generate keystore
# NOTE: Using -storepass and -keypass on the command line may expose passwords on the process list.
# In CI, prefer providing values via a file or environment with proper protections.

echo "Generating keystore at: $STORE_FILE"

keytool -genkeypair \
  -alias "$KEY_ALIAS" \
  -keyalg RSA \
  -keysize 2048 \
  -validity 10000 \
  -keystore "$STORE_FILE" \
  -storetype JKS \
  -dname "$DNAME" \
  -storepass "$STORE_PASSWORD" \
  -keypass "$KEY_PASSWORD" \
  -v

if [ $? -eq 0 ]; then
  echo "Keystore generated: $STORE_FILE"
  echo "(If you used passwords in key.properties, that file now contains the credentials.)"
else
  echo "keytool failed" >&2
  exit 3
fi

# Set restrictive permissions
chmod 600 "$STORE_FILE" || true

# Print next steps
cat <<EOF
Next steps:
- Commit the keystore to a secure location (avoid committing to git). Prefer storing in secure storage or CI secrets.
- Ensure android/key.properties is kept out of source control (.gitignore) or encrypted.
- To run non-interactively: ./scripts/generate_keystore.sh --yes
EOF
