class CommitEvent
  def initialize(source, date, message, sha)
    @source = source
    @date = date.localtime
    @message = message
    @sha = sha
  end

  def to_ical
    event = Icalendar::Event.new
    event.start = (@date - 1.hour).strftime("%Y%m%dT%H%M%S")
    event.end = @date.strftime("%Y%m%dT%H%M%S")
    event.summary = @source
    event.description ="#{@sha}\n\n#{@message}"
    event.location = "computer"
    event
  end
end
