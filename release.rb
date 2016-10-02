require 'octokit'

version_file = 'version'
repo = 'masiuchi/circleci-github-create-tag-test'
tag_name = `cat #{version_file}`
tag_name.chomp!

unless ENV.key?('CIRCLECI')
  puts 'This script runs only on CircleCI'
  exit
end

changed_files = `git diff --name-only HEAD~`
changed_files.chomp!
is_version_file_changed = `echo "#{changed_files}" | grep #{version_file}`

if is_version_file_changed.to_s.empty?
  puts "This commit does not change #{version_file}"
  exit
end

client = Octokit::Client.new(access_token: ENV['GITHUB_TOKEN'])
release = client.create_release(repo, tag_name)
client.upload_asset(release.url, './test.zip')
