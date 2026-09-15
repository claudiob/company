# Changelog

All notable changes to this project will be documented in this file.

For more information about changelogs, check [Keep a Changelog](http://keepachangelog.com) and
[Vandamme](http://tech-angels.github.io/vandamme).

## 2.1.0 - 2026-09-15

* [Feature] `Company::Collection#includes(*names)`, what to bring back beside each record. A
  platform that charges for what a row carries answers it by asking for more; one that hands a
  record over whole has nothing to ask for and answers the same list. Either way a caller names
  what it reads without knowing which kind of platform it is talking to, which a caller sharing
  one code path across two of them could not do before
* [Feature] `Company::Visit#location`, where the stop is. A schedule is read to know who is
  where and when, so a visit says where without being asked what it was booked for, and a
  caller no longer reaches through `visit.job` for an address -- which a stop booked against a
  lead, or an hour blocked out against nothing, could never answer. `job` and `lead` say why a
  visit exists and either may be absent; `location` may be too, for booked time that is nowhere

## 2.0.0 - 2026-09-15

* [Breaking change] `Company::Selection` takes the rule to keep records by as a block rather
  than a technician, so one class answers `assigned_to`, `for_jobs` and `for_leads`. A gem
  building one by hand passes a block where it passed `technician:`
* [Feature] `Company::Technician` -- id, name, surname -- a person the business sends out, and
  `Company::Account#technicians`, the crew of the business
* [Feature] `Company::Visit#technicians`, whoever the stop is booked for
* [Feature] `Company::Collection#assigned_to(technician)`, the same list narrowed to what one
  technician is on. A gem answers it where its platform can put the question to the server;
  where none can, `Company::Selection` walks the list and keeps what the technician turns out
  to be on, so a week of one person's timeslots reads the same on every platform. Narrowing by
  technician and narrowing to a window commute
* [Feature] `Company::Visit#lead`, the lead a stop belongs to where it belongs to no job. A
  visit is any booked time now, not only a job's: the stop to look at work nobody has priced
  -- an assessment on Jobber, an estimate on Housecall Pro -- names a `lead` and no `job`, and
  occupies a technician's day the same way. `Company::Quote` still means the price
* [Feature] `Company::Lead#location`, where the work would happen, so a stop booked against a
  lead says where to go the way a job's stop does
* [Feature] `Company::Visits`, what a gem's list of visits subclasses: `create` books a stop
  against a lead, taking the words `Leads#create` takes plus `starts_at:`, `ends_at:` and
  `technicians:`, and `for_jobs` and `for_leads` narrow the list to one kind of stop

## 1.0.0 - 2026-09-09

* [Feature] `Company::Account`, the gateway a set of credentials opens: a gem subclasses it
  and answers `business`, `jobs`, `visits` and `leads` as its platform
  offers them; a reader left out raises `NotImplementedError` naming the gem and the reader
* [Feature] `Company::Collection`, what a list of an account's records is: `Enumerable`, and
  narrowed to a window measured from now by `upcoming(within)` and `past(within)`, both built
  on the `between(from, to)` a gem answers; `ids` walks it for the IDs unless a gem knows a
  cheaper way
* [Feature] `Company::Leads`, what files a lead: `create` takes the same words on every
  platform -- name, surname, phone, email, address, description, notes, source -- and a gem
  drops what its platform has no field for
* [Feature] `Company::Business` -- id, name, phone, subsidiaries -- who the credentials belong to.
  The subsidiaries are the business itself and then every business under it at any depth,
  flat, so the list is never empty; a gem whose platform nests them answers the ones directly
  under it from the private `below`
* [Feature] `Company::Lead` -- id, customer -- and `Company::Quote` -- id, amount
* [Feature] `Company::Job` -- id, quote, description, notes, created_at, scheduled_at,
  completed_at, amount, lines, location. The moments answer as Times however the platform
  wrote them and the amounts as dollars in a BigDecimal
* [Feature] `Company::Line` -- id, name, description, quantity, amount -- a whole quantity read
  whole
* [Feature] `Company::Visit` -- id, description, starts_at, ends_at, anytime?, job
* [Feature] `Company::Location` -- id, street, city, zip, latitude, longitude, customer -- and
  `Company::Customer` -- id, name, surname, email, phone
* [Feature] A record reads the node its platform answered under either kind of key; a kind
  names its attributes, a subclass names under `.keys` the node keys its platform spells
  otherwise -- `{ phone: :phone_number }` -- and `node_keys` answers them through the map, so
  a gem builds its query from what the vocabulary reads
* [Feature] A phone answers as the ten digits a North American number is, however the platform
  wrote it, and as nil where none is held or none can be dialed
* [Feature] `Company::Error`, what every error a platform gem raises descends from, and
  `Company::Throttled`, what a platform raises where it holds a request to a rate and answers
  the same question a little later

The draft that had `Company` included the way `Enumerable` is, answering `read`, with an
`Account` record and a `Company::Mock`, never shipped.

## 0.1.0 - 2026-08-28

* [Feature] First release: a library that loads and does not do anything yet
