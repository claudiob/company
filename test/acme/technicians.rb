module Acme
  # The crew: two on the books, one of whom works alone.
  class Technicians < Company::Collection
    NODES = [ { id: 'technician-1', name: 'Grace', surname: 'Hopper' },
              { id: 'technician-2', name: 'Alan', surname: 'Turing' }, ]

    def each = NODES.each { |node| yield Company::Technician.new node: node }
  end
end
