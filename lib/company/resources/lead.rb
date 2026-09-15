module Company
  # Somebody who asked the business for work and is not a customer yet.
  class Lead < Resource
    # What every lead reads, by the vocabulary's names.
    def self.attributes = %i[id]

    # @return [Customer, nil] customer the lead was filed for, where they came back beside it.
    def customer = record Customer, :customer

    # @return [Location, nil] where the work would happen, where the platform named it.
    def location = record Location, :location
  end
end
