require 'pry'
class Rebaser < Struct.new(:track_type, :track_name, :original_story)

  def rebase
    if original_story.match("main")
      puts "Cannot rebase from main; just rbi"
      exit 1
    end

    old_main = find_main_branch

    if old_main.match("-v\d*")
      new_main = increment_branch_version(old_main)
    else
      new_main = "main-v2"
    end

    puts "rebasing #{original_story_branch} on #{branch_for(old_main)}".green
    puts `git rebase #{branch_for(old_main)}`

    puts "checking out #{branch_for(old_main)}".green
    repo.branch(branch_for(old_main)).checkout

    puts "creating and checking out #{branch_for(new_main)}".green
    repo.branch(branch_for(new_main)).create
    repo.branch(branch_for(new_main)).checkout

    puts "rebasing integration".green
    puts `git rebase integration`

    puts "checking out #{original_story_branch}".green
    repo.branch(original_story_branch).checkout

    puts "rebasing commits from #{branch_for(old_main)} to #{original_story_branch} onto #{branch_for(new_main)}".green

    puts `git rebase --onto #{branch_for(new_main)} #{branch_for(old_main)} #{original_story_branch}`
  end

  private

  def increment_branch_version(old_main)
    old_version = old_main.match(/-v(\d*)/)[1].to_i
    new_version = old_version + 1
    "main-v#{new_version}"
  end

  def find_main_branch
    branches = repo.branches.select {|b| b.name.match branch_prefix }.select {|b| b.name.match /main/ }.reject {|b| b.name.match /remotes/ }
    branches.sort_by(&:name).last.name.split("/").last
  end

  def original_story_branch
    "#{branch_prefix}/#{original_story}"
  end

  def branch_for(story)
    "#{branch_prefix}/#{story}"
  end

  def branch_prefix
    "#{track_type}/#{track_name}"
  end

  def repo
    @_repo ||= Git.open(".")
  end

end
