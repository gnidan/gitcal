class GithubActivity
  def initialize
    @client = Github::Client::Activity::Events.new oauth_token: Settings.github.token
  end

  def github_events_from(username)
    events = @client.performed user: username

    events = events.collect do |event|
      case event.type
      when 'IssueCommentEvent'
        num = event.payload.issue.number
        title = event.payload.issue.title
        date = Time.parse(event.created_at)
        body = event.payload.comment.body

        GithubEvent.new(num, title, date, body)
      when 'PullRequestReviewCommentEvent'
        num = event.payload.pull_request.number
        title = event.payload.pull_request.title
        date = Time.parse(event.created_at)
        body = event.payload.comment.body

        GithubEvent.new(num, title, date, body)
      else
        nil
      end
    end

    events.reject(&:nil?)
  end
end
