module Company
  # One stop of a job: when the work is scheduled to happen, where the job does.
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

    # @return [Job, nil] job the stop belongs to, where it came back beside the visit.
    def job = record Job, :job

    # @return [Array<Technician>] whoever the stop is booked for, where the platform names them.
    def technicians = records Technician, :technicians
  end
end
