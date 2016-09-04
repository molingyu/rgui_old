#encoding: utf-8
#author: shitake
#data: 16-7-8

module Event

  class EventManger

    attr_accessor :this
    attr_accessor :event_fibers
    attr_accessor :timer
    attr_accessor :counter
    attr_accessor :timer_filter
    attr_accessor :counter_filter

    def initialize
      @events = {}
      @event_fibers = []
      @timer = {}
      @counter = {}
      @timer_filter = {}
      @counter_filter = {}
    end

    def update
      if @event_fibers != []
        @event_fibers.each do |o|
          next @event_fibers.delete(o) unless o.alive?
          $event = self
          $event.this = o
          o.resume
        end
      end
    end

    def trigger(name, info = nil)
      if @events[name]
        @events[name].each do |callback|
          @event_fibers.push(EventCallbackFiber.new(name, callback, info))
        end
      end
    end

    def on(name, index = nil, type = nil, &callback)
      @events[name] = @events[name] || Event.new(name, type)
      index = @events[name].length unless index
      @events[name][index] = callback
    end

    def time
      Time.now - $event.timer[self.object_id]
    end

    def time_filter
      Time.now - $event.timer_filter[self.object_id]
    end

    def index
      $event.counter[self.object_id]
    end

    def index_filter
      $event.counter_filter[self.object_id]
    end

    def ok?(&block)
      loop do
        break if block.call
        Fiber.yield
      end
    end

    def delete
      @events[$event.this.name].delete($event.this.block)
    end

    def wait(value)
      $event.timer[self.object_id] = Time.now unless $event.timer[self.object_id]
      loop do
        break $event.timer[self.object_id] = Time.now unless Time.now - $event.timer[self.object_id] < value
        Fiber.yield
      end
    end

    def wait_filter(value)
      return $event.timer_filter[self.object_id] = Time.now unless $event.timer_filter[self.object_id]
      loop do
        break $event.timer_filter[self.object_id] = Time.now unless Time.now - $event.timer_filter[self.object_id] < value
        Fiber.yield true
      end
    end

    def times(value)
      $event.counter[self.object_id] = 1 unless $event.counter[self.object_id]
      $event.counter[self.object_id] += 1
      loop do
        break $event.counter[self.object_id] = 1 if $event.counter[self.object_id] > value
        Fiber.yield
      end
    end

    def times_filter(value)
      return $event.counter_filter[self.object_id] = 1 unless $event.counter_filter[self.object_id]
      $event.counter_filter[self.object_id] += 1
      loop do
        break $event.counter_filter[self.object_id] = 1 if $event.counter_filter[self.object_id] > value
        Fiber.yield true
      end
    end

    def filter(&block)
      Fiber.yield true unless block.call($event.this.info)
    end

  end

end

