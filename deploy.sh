#/bin/bash
set -eou pipefail
mkdir -p /home/app/application/shared/config/credentials
cp -r config/credentials/production.key /home/app/application/shared/config/credentials
cp -r vendor/bundle /home/app/application/shared
cp -r node_modules /home/app/application/shared
bundle exec cap production deploy:check
bundle exec cap production puma:config
bundle exec cap production deploy
