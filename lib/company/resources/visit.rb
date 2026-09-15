module Company
  # Booked time: somebody is somewhere for an hour. Where it is, who is going and when are what
  # a visit is for; the job or the lead it was booked against says why, and either may be absent.
  class Visit < Resource
    # What every visit reads, by the vocabulary's names.
    def self.attributes = %i[id description starts_at ends_at anytime]

    # @return [String, nil] what the stop is, in the words of whoever booked it.
    def description = attribute :description

    # @return [Time, nil] moment the visit is booked to start.
    def starts_at = time :starts_at

    # @return [Time, nil] moment the visit is booked to end.
    def ends_at = time :ends_at

    # @return [Boolean, nil] whether the visit may happen any time that day rather than at an hour.
    def anytime? = attribute :anytime

    # A stop says where it is without being asked what it was booked for, so a caller reading a
    # schedule never has to reach through a job to find an address.
    # @return [Location, nil] where the work happens, nil where the stop is booked nowhere.
    def location = record Location, :location

    # @return [Job, nil] job the stop belongs to, nil where no job was booked for it.
    def job = record Job, :job

    # @return [Lead, nil] lead the stop belongs to, nil where no lead was booked for it.
    def lead = record Lead, :lead

    # @return [Array<Technician>] whoever the stop is booked for, where the platform names them.
    def technicians = records Technician, :technicians
  end
end
