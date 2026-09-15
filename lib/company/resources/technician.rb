module Company
  # A person the business sends out: whoever a visit is booked for.
  class Technician < Resource
    # What every technician reads, by the vocabulary's names.
    def self.attributes = %i[id name surname]

    # @return [String, nil] what they go by: a given name.
    def name = attribute :name

    # @return [String, nil] their surname.
    def surname = attribute :surname
  end
end
