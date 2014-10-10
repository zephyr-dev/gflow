require 'spec_helper'

describe GitWorkflow do
  TEST_DIR = 'tmp/git_workflow_test'
  let(:repo) { Git.init(TEST_DIR) }

  before do
    reset_test_dir
    initialize_repo
  end

  def reset_test_dir
    puts `rm -rf #{TEST_DIR}`
    puts `mkdir #{TEST_DIR}`
  end

  def initialize_repo
    add_and_commit_file("integration.file")
    create_and_checkout "integration"

    create_and_checkout "track/track_name/main"
    add_and_commit_file "main"

    create_and_checkout "track/track_name/story1"
    add_and_commit_file "story1"
    checkout "track/track_name/main"

    create_and_checkout "track/track_name/story2"
    add_and_commit_file "story2"

    checkout "track/track_name/main"
    add_and_commit_file "main2"

    checkout "integration"
    add_and_commit_file "integration2"

    checkout "track/track_name/story1"
  end

  def add_and_commit_file(name)
    `touch #{TEST_DIR}/#{name}`
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
    Bundler.with_clean_env do
      puts `cd #{TEST_DIR}; gflow`
    end
    puts "******************"

    expect(repo.current_branch).to eq("track/track_name/story1")
    expected_files = %w{integration.file integration2 main main2 story1}
    expect(`ls #{TEST_DIR}`.split).to eq(expected_files)
  end
end
