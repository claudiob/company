module Company
  # The visits of a business: every stop somebody is booked for, of a job or of a lead where
  # the work is still being looked at. A gem answers `create` where its platform books a stop
  # against a lead, and `for_jobs` or `for_leads` where it can ask its platform for one kind
  # alone; where it cannot, the list is walked and the other kind let go.
  class Visits < Collection
    # Books a stop to look at work nobody has priced yet, opening the customer and whatever the
    # platform hangs the stop off wherever it has none.
    # @param name [String] given name of who asked, or the business's where a person has none.
    # @param surname [String, nil] their surname.
    # @param phone [String, nil] number they are reached on.
    # @param email [String, nil] address they are written to.
    # @param address [Hash, nil] where the work would happen: :street, :city, :state and :zip.
    # @param description [String] what the work is called.
    # @param notes [String, nil] what else was said about it.
    # @param source [String, nil] where the lead came from, as the business names its sources.
    # @param starts_at [Time] moment somebody is booked to arrive.
    # @param ends_at [Time, nil] moment they are booked to leave, or nothing for the platform's.
    # @param technicians [Array<Technician>] whoever is booked to go.
    # @return [Visit] stop as the platform booked it.
    def create(name:, surname:, phone:, email:, address:, description:, notes:, source:,
      starts_at:, ends_at:, technicians:)
      raise NotImplementedError, "#{self.class} does not book a visit"
    end

    # @return [Collection] the same list, narrowed to the stops of jobs.
    def for_jobs = Selection.new(collection: self, &:job)

    # @return [Collection] the same list, narrowed to the stops of leads.
    def for_leads = Selection.new(collection: self, &:lead)

    # Booked time a platform can say something about: the stops of jobs and of leads together,
    # without the hours blocked out around them, which name no work and cost a list of their own
    # on a platform that files them apart.
    # @return [Collection] the same list, narrowed to the stops of work of either kind.
    def for_work = Selection.new(collection: self) { |visit| visit.job || visit.lead }
  end
end
