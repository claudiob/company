require 'test_helper'

# The rest of the tutorial: one technician's week, read off the visits the account holds.
class AcmeScheduleTest < Minitest::Test
  def setup = @account = Acme::Account.new

  def test_the_crew_reads_by_the_same_names_on_every_platform
    technician = @account.technicians.first

    assert_equal %w[technician-1 technician-2], @account.technicians.ids
    assert_equal 'technician-1', technician.id
    assert_equal 'Grace', technician.name
    assert_equal 'Hopper', technician.surname
    assert_equal %i[id name surname], Company::Technician.node_keys
  end

  # A visit names whoever it is booked for, and a platform that cannot narrow a list by them
  # gets the narrowing for free: the window is walked and the visits they are on come through.
  def test_a_week_is_the_visits_in_it_narrowed_to_one_technician
    alan = @account.technicians.find { |each| each.id == 'technician-2' }

    assert_equal %w[technician-1 technician-2], @account.visits.upcoming.first.technicians.map(&:id)
    assert_equal %w[visit-2 visit-3], @account.visits.of(alan.id).ids
    grace = @account.technicians.first

    assert_equal %w[visit-1 visit-2 visit-4], @account.visits.of(grace.id).ids
  end

  # The other half of a schedule: not the hours somebody is out, but the ones they are not.
  # A window names nobody and nothing, so a platform that cannot tell one person's free time
  # from another's says so rather than answering with none -- an empty week and a full one
  # would otherwise read the same.
  def test_a_week_is_also_the_free_time_left_in_it
    grace, alan = @account.technicians.to_a

    assert_equal 3, @account.windows.upcoming(1.week).count
    assert_equal 2, @account.windows.upcoming(1.week).of(grace.id).count
    assert_equal 1, @account.windows.upcoming(1.week).of(alan.id).count

    window = @account.windows.upcoming(1.week).of(alan.id).first

    assert_equal 4.hours, window.ends_at - window.starts_at
    assert_equal %i[starts_at ends_at], Company::Window.node_keys
  end

  def test_a_platform_that_cannot_work_out_free_time_refuses_rather_than_answering_none
    assert_raises(NotImplementedError) { Company::Account.new.windows }
    assert_raises(NotImplementedError) { Company::Windows.new.of @account.technicians.first }
  end

  # One platform charges for what a row carries and another answers a record whole, so a caller
  # names what it reads either way and a gem with nothing to fetch hands back the same list.
  def test_asking_for_more_beside_each_record_costs_a_platform_that_charges_and_no_other
    week = @account.visits.upcoming(1.week)

    assert_equal week.ids, week.includes(location: :customer).ids
    assert_equal %w[technician-1 technician-2], @account.technicians.includes(:anything).ids
  end

  # Narrowing by technician and narrowing to a window commute, so a caller may ask in either
  # order and read the same week back.
  def test_a_technician_and_a_window_narrow_the_same_list_in_either_order
    grace = @account.technicians.first

    assert_equal %w[visit-2 visit-4], @account.visits.upcoming(1.week).of(grace.id).ids
    assert_equal %w[visit-2 visit-4], @account.visits.of(grace.id).upcoming(1.week).ids
    assert_equal %w[visit-1], @account.visits.of(grace.id).past.ids
  end
end
