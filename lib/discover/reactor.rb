module Reactor
  def apply(queue, *args)
    queue.map do |change|
      change.apply(self, *args)
    end.flatten.reject {|c| c == self }
  end
end
