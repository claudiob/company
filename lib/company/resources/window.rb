module Company
  # Free time: a stretch nobody is booked for, which somebody could be sent out in. It names no
  # work and nobody going, a list of them having been asked for one technician already, and it
  # is as long as it is -- cut it into offerable pieces where an offer is being made, since only
  # the caller making one knows how long it needs them to be.
  class Window < Resource
    # What every window reads, by the vocabulary's names.
    def self.attributes = %i[starts_at ends_at]

    # @return [Time] moment the free stretch opens.
    def starts_at = time :starts_at

    # @return [Time] moment the free stretch closes.
    def ends_at = time :ends_at
  end
end
