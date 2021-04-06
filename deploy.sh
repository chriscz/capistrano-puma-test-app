#/bin/bash
set -eou pipefail
bundle exec cap production puma:config
bundle exec cap production deploy
