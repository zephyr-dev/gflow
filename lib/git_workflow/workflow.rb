module GitWorkflow
  class Workflow < Struct.new(:args)
    def execute
      current_branch = `git rev-parse --abbrev-ref HEAD | awk '{ print $1 }'`.chomp
      track_type, track_name, story_name = current_branch.split("/")

      unless track_type == 'track'
        puts "Must be on a track branch."
        exit 1
      end

      rebaser = Rebaser.new(track_type, track_name, story_name)
      rebaser.rebase
    end
  end
end
