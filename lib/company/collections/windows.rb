module Company
  # The free time of a business: every stretch somebody could be sent out in, over the window
  # asked for. A platform that works it out answers this; one that does not know when its
  # business is open cannot, and says so rather than answering with none, an empty list being
  # the same shape as a fully booked week.
  class Windows < Collection
    # A window names nobody, a list of them having been narrowed to one technician already, so
    # there is nothing here to walk and keep: only the platform can tell one person's free time
    # from another's.
    # @param id [String] ID the platform files whoever is free under.
    # @return [Windows] the same list, as that technician's alone.
    def of(id)
      raise NotImplementedError, "#{self.class} does not answer one technician's windows"
    end
  end
end
