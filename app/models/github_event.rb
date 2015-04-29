class GithubEvent
  def initialize(num, title, date, body='')
    @num = num
    @title = title
    @date = date
    @body = body
  end

  def to_ical
    event = Icalendar::Event.new
    event.start = (@date - 1.hour).strftime("%Y%m%dT%H%M%S")
    event.end = @date.strftime("%Y%m%dT%H%M%S")
    event.summary = "#{@num} - #{@title}"
    event.description = @body
    event.location = "computer"
    event
  end
end
