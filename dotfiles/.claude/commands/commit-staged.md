# Commit Staged Changes

Create a commit with only the currently staged changes. Shows git status, diff of staged changes, and recent commit history for context, then creates a commit following the repository's style.

## Usage
```
/commit-staged [commit message]
```

If no commit message is provided, Claude will analyze the staged changes and generate an appropriate message.

## What it does
1. Check git status to see staged files
2. Show diff of staged changes only (`git diff --cached`)
3. Review recent commit messages for style consistency
4. Create commit with proper formatting and Claude Code attribution
5. Confirm commit was successful

Perfect for when you've carefully staged specific changes and want to commit only those files.