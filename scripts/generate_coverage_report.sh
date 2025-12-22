#!/bin/bash

# Generate complete test coverage report
#
# This script:
# 1. Runs all tests with coverage
# 2. Applies exclusions (presentation, constants, l10n, widgets, playbook)
# 3. Generates HTML report
# 4. Updates coverage badge in README.md
#
# Usage: bash scripts/generate_coverage_report.sh

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
README="$PROJECT_DIR/README.md"

log_info() {
    echo "ℹ️  $1"
}

log_success() {
    echo "✅ $1"
}

log_warning() {
    echo "⚠️  $1"
}

log_error() {
    echo "❌ $1"
}

run_tests() {
    log_info "Running tests with coverage..."
    
    if command -v fvm &> /dev/null; then
        fvm flutter test --coverage
    else
        flutter test --coverage
    fi
    
    if [ ! -d "$PROJECT_DIR/coverage" ]; then
        log_error "Coverage directory not found"
        exit 1
    fi
    
    log_success "Tests completed"
}

apply_exclusions() {
    log_info "Applying exclusions..."
    
    if ! command -v lcov &> /dev/null; then
        log_warning "lcov not found. Skipping exclusions."
        return
    fi
    
    lcov --remove "$PROJECT_DIR/coverage/lcov.info" \
        '*/presentation/*' \
        '*/constants/*' \
        '*/l10n/*' \
        '*/core/widgets/*' \
        '*/playbook/*' \
        -o "$PROJECT_DIR/coverage/lcov.info" > /dev/null 2>&1
    
    log_success "Exclusions applied"
}

generate_html_report() {
    log_info "Generating HTML report..."
    
    if ! command -v genhtml &> /dev/null; then
        log_warning "genhtml not found. Skipping HTML report generation."
        return
    fi
    
    rm -rf "$PROJECT_DIR/coverage/html"
    genhtml "$PROJECT_DIR/coverage/lcov.info" \
        -o "$PROJECT_DIR/coverage/html" > /dev/null 2>&1
    
    log_success "HTML report generated at coverage/html/index.html"
}

calculate_coverage() {
    local coverage
    
    if command -v fvm &> /dev/null; then
        coverage=$(cd "$PROJECT_DIR" && fvm dart scripts/get_coverage_percentage.dart 2>/dev/null)
    elif command -v dart &> /dev/null; then
        coverage=$(cd "$PROJECT_DIR" && dart scripts/get_coverage_percentage.dart 2>/dev/null)
    elif command -v lcov &> /dev/null; then
        coverage=$(lcov --summary "$PROJECT_DIR/coverage/lcov.info" 2>&1 | \
            grep "lines" | grep -oE '[0-9]+\.[0-9]+%' | head -1 | sed 's/%//')
        
        if [ -z "$coverage" ]; then
            log_error "Could not extract coverage percentage"
            exit 1
        fi
        
        coverage=$(printf "%.0f" "$coverage")
    else
        log_error "Neither fvm, dart nor lcov found. Cannot calculate coverage."
        exit 1
    fi
    
    echo "$coverage"
}

get_badge_color() {
    local coverage=$1
    
    if [ "$coverage" -ge 90 ]; then
        echo "brightgreen"
    elif [ "$coverage" -ge 80 ]; then
        echo "green"
    elif [ "$coverage" -ge 70 ]; then
        echo "yellowgreen"
    elif [ "$coverage" -ge 60 ]; then
        echo "yellow"
    elif [ "$coverage" -ge 50 ]; then
        echo "orange"
    else
        echo "red"
    fi
}

update_readme_badge() {
    local coverage=$1
    local color=$2
    local badge_url="https://img.shields.io/badge/coverage-${coverage}%25-${color}"
    local badge_markdown="![Coverage](${badge_url})"
    
    log_info "Updating badge in README.md..."
    
    if [ ! -f "$README" ]; then
        log_warning "README.md not found. Skipping badge update."
        return
    fi
    
    if grep -q "!\[Coverage\]" "$README"; then
        if [[ "$OSTYPE" == "darwin"* ]]; then
            sed -i '' "s|!\[Coverage\](https://img.shields.io/badge/coverage-[0-9]*%25-[a-z]*)|${badge_markdown}|g" "$README"
        else
            sed -i "s|!\[Coverage\](https://img.shields.io/badge/coverage-[0-9]*%25-[a-z]*)|${badge_markdown}|g" "$README"
        fi
        log_success "Updated coverage badge in README.md"
    else
        if [[ "$OSTYPE" == "darwin"* ]]; then
            sed -i '' "/!\[License\]/a\\
${badge_markdown}
" "$README"
        else
            sed -i "/!\[License\]/a\\${badge_markdown}" "$README"
        fi
        log_success "Added coverage badge to README.md"
    fi
}

save_coverage_data() {
    local coverage=$1
    local color=$2
    local badge_url="https://img.shields.io/badge/coverage-${coverage}%25-${color}"
    local badge_markdown="![Coverage](${badge_url})"
    
    echo "$coverage" > "$PROJECT_DIR/coverage/percentage.txt"
    echo "$badge_markdown" > "$PROJECT_DIR/coverage/badge.txt"
}

main() {
    echo "🚀 Generating test coverage report"
    echo ""
    
    run_tests
    echo ""
    
    apply_exclusions
    echo ""
    
    generate_html_report
    echo ""
    
    log_info "Calculating coverage percentage..."
    local coverage
    coverage=$(calculate_coverage)
    log_success "Test Coverage: ${coverage}%"
    echo ""
    
    local color
    color=$(get_badge_color "$coverage")
    
    update_readme_badge "$coverage" "$color"
    echo ""
    
    save_coverage_data "$coverage" "$color"
    
    echo "✨ Coverage report generation complete!"
    echo "   Coverage: ${coverage}%"
    echo "   HTML report: coverage/html/index.html"
    echo "   Badge updated in README.md"
}

main
