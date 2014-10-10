require 'spec_helper'

describe GitWorkflow do
  TEST_DIR = 'tmp/git_workflow_test'
  let(:repo) { Git.init(TEST_DIR) }

  before do
    reset_test_dir
    create_and_checkout "integration"

    create_and_checkout "tracks/track_name/main"
    add_and_commit_file "main"

    create "tracks/track_name/story2"
    create "tracks/track_name/story1"
    add_and_commit_file "story1"
    checkout "tracks/track_name/story2"
    add_and_commit_file "story2"

    checkout "tracks/track_name/main"
    add_and_commit_file "main2"

    checkout "integration"
    add_and_commit_file "integration2"
  end

  def reset_test_dir
    puts `rm -rf #{TEST_DIR}`
    puts `mkdir #{TEST_DIR}`
    add_and_commit_file("integration.file")
  end

  def add_and_commit_file(name)
    puts `touch #{TEST_DIR}/#{name}`
    repo.add(all: true)
    repo.commit("adds #{name}")
  end

  def create_and_checkout(branch)
    create(branch)
    checkout(branch)
  end

  def create(branch)
    repo.branch(branch).create
  end

  def checkout(branch)
    repo.branch(branch).checkout
  end


  it "works" do
    puts "******************"
    puts `cd #{TEST_DIR}; gflow`
    puts "******************"
  end
end
