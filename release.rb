require 'octokit'

repo = 'masiuchi/circleci-github-create-tag-test'
tag_name = `cat ./version`
tag_name.chomp!

client = Octokit::Client.new(access_token: ENV['GITHUB_TOKEN'])

release = client.create_release(repo, tag_name)
client.upload_asset(release.url, './test.zip')
