class Repository
  def initialize(path)
    @path = path
  end

  def commit_events_from(author)
    log_options = [
      '--all',
      "--author=#{author}",
      "--source",
      "--no-merges",
      "--date=iso-strict"
    ]


    log_output = `cd #{@path} && git log #{log_options.join(' ')}`
    commits = log_output.split(/^commit/)

    commits = commits.collect do |commit|
      next unless commit.length > 0
      lines = commit.lines
      sha, src = lines.shift.split("\t")
      sha = sha.strip
      src = src.strip
      src.gsub!(/^refs\/heads\//, '')

      author = lines.shift
      date = lines.shift
      date.slice! "Date:"
      date.strip!
      date = Time.parse(date)

      message = lines.collect{|l| l.tr("\n", "")}.select{|l|l.length > 0}.collect(&:strip).join("\n")

      CommitEvent.new(src, date, message, sha)
    end
    commits = commits.reject{|c| c.nil?}
    commits.reverse
  end
end
