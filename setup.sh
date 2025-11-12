set -e
mkdir demo_project
cd demo_project
git init
cat > Gemfile <<EOF
source "https://rubygems.org"
gem "hook_master", path: "../hook_master"
EOF
bundle config set --local path 'vendor/bundle'
bundle install
git add Gemfile Gemfile.lock
git commit -m "Setup project with HookMaster"
bundle exec hook_master init
bundle exec hook_master install
bundle exec rubocop -A
