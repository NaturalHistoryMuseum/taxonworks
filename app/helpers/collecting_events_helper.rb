module CollectingEventsHelper

  def collecting_event_tag(collecting_event)
    # collecting_event.cached.blank? ? 'CACHED VALUE NOT BUILT - CONTACT ADMIN' : collecting_event.cached
    collecting_event.verbatim_locality
  end

  def collecting_event_link
    link_to(collecting_event_tag(collecting_event), collecting_event)
  end

end
