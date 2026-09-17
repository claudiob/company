module Company
  # A list of records an account holds, walked however the platform pages it and narrowed to a
  # window measured from now, or to one technician. A gem answers `each`, and `between` with
  # the same list narrowed to what starts between two moments, either one open.
  class Collection
    include Enumerable

    # Both ends are measured from one moment, so nothing slides between them.
    # @param within [ActiveSupport::Duration, nil] how far ahead to look, or as far as there is.
    # @return [Collection] the same list, narrowed to what starts from now on.
    def upcoming(within = nil)
      now = Time.now
      between now, within && now + within
    end

    # @param within [ActiveSupport::Duration, nil] how far back to look, or as far as there is.
    # @return [Collection] the same list, narrowed to what started before now.
    def past(within = nil)
      now = Time.now
      between within && now - within, now
    end

    # What to bring back beside each record, for a platform that charges for the asking. One
    # that answers a record whole has nothing to ask for and answers the same list, so a caller
    # names what it reads without knowing which kind of platform it is talking to.
    # @param names [Array<Symbol, Hash>] what to read beside each record, as the gem names them.
    # @return [Collection] the same list, bringing those back where that costs anything.
    def includes(*names) = self

    # A platform that can ask its server for one technician's work narrows the list there; one
    # that cannot walks the list and keeps what they turn out to be on. It takes the ID the
    # platform files them under rather than the technician, that being the whole of what any
    # platform asks by: a caller holding a record of its own then names the ID it knows, rather
    # than dressing it up as a technician it does not have.
    # @param id [String] ID the platform files whoever the work is booked for under.
    # @return [Collection] the same list, narrowed to theirs.
    def of(id)
      Selection.new(collection: self) do |record|
        record.technicians.any? { |technician| technician.id == id }
      end
    end

    # @return [Array<String>] ID of every record, the list walked; a platform with a cheaper
    #   way to ask answers it that way instead.
    def ids = map(&:id)
  end
end
