require 'rubygems'
require 'icalendar'
class CalendarController < ApplicationController
  def commits
    repo_path = "#{Settings.workspace}/#{params[:repo]}"
    @repository = Repository.new(repo_path)
    @calendar = Icalendar::Calendar.new

    events = @repository.commit_events_from(params[:username])
    events.each do |event|
      @calendar.add event.to_ical
    end

    @calendar.publish
    headers['Content-Type'] = "text/calendar; charset=UTF-8"
    render :text => @calendar.to_ical
  end

  def github
    @activity = GithubActivity.new
    @calendar = Icalendar::Calendar.new

    events = @activity.github_events_from(params[:username])
    events.each do |event|
      @calendar.add event.to_ical
    end

    @calendar.publish
    headers['Content-Type'] = "text/calendar; charset=UTF-8"
    render :text => @calendar.to_ical
  end
end
