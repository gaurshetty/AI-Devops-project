
#!/bin/bash

# Exit immediately on errors, undefined variables, and failed pipelines
set -Eeuo pipefail

APP_NAME="Node.js Application"
APP_FILE="index.js"
LOG_PREFIX="[$APP_NAME]"
SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"

cd "$SCRIPT_DIR"

# Logging functions
log_info() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') INFO: $LOG_PREFIX $1"
}

log_success() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') SUCCESS: $LOG_PREFIX $1"
}

log_error() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') ERROR: $LOG_PREFIX $1" >&2
}

# Error handler
error_handler() {
    local exit_code=$?
    log_error "Script failed at line ${BASH_LINENO[0]} with exit code $exit_code."
    exit "$exit_code"
}

trap error_handler ERR

# Startup banner
echo "================================================"
echo "          NODE.JS APPLICATION STARTUP"
echo "================================================"

# Step 1: Validate prerequisites
log_info "Checking Node.js and npm installation..."

command -v node >/dev/null 2>&1 || {
    log_error "Node.js is not installed or not available in PATH."
    exit 1
}

command -v npm >/dev/null 2>&1 || {
    log_error "npm is not installed or not available in PATH."
    exit 1
}

log_success "Node.js version: $(node --version)"
log_success "npm version: $(npm --version)"

# Step 2: Validate application entry point
log_info "Checking application entry point..."

if [[ ! -f "$APP_FILE" ]]; then
    log_error "$APP_FILE not found in $(pwd)."
    exit 1
fi

log_success "$APP_FILE found."

# Step 3: Install dependencies
log_info "Installing application dependencies..."

npm install

log_success "Dependencies installed successfully."

# Step 4: Stop existing Node.js application processes
log_info "Stopping any existing Node.js application processes..."
if command -v pkill >/dev/null 2>&1; then
    pkill -f "[n]ode .*index\.js" || log_info "No existing processes found."
else
    log_info "No existing Node.js processes found."
fi


# Step 5: Start application
log_info "Starting $APP_NAME..."
echo "================================================"

node "$APP_FILE"

log_success "$APP_NAME stopped successfully."
