# The least a gem writes to answer the vocabulary: an account over a few records of its own,
# each field left nil only where Jobber or Housecall Pro would leave it nil too.
module Acme
  # The credentials to a business that keeps its books in a constant.
  class Account < Company::Account
    def business = Business.new node: Business::NODE

    def jobs = Jobs.new

    def visits = Visits.new

    def technicians = Technicians.new

    def leads = Leads.new
  end
end
