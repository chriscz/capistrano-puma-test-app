#/bin/bash
bundle exec cap production puma:config
bundle exec cap production deploy
