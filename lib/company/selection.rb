module Company
  # A list narrowed by something the platform could not be asked to narrow by: the list it came
  # from is walked as it was, and only what the rule keeps comes through.
  class Selection < Collection
    # @param collection [Collection] list to walk.
    # @yield [Resource] each record of it, to keep or to let go.
    def initialize(collection:, &kept)
      @collection = collection
      @kept = kept
    end

    # @yield [Resource] each record the rule kept, in the order the list answered it.
    def each
      @collection.each { |record| yield record if @kept.call record }
    end

    # @param from [Time, nil] moment the window opens, or nothing for as far back as it goes.
    # @param to [Time, nil] moment the window closes, or nothing for as far ahead as it goes.
    # @return [Selection] the same rule, over the list narrowed to the window.
    def between(from, to) = self.class.new(collection: @collection.between(from, to), &@kept)
  end
end
