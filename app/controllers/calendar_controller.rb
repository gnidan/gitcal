require 'rubygems'
require 'icalendar'
class CalendarController < ApplicationController
  def index
    @repository = Repository.new("$DFHOME/www")
    @calendar = Icalendar::Calendar.new

    events = @repository.commit_events_from('gnidan')
    events.each do |event|
      @calendar.add event.to_ical
    end

    @calendar.publish
    headers['Content-Type'] = "text/calendar; charset=UTF-8"
    render :text => @calendar.to_ical
  end
end
