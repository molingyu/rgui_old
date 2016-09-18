require_relative  '../lib/event/event'

event = Event::EventManger.new

event.on(:shit){|em, info|
  p em.this
  em.wait(2)
  p 233
  em.delete
  p event.trigger(:shit)
}

event.trigger(:shit)

loop{
  event.update
}