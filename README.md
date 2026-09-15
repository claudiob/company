# Company

One vocabulary for the records a field-service business keeps, whichever platform keeps them.
An account opens the business behind a set of credentials and the jobs, visits and leads it
holds; a gem that speaks to one platform subclasses `Company::Account` and the kinds it answers
for, and every reader is named here, once.

## How to install

To install on your system, run

    gem install company

To use inside a bundled Ruby project, add this line to the `Gemfile`:

    gem 'company', '~> 1.0'

Semantic Versioning promises that `~> major.minor` never crosses a breaking change, so the pin
takes every 1.x release and stops short of 2.0.

## How it reads

Given a gem that answers the vocabulary -- call it Acme -- a caller never learns how Acme's
platform spells a field, pages a list or counts its money:

```ruby
account = Acme::Account.new credentials  # => #<Acme::Account>

business = account.business              # => #<Acme::Business>
business.id                              # => '42'
business.name                            # => 'Acme, Inc.'
business.phone                           # => '5555555555'
business.subsidiaries                    # => [#<Acme::Business>, ...]

jobs = account.jobs.past(3.months)       # => #<Acme::Jobs>
jobs.ids                                 # => ['j1', 'j2', ...]

job = jobs.first
job.id                                   # => 'j1'
job.description                          # => 'Repair'
job.notes                                # => 'Ring twice'
job.created_at                           # => 2026-09-03 06:00:00 UTC
job.scheduled_at                         # => 2026-09-10 01:00:00 UTC
job.completed_at                         # => nil
job.amount                               # => 19.99

quote = job.quote                        # => #<Acme::Quote>, or nil where the job was won without one
quote.id                                 # => 'q1'
quote.amount                             # => 24.99

line = job.lines.first                   # => #<Acme::Line>
line.id                                  # => 'l1'
line.name                                # => 'Labor'
line.description                         # => 'Hours to fix the issue'
line.quantity                            # => 1.5
line.amount                              # => 24.99

location = job.location                  # => #<Acme::Location>
location.id                              # => 'a1'
location.street                          # => '100 Acme Circle'
location.city                            # => 'Springfield'
location.zip                             # => '98920'
location.latitude                        # => 45.2335
location.longitude                       # => -9.1234

customer = location.customer             # => #<Acme::Customer>
customer.id                              # => 'c1'
customer.name                            # => 'Jane'
customer.surname                         # => 'Qi'
customer.email                           # => 'jane@example.com'
customer.phone                           # => '5555555666'

visits = account.visits.upcoming(1.day)  # => #<Acme::Visits>, stops of jobs and of leads
visits.ids                               # => ['v1', 'v2', ...]

visit = visits.first                     # => #<Acme::Visit>
visit.id                                 # => 'v1'
visit.description                        # => 'Service appointment'
visit.starts_at                          # => 2026-09-10 01:00:00 UTC
visit.ends_at                            # => 2026-09-10 02:00:00 UTC
visit.anytime?                           # => false
visit.job                                # => job, or nil where the stop is a lead's
visit.lead                               # => lead, or nil where the stop is a job's
visit.technicians                        # => [#<Acme::Technician>, ...]

visits.for_jobs                          # => only the stops of jobs
visits.for_leads                         # => only the stops of leads

booked = account.visits.create name: 'Jane', surname: 'Qi', phone: '5555555666',
  email: 'jane@example.com', address: { street: '100 Acme Circle', zip: '98920' },
  description: 'Repair', notes: 'Estimate $20-$30', source: 'Website',
  starts_at: 1.day.from_now, ends_at: 1.day.from_now + 1.hour, technicians: [technician]
booked.lead                              # => #<Acme::Lead>, opened with the stop
booked.lead.location                     # => #<Acme::Location>, where to go

technician = account.technicians.first   # => #<Acme::Technician>
technician.id                            # => 't1'
technician.name                          # => 'Grace'
technician.surname                       # => 'Hopper'

week = account.visits.between(monday, sunday).assigned_to(technician)
week.ids                                 # => ['v1', 'v2', ...]

lead = account.leads.create name: 'Jane', surname: 'Qi', phone: '5555555666',
  email: 'jane@example.com', address: { street: '100 Acme Circle', zip: '98920' },
  description: 'Repair', notes: 'Estimate $20–$30', source: 'Website'
lead.id                                  # => 'd1'
lead.customer                            # => #<Acme::Customer>
```

A moment reads as a `Time`, an amount as dollars in a `BigDecimal`, a phone as the ten digits to
dial, and a field the platform holds nothing for as nil. A list is walked a page at a time, as
far as it goes or narrowed: to a window measured from now, to the technician the records are
booked for, or to one kind of stop. The narrowings compose in any order, so one technician's
week reads the same whichever is asked for first.

A visit is any booked time, not only work that is already a job. A stop to look at something
nobody has priced yet -- Jobber calls it an assessment, Housecall Pro an estimate -- is a visit
that names a `lead` and no `job`, and it occupies the technician's day exactly as a job's stop
does. `quote` stays the price, which is the other half of what Housecall Pro files as one
record.

## Answering as a gem

A gem subclasses `Company::Account` and answers the readers its platform offers, and subclasses
a kind wherever its platform spells a key otherwise than the vocabulary:

```ruby
class Acme::Account < Company::Account
  def business = Business.new node: read('company')
  def jobs = Jobs.new account: self
end

class Acme::Business < Company::Business
  def self.keys = { phone: :phone_number }
end

class Acme::Jobs < Company::Collection
  def each = ...                     # walk the platform's pages, yielding a Job each
  def between(from, to) = ...        # the same list, narrowed to what starts between the two
end
```

`Company::Business.node_keys` then answers `[:id, :name, :phone_number]`: exactly what to ask
the platform for. A reader the gem leaves out raises `NotImplementedError` naming the gem; leads
it leaves out refuse to file one, and so do the visits. `assigned_to`, `for_jobs` and
`for_leads` a gem leaves out still answer: `Company::Selection` walks the list and lets through
what the rule keeps, so only a platform that can put the question to its server writes the
method, and only to save the requests the walk would spend. The least a gem writes is under `test/acme`, and the test that
runs every reader through it, `test/company/acme_test.rb`, reads as a tutorial.

## Errors

Every error a gem raises descends from `Company::Error`, so one rescue catches the lot, and one
for a request held to a rate from `Company::Throttled`, so one retry covers every platform.

## Development

`bin/setup` gets a clone working, `bin/console` opens a prompt with the library loaded, and
`bundle exec rake` runs the suite, the linter and the two size limits -- which is what CI runs
too.

## Reference

The API reference is built from what RubyGems holds, at
[rubydoc.info/gems/company](https://rubydoc.info/gems/company). The source is at
[github.com/claudiob/company](https://github.com/claudiob/company).

## License

MIT, see [LICENSE.txt](LICENSE.txt).
