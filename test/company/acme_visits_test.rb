require 'test_helper'

# The rest of the tutorial: the visits, a lead filed, and what a gem asks its platform for.
class AcmeVisitsTest < Minitest::Test
  def setup = @account = Acme::Account.new

  # A visit is one stop of a job, at the job's place: it names the job and no place of its own.
  # One booked for any time of the day has no end.
  def test_the_visits_are_walked_the_same_way_and_name_their_job
    visit = @account.visits.upcoming(2.weeks).first

    assert_equal %w[visit-2 visit-3 visit-4], @account.visits.upcoming.ids
    assert_nil visit.description
    assert_in_delta 3.days.from_now, visit.starts_at, 60
    assert_nil visit.ends_at
    assert visit.anytime?
    assert_equal 'job-2', visit.job.id
    assert_equal 'Fix the sink', @account.visits.past.first.description
    assert_equal %w[visit-1 visit-2 visit-3 visit-4], @account.visits.ids
  end

  # A schedule is read to know who is where, so a stop says where without being asked what it
  # was booked for. An hour blocked out is booked time too, and it is nowhere.
  def test_a_visit_says_where_it_is_whatever_it_was_booked_for
    booked = @account.visits.for_jobs.first
    blocked = @account.visits.find { |visit| visit.id == 'visit-4' }

    assert_equal '1 Main St', booked.location.street
    assert_equal '3 Main St', @account.visits.for_leads.first.location.street
    assert_equal 'Dentist', blocked.description
    assert_nil blocked.location
    assert_nil blocked.job
    assert_nil blocked.lead
    assert_equal %w[technician-1], blocked.technicians.map(&:id)
  end

  # A stop of a lead is the look at work nobody has priced yet: it names the lead and no job,
  # and a stop of a job names the job and no lead, so a caller asks for the kind it wants.
  def test_a_visit_stops_at_a_job_or_at_a_lead_and_says_which
    looked_at = @account.visits.for_leads.first

    assert_equal %w[visit-1 visit-2], @account.visits.for_jobs.ids
    assert_equal 'visit-3', looked_at.id
    assert_equal 'lead-2', looked_at.lead.id
    assert_nil looked_at.job
    assert_nil @account.visits.for_jobs.first.lead
    # And narrowing by kind and to a window narrow the same list, in either order
    assert_equal %w[visit-3], @account.visits.upcoming(1.week).for_leads.ids
    assert_equal %w[visit-3], @account.visits.for_leads.upcoming(1.week).ids
  end

  # Booking one takes the words a lead takes, plus when it is and who is going.
  def test_a_stop_is_booked_with_the_same_words_on_every_platform
    starts_at = 1.day.from_now
    visit = @account.visits.create name: 'Ada', surname: 'Lovelace', phone: '(555) 200-0001',
      email: 'ada@example.com', address: { street: '3 Main St', zip: '27601' },
      description: 'Look at the roof', notes: 'Estimate $100-$200', source: 'Website',
      starts_at: starts_at, ends_at: starts_at + 1.hour,
      technicians: @account.technicians.to_a

    assert_equal 'visit-5', visit.id
    assert_equal starts_at, visit.starts_at
    assert_equal %w[technician-1 technician-2], visit.technicians.map(&:id)
    assert_equal 'lead-3', visit.lead.id
    assert_equal '3 Main St', visit.lead.location.street
    assert_equal 'Ada', visit.lead.customer.name
    assert_equal '5552000001', visit.lead.customer.phone
  end

  # A platform that books no visit says so, naming the gem that does not.
  def test_a_gem_that_books_no_visit_refuses_to_book_one
    error = assert_raises NotImplementedError do
      Company::Visits.new.create name: 'Ada', surname: nil, phone: nil, email: nil, address: nil,
        description: 'Look at the roof', notes: nil, source: nil, starts_at: Time.now,
        ends_at: nil, technicians: []
    end

    assert_equal 'Company::Visits does not book a visit', error.message
  end

  # A lead is filed with the same words on every platform, and answers the customer opened for it.
  def test_a_lead_is_filed_with_the_same_words_on_every_platform
    lead = @account.leads.create name: 'Ada', surname: 'Lovelace', phone: '(555) 200-0001',
      email: 'ada@example.com', address: { street: '3 Main St', zip: '27601' },
      description: 'Fix the sink', notes: 'Estimate $100–$200', source: 'Website'

    assert_equal 'lead-1', lead.id
    assert_equal 'customer-3', lead.customer.id
    assert_equal 'Ada', lead.customer.name
    assert_equal '5552000001', lead.customer.phone
  end

  # A kind names what it reads, and a gem asks its platform for exactly those keys, spelled
  # through the `keys` it maps: Acme's business spells its phone the way Housecall Pro does.
  def test_a_gem_asks_its_platform_for_the_keys_the_vocabulary_reads
    assert_equal %i[id description notes created_at scheduled_at completed_at amount],
      Company::Job.node_keys
    assert_equal %i[id name phone_number], Acme::Business.node_keys
  end
end
