Verify that generation works correctly

  $ delhi_events generate -i ./events.json
  $ ls output/
  events.html
  events.ics
  $ head output/events.ics |grep -v "^DTSTAMP"
  BEGIN:VCALENDAR
  PRODID:-//Delhi NCR Events//All Events//EN
  VERSION:0.1
  BEGIN:VEVENT
  UID:event-1@delhincr.events
  DTSTART:20230301T150000Z
  GEO:37.7749;-122.4194
  SUMMARY:Event 1
  DESCRIPTION:This is event 1
  $ head output/events.html
  <!DOCTYPE html>
  <html xmlns="http://www.w3.org/1999/xhtml"><head><title>Delhi NCR Events</title><link rel="stylesheet" href="https://cdn.simplecss.org/simple.min.css"/></head><body><header><h1>Delhi NCR events</h1><p>An aggregator for events in Delhi NCR by @punchagan and friends</p></header><div class="event-card"><a href="https://example.com/event1" class="event-title-link"><h2 class="event-title">Event 1</h2></a><p class="event-description">This is event 1</p><p class="event-venue">Venue: Conference Hall</p><p class="event-time">Time: 2023-03-01 15:00</p></div><div class="event-card"><a href="https://example.com/event2" class="event-title-link"><h2 class="event-title">Event 2</h2></a><p class="event-description">This is event 2</p><p class="event-venue">Venue: Theater</p><p class="event-time">Time: 2023-03-02 10:00 — 2023-03-02 12:00</p></div><div class="event-card"><a href="https://example.com/event3" class="event-title-link"><h2 class="event-title">Event 3</h2></a><p class="event-description">This is event 3</p><p class="event-venue">Venue: Park</p><p class="event-time">Time: 2023-03-03 09:00 — 2023-03-03 11:00</p></div></body></html>
