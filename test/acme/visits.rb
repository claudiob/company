module Acme
  # The stops of the jobs: one that happened, one booked for any time of a day ahead, each
  # naming who it is booked for.
  class Visits < Company::Collection
    NODES = [
      { id: 'visit-1', description: 'Fix the sink', starts_at: 1.month.ago,
        ends_at: 1.month.ago + 2.hours, anytime: false, job: { id: 'job-1' },
        technicians: [ Technicians::NODES.first ], },
      { id: 'visit-2', description: nil, starts_at: 3.days.from_now, ends_at: nil, anytime: true,
        job: { id: 'job-2' }, technicians: Technicians::NODES, },
    ]

    def initialize(from: nil, to: nil)
      @from = from
      @to = to
    end

    def each
      NODES.each do |node|
        yield Company::Visit.new node: node if (@from..@to).cover? node[:starts_at]
      end
    end

    def between(from, to) = self.class.new(from: from, to: to)
  end
end
