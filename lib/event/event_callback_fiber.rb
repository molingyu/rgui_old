#encoding: utf-8
#author: shitake
#data: 16-7-8

module Event

  class EventCallbackFiber

    attr_reader :name
    attr_reader :info
    attr_reader :callback

    def initialize(name, callback, info)
      @name = name
      @info = info
      @callback = callback
      @fiber = Fiber.new do
        @callback.call(info)
        @fiber = nil
      end
      @return = nil
    end

    def resume
      if @return
        @fiber = nil
      else
        @return = @fiber.resume
      end
    end

    def alive?
      @fiber != nil
    end

  end

end