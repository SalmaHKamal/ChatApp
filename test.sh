#!/bin/sh

testCoveragePrecentage=60
branch='git rev-parse --abbrev-ref HEAD'
currentBranch=$(git rev-parse --abbrev-ref HEAD)
parentBranch=$(git show-branch | grep '*' | grep -v "$branch" | head -n1 | sed 's/.*\[\(.*\)\].*/\1/' | sed 's/[\^~].*//')

# echo "difference between '$currentBranch' and '$parentBranch' is \n "
changedFiles=$(git diff master $parentBranch --stat --name-only --ignore-all-space)
# echo "Changed files are \n $changedFiles"
# git ls-files | xargs wc -l
# git diff master $parentBranch --name-only --ignore-all-space | xargs wc -l
linesNumber=$(git diff master $parentBranch --ignore-all-space --stat | grep "files changed" | awk '{print $4}')
linesToCover=$(expr $linesNumber \* $testCoveragePrecentage / 100)

echo "==================================" > testResult.text
echo "New lines number is $linesNumber" >> testResult.text
echo "Test coverage percentage is $testCoveragePrecentage%" >> testResult.text
echo "Lines to cover is $linesToCover" >> testResult.text
echo "==================================" >> testResult.text

open testResult.text


git diff master $parentBranch --ignore-all-space --stat

#=============

# xcrun xcresulttool get --path /Users/salmahassan/Library/Developer/Xcode/DerivedData/ChatApp-fhjvmwflbcqbcbcqgifewobjylbj/Logs/Test/Test-ChatApp-2021.09.10_11-44-24-+0200.xcresult --format json > coverage.json
# ./process-coverage.swift coverage.json

# xargs --name-only  

# echo "Run test coverage"
# chmod +x "${SRCROOT}/test.sh"
# "${SRCROOT}/test.sh"
# exit 0

# xcrun xccov view --report /Users/salmahassan/Study/ChatApp/CodableKeychain/Logs/Test/Run-ChatApp-2021.09.10_13-37-27-+0200.xcresult --json > coverage.json