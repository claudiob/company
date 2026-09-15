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
    assert_equal %w[visit-2 visit-3], @account.visits.assigned_to(alan).ids
    grace = @account.technicians.first

    assert_equal %w[visit-1 visit-2 visit-4], @account.visits.assigned_to(grace).ids
  end

  # Narrowing by technician and narrowing to a window commute, so a caller may ask in either
  # order and read the same week back.
  def test_a_technician_and_a_window_narrow_the_same_list_in_either_order
    grace = @account.technicians.first

    assert_equal %w[visit-2 visit-4], @account.visits.upcoming(1.week).assigned_to(grace).ids
    assert_equal %w[visit-2 visit-4], @account.visits.assigned_to(grace).upcoming(1.week).ids
    assert_equal %w[visit-1], @account.visits.assigned_to(grace).past.ids
  end
end
