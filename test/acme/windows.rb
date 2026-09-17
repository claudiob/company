module Acme
  # The free time of the crew: what is left of the week once the visits are out of it. One of
  # the two is free twice and the other once, so narrowing to a technician has something to
  # take away.
  class Windows < Company::Windows
    # Both ends off one moment, so a stretch is exactly as long as it says it is.
    def self.free(from, long) = { starts_at: from, ends_at: from + long }

    NODES = {
      'technician-1' => [ free(2.days.from_now, 3.hours), free(5.days.from_now, 8.hours) ],
      'technician-2' => [ free(3.days.from_now, 4.hours) ],
    }

    def initialize(technician: nil, from: nil, to: nil)
      @technician = technician
      @from = from
      @to = to
    end

    def each
      nodes.each do |node|
        yield Company::Window.new node: node if (@from..@to).cover? node[:starts_at]
      end
    end

    def between(from, to) = with(from: from, to: to)

    def of(id) = with(technician: id)

  private

    def nodes = @technician ? NODES.fetch(@technician, []) : NODES.values.flatten

    def with(**changed)
      self.class.new(**{ technician: @technician, from: @from, to: @to }.merge(changed))
    end
  end
end
