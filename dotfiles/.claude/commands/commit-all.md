# Commit All Changes

Create a commit with all changes in the workspace (both staged and unstaged). Shows git status, diff of all changes, and recent commit history for context, then stages everything and creates a commit.

## Usage
```
/commit-all [commit message]
```

If no commit message is provided, Claude will analyze all the changes and generate an appropriate message.

## What it does
1. Check git status to see all untracked and modified files
2. Show diff of both staged and unstaged changes (`git diff` and `git diff --cached`)
3. Review recent commit messages for style consistency
4. Stage all relevant files (`git add` for modified files, prompt for untracked)
5. Create commit with proper formatting and Claude Code attribution
6. Confirm commit was successful

Perfect for when you want to commit all your current work without manually staging files first.