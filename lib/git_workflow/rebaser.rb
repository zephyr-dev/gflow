class Rebaser < Struct.new(:track_type, :track_name, :story)

  def rebase
    if story.match("main")
      puts "Cannot rebase from main; just rbi"
      exit 1
    end

    main_branch = find_main_branch

    if main_branch.match("-v\d*")
      new_branch = increment_branch_version(main_branch)
    else
      new_branch = "main-v1"
    end
    `git co -b #{branch_for_story(new_branch)} `
  end

  private

  def increment_branch_version(old_main)

  end

  def find_main_branch
    branches = `git branch -a | grep #{branch_prefix} | grep main | grep -v remotes`.split("\n")
    branches.sort.last.split("/").last
  end

  def branch_for_story(story)
    "#{branch_prefix}/#{story}"
  end

  def branch_prefix
    "#{track_type}/#{track_name}"
  end

end
