[![Actions Status](https://github.com/lizmat/JSON-RepositoryEvent/actions/workflows/linux.yml/badge.svg)](https://github.com/lizmat/JSON-RepositoryEvent/actions) [![Actions Status](https://github.com/lizmat/JSON-RepositoryEvent/actions/workflows/macos.yml/badge.svg)](https://github.com/lizmat/JSON-RepositoryEvent/actions) [![Actions Status](https://github.com/lizmat/JSON-RepositoryEvent/actions/workflows/windows.yml/badge.svg)](https://github.com/lizmat/JSON-RepositoryEvent/actions)

NAME
====

JSON::RepositoryEvent - representation of a repository event

SYNOPSIS
========

```raku
use JSON::RepositoryEvent;
my $io = "foo.json".IO;

# create from incoming request
my $new = JSON::RepositoryEvent.new(%data, request);
$io.spurt(to-json($new));

# create from existing file
my $saved = JSON::RepositoryEvent.new($io.slurp);
```

DESCRIPTION
===========

The `JSON::RepositoryEvent` provides a distribution for mapping repository related events in JSON format (such as typically provided by collaborative services such as Github / Codeberg in a webhook) into Raku classes with an object oriented interface.

All classes can be instantiated with the `.new` method and providing a correctly structured `Map` (or `Hash`). This is specifically needed when processing JSON-files that have been previously saved with the [`JSON::Webhook`](https://raku.land/zef:lizmat/JSON::Webhook) module.

CREATION FROM A WEBHOOK
=======================

The `JSON::RepositoryEvent` object can (also) be created using the information that is available inside a `Cro::HTTP::Router` route.

```raku
# create from incoming request
my $new = JSON::RepositoryEvent.new(%data, request);
```

The first argument is the data structure (usually a `Map` or a `Hash`, the second argument is the `Cro::HTTP::Request` object which contains all of the information needed.

JSON::RepositoryEvent
=====================

The `JSON::RepositoryEvent` class wraps the data from a request in the `payload` accessor: this then contains an instances of any of the other `JSON::RepositoryEvent::xxx` classes.

METHODS
-------

  * class - the type-object of the type of the payload

  * created-at - DateTime or Nil

  * headers - "key: value" of each header in the request

  * irc - list of IRC channels (named argument "irc" in request)

  * nameds - named arguments in query

  * payload - data blessed as a JSON::RepositoryEvent::xxx class

GITHUB CLASSES
==============

The full name of these classes is `JSON::RepositoryEvent::Github::xxx`. The `JSON::RepositoryEvent` part is not mentioned here in the documentation for convenience.

GitHub::PullRequest
-------------------

  * action - action performed

  * organization - see GitHub::Organization

  * number - pull request number

  * pull-request - see Github::PullRequest::PullRequest

  * repository - see Github::Repository

  * sender - see Github::Actor

GitHub::CheckRun
----------------

  * action - action performed

  * check-run - see GitHub::CheckRun::CheckRun

  * repository - see Github::Repository

  * sender - see Github::Actor

GitHub::CheckSuite
------------------

  * action - action performed

  * check-suite - see GitHub::CheckSuite::CheckSuite

  * repository - see Github::Repository

  * sender - see Github::Actor

GitHub::Push
------------

  * after - SHA of previous commit

  * base-ref - SHA of base reference

  * before - SHA of next commit

  * commits - list of one or more Github::PushCommit object

  * compare - compare URL

  * created - list of files created

  * deleted - list of files deleted

  * forced - was the push forced?

  * ref - SHA of reference

  * head-commit - see GitHub::PushCommit

  * pusher - see GitHub::Person

  * repository - see Github::Repository

  * sender - see Github::Actor

GitHub::WorkflowJob
-------------------

  * action - action performed

  * repository - see Github::Repository

  * sender - see Github::Actor

  * workflow - see Github::Workflow

  * workflow-job - see Github::WorkflowJob::WorkflowJob

GitHub::WorkflowRun
-------------------

  * action - action performed

  * repository - see Github::Repository

  * sender - see Github::Actor

  * workflow - see Github::Workflow

  * workflow-run - see Github::WorkflowRun::WorkflowRun

FORGEJO CLASSES
===============

Forgejo::Issues
---------------

  * action - the action performed on an issue

  * commit-id - SHA of associated commit

  * issue - see Forgejo::Issue

  * number - the issue number

  * repository - see Forgejo::Repository

  * sender - see Forgejo::Actor

Forgejo::Push
-------------

  * after - SHA of previous commit

  * before - SHA of next commit

  * commits - list of one or more Forgejo::Commit object

  * compare-url - compare URL

  * head-commit - see Forgejo::Commit

  * pusher - see Forgejo::Actor

  * ref - SHA of reference

  * repository - see Forgejo::Repository

  * sender - see Forgejo::Actor

  * total-commits - number of commits in this push

NAMING LOGIC
============

The data structures in the GitHub and Forgejo (e.g. Codeberg) API's typically use underscores in their names. No underscores are used in the Raku classes. If a name is mapped to a class, then an underscore created camelcase class names. So "pull_request" becomes `PullRequest` as a class name. Other fields that have an underscore map the underscores to hyphens, so "created_at" as the name of a field in the data structure, becomes "created-at" as an accessor (method name).

THEORY OF OPERATION
===================

The underlying data structure is always a `Map` (or a `Hash`). All classes are subclasses of `Map`, so all the functionality that you can expect from a `Map` can be used on any of the classes in this distribution.

All classes could be considered to be "views" on the underlying data structure: all "accessors" are in fact accessing certain parts of that data structure by key. This approach allows for fast loading: only actual parts of the data structure that need to be accessed, will be fetched on demand.

AUTHOR
======

Elizabeth Mattijsen <liz@raku.rocks>

COPYRIGHT AND LICENSE
=====================

Copyright 2026 Elizabeth Mattijsen

Source can be located at: https://codeberg.org/lizmat/JSON-RepositoryEvent . Comments and Pull Requests are welcome.

If you like this module, or what I'm doing more generally, committing to a [small sponsorship](https://github.com/sponsors/lizmat/) would mean a great deal to me!

This library is free software; you can redistribute it and/or modify it under the Artistic License 2.0.

