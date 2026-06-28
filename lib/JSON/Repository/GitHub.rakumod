use JSON::Repository::Helpers;

#- JSON::Repository::GitHub::Person --------------------------------------------
class JSON::Repository::GitHub::Person is Map { }
BEGIN add-simple-accessors JSON::Repository::GitHub::Person, <
  email name username
>;
BEGIN add-datetime-accessors JSON::Repository::GitHub::Person, <
  date
>;
#- JSON::Repository::GitHub::Actor --------------------------------------------
class JSON::Repository::GitHub::Actor is Map { }
BEGIN add-simple-accessors JSON::Repository::GitHub::Actor, <
  avatar-url email events-url followers-url following-url gists-url
  gravatar-id html-url id login name node-id organizations-url
  received-events-url repos-url site-admin starred-url subscriptions-url
  type url user-view-type
>;

#- JSON::Repository::GitHub::Commit --------------------------------------------
class JSON::Repository::GitHub::Commit is Map {
    method author() {
        bless-hash-as JSON::Repository::GitHub::Person, self<author>
    }
    method committer() {
        bless-hash-as JSON::Repository::GitHub::Person, self<committer>
    }
}
BEGIN add-simple-accessors JSON::Repository::GitHub::Commit, <
  distinct id message tree-id url
>;
BEGIN add-list-accessors JSON::Repository::GitHub::Commit, <
  added modified removed
>;
BEGIN add-datetime-accessors JSON::Repository::GitHub::Commit, <
  timestamp
>;

#- JSON::Repository::GitHub::License -------------------------------------------
class JSON::Repository::GitHub::License is Map { }
BEGIN add-simple-accessors JSON::Repository::GitHub::License, <
  key name node-id spdx-id url
>;

#- JSON::Repository::GitHub::Repository ----------------------------------------
class JSON::Repository::GitHub::Repository is Map {
    method created-at() { DateTime.new($_) with self<created_at> }
    method license() {
        bless-hash-as JSON::Repository::GitHub::License, self<license>
    }
    method owner() {
        bless-hash-as JSON::Repository::GitHub::Actor, self<owner>
    }
    method pushed-at() { DateTime.new($_) with self<pushed_at> }
}
BEGIN add-simple-accessors JSON::Repository::GitHub::Repository, <
  allow-forking archive-url archived assignees-url blobs-url branches-url
  clone-url collaborators-url comments-url commits-url compare-url
  contents-url contributors-url default-branch deployment-url description
  disabled downloads-url events-url fork forks forks-count forks-url
  full-name git-commits-url git-refs-url git-tags-url git-url
  has-discussions has-downloads has-issues has-pages has-projects
  has-pull-requests has-wiki homepage hooks-url html-url id is-template
  issue-comment-url issue-events-url issues-url keys-url labels-url
  language languages-url master-branch merges-url milestones-url
  mirror-url name node-id notifications-url open-issues open-issues-count
  private pull-request-creation-policy pulls-url releases-url size
  ssh-url stargazers stargazers-count stargazers-url statuses-url
  subscribers-url subscription-url svn-url tags-url teams-url trees-url
  visibility watchers watchers-count web-commit-signoff-required
>;
BEGIN add-list-accessors JSON::Repository::GitHub::Repository, <
  topics
>;
BEGIN add-datetime-accessors JSON::Repository::GitHub::Repository, <
  updated-at
>;

#- JSON::Repository::GitHub::Push ----------------------------------------------
class JSON::Repository::GitHub::Push is Map {
    method channels() {
        eager (self<channels> // "").split(",")
    }
    method commits() {
        bless-array-elements-as
          JSON::Repository::GitHub::Commit, self<commits> // ()
    }
    method head-commit() {
        try bless-hash-as JSON::Repository::GitHub::Commit, self<head_commit>
    }
    method pusher() {
        bless-hash-as JSON::Repository::GitHub::Person, self<pusher>
    }
    method sender() {
        bless-hash-as JSON::Repository::GitHub::Actor, self<sender>
    }
}
BEGIN add-simple-accessors JSON::Repository::GitHub::Push, <
  after base-ref before compare created deleted forced ref
>;

# vim: expandtab shiftwidth=4
