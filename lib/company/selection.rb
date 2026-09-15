module Company
  # A list narrowed to one technician where the platform could not narrow it itself: the list
  # it came from is walked as it was, and only what the technician is on comes through.
  class Selection < Collection
    # @param collection [Collection] list to walk.
    # @param technician [Technician] whoever the records that come through are assigned to.
    def initialize(collection:, technician:)
      @collection = collection
      @technician = technician
    end

    # @yield [Resource] each record the technician is on, in the order the list answered it.
    def each
      @collection.each { |record| yield record if assigned? record }
    end

    # @param from [Time, nil] moment the window opens, or nothing for as far back as it goes.
    # @param to [Time, nil] moment the window closes, or nothing for as far ahead as it goes.
    # @return [Selection] the same technician, over the list narrowed to the window.
    def between(from, to)
      self.class.new collection: @collection.between(from, to), technician: @technician
    end

  private

    def assigned?(record) = record.technicians.any? { |each| each.id == @technician.id }
  end
end
