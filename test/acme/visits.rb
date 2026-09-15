module Acme
  # Booked time of every sort: a stop of a job that happened, one booked for any time of a day
  # ahead, one booked to look at work nobody has priced, and an hour blocked out at no address
  # at all. Each names who is going; only three of them say why.
  class Visits < Company::Visits
    NODES = [
      { id: 'visit-1', description: 'Fix the sink', starts_at: 1.month.ago,
        ends_at: 1.month.ago + 2.hours, anytime: false, job: { id: 'job-1' },
        location: { id: 'location-1', street: '1 Main St', zip: '27601' },
        technicians: [ Technicians::NODES.first ], },
      { id: 'visit-2', description: nil, starts_at: 3.days.from_now, ends_at: nil, anytime: true,
        job: { id: 'job-2' }, location: { id: 'location-2', street: '2 Main St', zip: '27601' },
        technicians: Technicians::NODES, },
      { id: 'visit-3', description: 'Look at the roof', starts_at: 2.days.from_now,
        ends_at: 2.days.from_now + 1.hour, anytime: false, lead: { id: 'lead-2' },
        location: { id: 'location-3', street: '3 Main St', zip: '27601' },
        technicians: [ Technicians::NODES.last ], },
      { id: 'visit-4', description: 'Dentist', starts_at: 4.days.from_now,
        ends_at: 4.days.from_now + 1.hour, anytime: false,
        technicians: [ Technicians::NODES.first ], },
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

    def create(name:, surname:, phone:, email:, address:, description:, notes:, source:,
      starts_at:, ends_at:, technicians:)
      crew = technicians.map { |each| { id: each.id } }
      place = address.merge id: 'location-5'
      Company::Visit.new node: { id: 'visit-5', description: description, anytime: false,
        starts_at: starts_at, ends_at: ends_at, technicians: crew, location: place,
        lead: { id: 'lead-3', description: description, notes: notes, source: source,
                location: place,
                customer: { id: 'customer-4', name: name, surname: surname, phone: phone,
                            email: email, }, }, }
    end
  end
end
