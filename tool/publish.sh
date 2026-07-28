#!/usr/bin/env bash
# Builds and publishes to the gh-pages branch.
#
# This exists because the GitHub Pages source is currently the gh-pages branch
# rather than GitHub Actions: pushing a file under .github/workflows/ needs a
# token with the `workflow` OAuth scope, and the one available here does not
# have it. See README, "Switching to the Actions pipeline".
#
# Once the workflow is installed this script is redundant - a push to main will
# build and deploy on its own.
#
#   bash tool/publish.sh
set -euo pipefail

# Git Bash on Windows rewrites any argument that looks like a Unix path, so
# --base-href /okey101/ reaches Flutter as C:/Program Files/Git/okey101/ and the
# build fails. This turns that off for the whole script.
export MSYS_NO_PATHCONV=1
export MSYS2_ARG_CONV_EXCL='*'

REPO_URL="https://github.com/tgteknikcrm/okey101.git"
BASE_HREF="/okey101/"
BRANCH="gh-pages"

root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$root"

echo "==> Checks"
flutter analyze
flutter test

echo "==> Build"
build_id="$(git rev-parse --short HEAD)"
flutter build web --release --base-href "$BASE_HREF" \n  --dart-define=BUILD_ID="$build_id"

source_sha="$(git rev-parse --short HEAD)"
staging="$(mktemp -d)"
trap 'rm -rf "$staging"' EXIT

echo "==> Staging in $staging"
cp -r build/web/. "$staging"/
# Without this, GitHub Pages runs the output through Jekyll and drops anything
# beginning with an underscore.
touch "$staging/.nojekyll"

cd "$staging"
git init -q -b "$BRANCH"
git add -A
git -c user.name="Okey101 Builder" -c user.email="info@aksedigital.com" \
  commit -q -m "Okey 101 web build from main@${source_sha}

Build output only; the source lives on main."
git remote add origin "$REPO_URL"
git push -f -q origin "$BRANCH"

cd "$root"
echo "==> Asking Pages to rebuild"
gh api -X POST "repos/tgteknikcrm/okey101/pages/builds" --jq '.status' || true

echo "==> Done. https://tgteknikcrm.github.io/okey101/"
