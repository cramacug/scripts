#!/usr/bin/env bash

if [ $# -eq 0 ]; then
  echo  "Please, add user and email"
fi

#GIT
# Set vim as default editor
git config --global core.editor "vim"
git config --global pull.rebase true

# Set own configuration
git config --global user.name "$1"
git config --global user.email "$2"


# hint: Pulling without specifying how to reconcile divergent branches is
# hint: discouraged. You can squelch this message by running one of the following
# hint: commands sometime before your next pull:
# hint:
# hint:   git config pull.rebase false  # merge (the default strategy)
# hint:   git config pull.rebase true   # rebase
# hint:   git config pull.ff only       # fast-forward only
# hint:
# hint: You can replace "git config" with "git config --global" to set a default
# hint: preference for all repositories. You can also pass --rebase, --no-rebase,
# hint: or --ff-only on the command line to override the configured default per
# hint: invocation.

