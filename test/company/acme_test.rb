require 'test_helper'

# How the vocabulary is used, as a suite and as a tutorial: Acme, under test/acme, is the least a
# gem writes to answer it, and every public reader is run through it here in the order a caller
# meets them. What is nil below is nil because Jobber or Housecall Pro leave it so.
class AcmeTest < Minitest::Test
  # A gem hands out an account over its credentials; here Acme keeps its books in constants.
  def setup = @account = Acme::Account.new

  # The account opens the business it belongs to. A franchise lists itself first among its
  # subsidiaries, then every branch under it, flat; a phone answers as the ten digits to dial.
  def test_the_account_opens_the_business_and_the_branches_under_it
    business = @account.business

    assert_equal 'acme', business.id
    assert_equal 'Acme Plumbing', business.name
    assert_equal '7044597540', business.phone
    assert_equal %w[acme acme-north], business.subsidiaries.map(&:id)
    assert_equal '7044597541', business.subsidiaries.last.phone
  end

  # A collection is walked lazily and narrowed to a window measured from now. `ids` is the cheap
  # question to ask where each record is then read on its own; here it costs the same walk.
  def test_the_jobs_are_walked_by_a_window_measured_from_now
    jobs = @account.jobs.past 3.years

    assert_equal %w[job-1], jobs.ids
    assert_equal %w[job-2], @account.jobs.upcoming(2.weeks).ids
    assert_equal %w[job-1 job-2], @account.jobs.ids
  end

  # A job reads whole: what it is called and what was written on it, its three moments, what it
  # comes to in dollars, the quote it was won with, its lines, and where it happens for whom.
  def test_a_job_reads_whole
    job = @account.jobs.past(3.years).first

    assert_equal 'job-1', job.id
    assert_equal 'Fix the sink', job.description
    assert_equal 'Ring twice', job.notes
    assert_in_delta 2.months.ago, job.created_at, 60
    assert_in_delta 1.month.ago, job.scheduled_at, 60
    assert_in_delta 1.month.ago + 2.hours, job.completed_at, 60
    assert_equal 260, job.amount
    assert_equal 'quote-1', job.quote.id
    assert_equal 240, job.quote.amount
    assert_equal [ 'Faucet', 'Trip fee' ], job.lines.map(&:name)
    assert_equal [ 3, 1 ], job.lines.map(&:quantity)
    assert_equal 180, job.lines.first.amount
    assert_equal '1 Main St', job.location.street
    assert_equal '27601', job.location.zip
    assert_equal 'Jane', job.location.customer.name
    assert_equal 'Doe', job.location.customer.surname
    assert_equal 'jane@example.com', job.location.customer.email
    assert_equal '5553335555', job.location.customer.phone
  end

  # A platform may hold nothing for a field, and then the reader answers nil: a job nobody
  # described, won with no quote and billed as nothing yet, for a business that goes by its own
  # name and has no surname and no email.
  def test_a_job_reads_nil_where_a_platform_holds_nothing
    job = @account.jobs.upcoming(2.weeks).first

    assert_equal 'job-2', job.id
    assert_nil job.description
    assert_nil job.notes
    assert_nil job.completed_at
    assert_nil job.quote
    assert_empty job.lines
    assert_equal 'Acme Property Management', job.location.customer.name
    assert_nil job.location.customer.surname
    assert_nil job.location.customer.email
  end

  # A kind names what it reads, and a gem asks its platform for exactly those keys, spelled
  # through the `keys` it maps: Acme's business spells its phone the way Housecall Pro does.
  def test_a_gem_asks_its_platform_for_the_keys_the_vocabulary_reads
    assert_equal %i[id description notes created_at scheduled_at completed_at amount],
      Company::Job.node_keys
    assert_equal %i[id name phone_number], Acme::Business.node_keys
  end
end
