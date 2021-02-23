#!/bin/bash
fetch_and_diff () {
    local json="$1.json"
    local url="$2"
    local json_old="$1.json.old"
    local commit_txt="$1.commit.txt"
    cp $json $json_old
    curl -s $url | jq .content > $json
    csv-diff $json_old $json --format=json --key=id > $commit_txt
}

add_and_commit () {
    local csv="$1.json"
    local commit_txt="$1.commit.txt"
    git add $csv
    git commit -F $commit_txt && \
        git push -q origin main \
        || true
}

git config user.name "Automated"
git config user.email "actions@users.noreply.github.com"

fetch_and_diff locations "https://api.vaccinateca.com/v1/locations.json"
add_and_commit locations
fetch_and_diff counties "https://api.vaccinateca.com/v1/counties.json"
add_and_commit counties
fetch_and_diff providers "https://api.vaccinateca.com/v1/providers.json"
add_and_commit providers
