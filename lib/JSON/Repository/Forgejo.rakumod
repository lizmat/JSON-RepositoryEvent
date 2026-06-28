use JSON::Repository::Helpers;

#- JSON::Repository::Forgejo::Person -------------------------------------------
class JSON::Repository::Forgejo::Person is Map { }
BEGIN add-simple-accessors JSON::Repository::Forgejo::Person, <
  email name username
>;

#- JSON::Repository::Forgejo::Actor --------------------------------------------
class JSON::Repository::Forgejo::Actor is Map { }
BEGIN add-simple-accessors JSON::Repository::Forgejo::Actor, <
  active avatar-url description email followers-count following-count
  full-name html-url id is-admin language location login login-name
  prohibit-login pronouns restricted source-id starred-repos-count
  username visibility website
>;
BEGIN add-datetime-accessors JSON::Repository::Forgejo::Actor, <
  created last-login
>;

#- JSON::Repository::Forgejo::Tracker ------------------------------------------
class JSON::Repository::Forgejo::Tracker is Map { }
BEGIN add-simple-accessors JSON::Repository::Forgejo::Tracker, <
  allow-only-contributors-to_track-time enable-issue-dependencies
  enable_time_tracker
>;

#- JSON::Repository::Forgejo::Permissions --------------------------------------
class JSON::Repository::Forgejo::Permissions is Map { }
BEGIN add-simple-accessors JSON::Repository::Forgejo::Permissions, <
  admin pull push
>;

#- JSON::Repository::Forgejo::Commit -------------------------------------------
class JSON::Repository::Forgejo::Commit is Map {
    method author() {
        bless-hash-as JSON::Repository::Forgejo::Person, self<author>
    }
    method committer() {
        bless-hash-as JSON::Repository::Forgejo::Person, self<committer>
    }
}
BEGIN add-simple-accessors JSON::Repository::Forgejo::Commit, <
  id message url verification
>;
BEGIN add-list-accessors JSON::Repository::Forgejo::Commit, <
  added modified removed
>;
BEGIN add-datetime-accessors JSON::Repository::Forgejo::Commit, <
  timestamp
>;

#- JSON::Repository::Forgejo::Repository ---------------------------------------
class JSON::Repository::Forgejo::Repository is Map {
    method internal-tracker() {
        bless-hash-as
          JSON::Repository::Forgejo::Tracker, self<internal_tracker>
    }
    method owner() {
        bless-hash-as JSON::Repository::Forgejo::Actor, self<owner>
    }
    method permissions() {
        bless-hash-as JSON::Repository::Forgejo::Permissions, self<permissions>
    }
}
BEGIN add-simple-accessors JSON::Repository::Forgejo::Repository, <
  allow-fast-forward-only-merge allow-merge-commits allow-rebase
  allow-rebase-explicit allow-rebase-update allow-squash-merge
  archived avatar-url clone-url default-allow-maintainer-edit
  default-branch default-delete-branch-after-merge
  default-merge-style default-update-style description empty
  fork forks-count full-name globally-editable-wiki has-actions
  has-issues has-projects has-pull-requests has-releases has-wiki
  has-wiki-contents html-url id ignore_whitespace_conflicts
  internal language languages-url link mirror mirror-interval
  name object-format open-issues-count open-pr-counter
  original-url parent private release-counter repo-transfer
  size ssh-url stars-count template url watchers-count website
  wiki-branch wiki-clone-url wiki-ssh-url
>;
BEGIN add-list-accessors JSON::Repository::Forgejo::Repository, <
  topics
>;
BEGIN add-datetime-accessors JSON::Repository::Forgejo::Repository, <
  archived-at created-at mirror-updated updated-at
>;

#- JSON::Repository::Forgejo::Push ---------------------------------------------
class JSON::Repository::Forgejo::Push is Map {
    method channels() {
        eager (self<channels> // "").split(",")
    }
    method commits() {
        bless-array-elements-as
          JSON::Repository::Forgejo::Commit, self<commits> // ()
    }
    method head-commit() {
        try bless-hash-as JSON::Repository::Forgejo::Commit, self<head-commit>
    }
    method pusher() {
        bless-hash-as JSON::Repository::Forgejo::Actor, self<pusher>
    }
    method repository() {
        bless-hash-as JSON::Repository::Forgejo::Repository, self<repository>
    }
    method sender() {
        bless-hash-as JSON::Repository::Forgejo::Actor, self<sender>
    }
}
BEGIN add-simple-accessors JSON::Repository::Forgejo::Push, <
  after before compare-url ref total-commits
>;


# vim: expandtab shiftwidth=4
