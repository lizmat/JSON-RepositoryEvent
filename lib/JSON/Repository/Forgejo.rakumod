#- helpful subroutines ---------------------------------------------------------
my sub bless-hash-as($class, %hash) {
    use nqp;
    nqp::p6bindattrinvres(
      nqp::create(nqp::decont($class)),
      Map,
      '$!storage',
      nqp::getattr(%hash,Map,'$!storage')
    )
}
my sub bless-array-elements-as($class, @array) {
    eager @array.map: { bless-hash-as($class,$_) }
}

#- JSON::Repository::Forgejo::Person -------------------------------------------
class JSON::Repository::Forgejo::Person is Map {
    method email()    { self<email>    }
    method name()     { self<name>     }
    method username() { self<username> }
}

#- JSON::Repository::Forgejo::Actor --------------------------------------------
class JSON::Repository::Forgejo::Actor is Map {
    method active()              { self<active>              }
    method avatar-url()          { self<avatar_url>          }
    method description()         { self<description>         }
    method email()               { self<email>               }
    method followers-count()     { self<followers_count>     }
    method following-count()     { self<following_count>     }
    method full-name()           { self<full_name>           }
    method html-url()            { self<html_url>            }
    method id()                  { self<id>                  }
    method is-admin()            { self<is_admin>            }
    method language()            { self<language>            }
    method location()            { self<location>            }
    method login()               { self<login>               }
    method login-name()          { self<login_name>          }
    method prohibit-login()      { self<prohibit_login>      }
    method pronouns()            { self<pronouns>            }
    method restricted()          { self<restricted>          }
    method source-id()           { self<source_id>           }
    method starred-repos-count() { self<starred_repos_count> }
    method username()            { self<username>            }
    method visibility()          { self<visibility>          }
    method website()             { self<website>             }

    method created()    { try self<created>.DateTime    }
    method last-login() { try self<last_login>.DateTime }
}

#- JSON::Repository::Forgejo::Tracker ------------------------------------------
class JSON::Repository::Forgejo::Tracker is Map {
    method allow-only-contributors-to_track-time() {
        self<allow_only_contributors_to_track_time>
    }
    method enable-issue-dependencies() {
        self<enable_issue_dependencies>
    }
    method enable-time-tracker() {
        self<enable_time_tracker>
    }
}

#- JSON::Repository::Forgejo::Permissions --------------------------------------
class JSON::Repository::Forgejo::Permissions is Map {
    method admin() { self<admin> }
    method pull()  { self<pull>  }
    method push()  { self<push>  }
}

#- JSON::Repository::Forgejo::Commit -------------------------------------------
class JSON::Repository::Forgejo::Commit is Map {
    method added()        { self<added>    // () }
    method id()           { self<id>             }
    method message()      { self<message>        }
    method modified()     { self<modified> // () }
    method removed()      { self<removed>  // () }
    method url()          { self<url>            }
    method verification() { self<verification>   }

    method author() {
        bless-hash-as JSON::Repository::Forgejo::Person, self<author>
    }
    method committer() {
        bless-hash-as JSON::Repository::Forgejo::Person, self<committer>
    }
    method timestamp() { try self<timestamp>.DateTime }
}

#- JSON::Repository::Forgejo::Repository ---------------------------------------
class JSON::Repository::Forgejo::Repository is Map {
    method allow-fast-forward-only-merge() {
        self<allow_fast_forward_only_merge>
    }
    method allow-merge-commits()   { self<allow_merge_commits>   }
    method allow-rebase()          { self<allow_rebase>          }
    method allow-rebase-explicit() { self<allow_rebase_explicit> }
    method allow-rebase-update()   { self<allow_rebase_update>   }
    method allow-squash-merge()    { self<allow_squash-merge>    }
    method archived()              { self<archived>              }
    method avatar-url()            { self<avatar_url>            }
    method clone-url()             { self<clone_url>             }

    method default-allow-maintainer-edit() {
        self<default_allow_maintainer_edit>
    }
    method default-branch() { self<default_branch> }
    method default-delete-branch-after-merge() {
        self<default_delete_branch_after_merge>
    }

    method default-merge-style()  { self<default_merge_style>  }
    method default-update-style() { self<default_update_style> }
    method descriptio()           { self<description>          }
    method empty()                { self<empty>                }
    method fork()                 { self<fork>                 }
    method forks-count()          { self<forks_count>          }
    method full-name()            { self<full_name>            }

    method globally-editable-wiki() {
        self<globally_editable_wiki>
    }

    method has-actions()       { self<has_actions>       }
    method has-issues()        { self<has_issues>        }
    method has-projects()      { self<has_projects>      }
    method has-pull-requests() { self<has_pull_requests> }
    method has-releases()      { self<has_releases>      }
    method has-wiki()          { self<has_wiki>          }
    method has-wiki-contents() { self<has_wiki_contents> }
    method html-url()          { self<html_url>          }
    method id()                { self<id>                }

    method ignore_whitespace_conflicts() {
        self<ignore_whitespace_conflicts>
    }

    method internal()          { self<internal>          }
    method language()          { self<language>          }
    method languages-url()     { self<languages_url>     }
    method link()              { self<link>              }
    method mirror()            { self<mirror>            }
    method mirror-interval()   { self<mirror_interval>   }
    method name()              { self<name>              }
    method object-format()     { self<object_format>     }
    method open-issues-count() { self<open_issues_count> }
    method open-pr-counter()   { self<open_pr_counter>   }
    method original-url()      { self<original_url>      }
    method parent()            { self<parent>            }
    method private()           { self<private>           }
    method release-counter()   { self<release_counter>   }
    method repo-transfer()     { self<repo_transfer>     }
    method size()              { self<size>              }
    method ssh-url()           { self<ssh_url>           }
    method stars-count()       { self<stars_count>       }
    method template()          { self<template>          }
    method url()               { self<url>               }
    method watchers-count()    { self<watchers_count>    }
    method website()           { self<website>           }
    method wiki-branch()       { self<wiki_branch>       }
    method wiki-clone-url()    { self<wiki_clone_url>    }
    method wiki-ssh-url()      { self<wiki_ssh_url>      }

    method archived-at() { try self<archived_at>.DateTime }
    method created-at()  { try self<created_at>.DateTime  }
    method internal-tracker() {
        bless-hash-as
          JSON::Repository::Forgejo::Tracker, self<internal_tracker>
    }
    method mirror-updated() { try self<mirror_updated>.DateTime }
    method owner() {
        bless-hash-as JSON::Repository::Forgejo::Actor, self<owner>
    }
    method permissions() {
        bless-hash-as JSON::Repository::Forgejo::Permissions, self<permissions>
    }
    method topics() { self<topics> // () }
    method updated-at()  { try self<updated_at>.DateTime  }
}

#- JSON::Repository::Forgejo::Push ---------------------------------------------
class JSON::Repository::Forgejo::Push is Map {
    method after()         { self<after>         }
    method before()        { self<before>        }
    method compare-url()   { self<compare_url>   }
    method ref()           { self<ref>           }
    method total-commits() { self<total-commits> }

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

# vim: expandtab shiftwidth=4
