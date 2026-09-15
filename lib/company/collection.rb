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

    # A platform that can ask its server for one technician's work narrows the list there; one
    # that cannot walks the list and keeps what the technician turns out to be on.
    # @param technician [Technician] whoever the work is booked for.
    # @return [Collection] the same list, narrowed to what they are assigned to.
    def assigned_to(technician) = Selection.new collection: self, technician: technician

    # @return [Array<String>] ID of every record, the list walked; a platform with a cheaper
    #   way to ask answers it that way instead.
    def ids = map(&:id)
  end
end
