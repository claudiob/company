module Company
  # The gateway a set of credentials opens on a platform: the business they belong to and the
  # records it holds. A gem subclasses it and answers what its platform offers; a reader it
  # leaves out raises NotImplementedError, and the leads it leaves out refuse to file one.
  class Account
    # @return [Business] business the credentials belong to.
    def business = unanswered :business

    # @return [Collection] jobs of the business, each a {Job}; a platform may also `find` one.
    def jobs = unanswered :jobs

    # @return [Visits] visits of the business, each a {Visit}; a platform may also `find` one.
    def visits = unanswered :visits

    # @return [Collection] technicians of the business, each a {Technician}.
    def technicians = unanswered :technicians

    # @return [Windows] free time of the business, each a {Window}, where the platform works it out.
    def windows = unanswered :windows

    # @return [Leads] leads of the business: `create` files one, where the platform takes leads.
    def leads = Leads.new

  private

    def unanswered(name) = raise NotImplementedError, "#{self.class} does not answer #{name}"
  end
end
