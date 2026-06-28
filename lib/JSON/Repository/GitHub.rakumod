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

#- JSON::Repository::GitHub::Person --------------------------------------------
class JSON::Repository::GitHub::Person is Map {
    method email()    { self<email>    }
    method name()     { self<name>     }
    method username() { self<username> }

    method date() { try self<date>.DateTime }
}
  
#- JSON::Repository::GitHub::Commit --------------------------------------------
class JSON::Repository::GitHub::Commit is Map {
    method added()    { self<added>    // () }
    method distinct() { self<distinct>       }
    method id()       { self<id>             }
    method message()  { self<message>        }
    method modified() { self<modified> // () }
    method removed()  { self<removed>  // () }
    method tree-id()  { self<tree_id>        }
    method url()      { self<url>            }

    method author() {
        bless-hash-as JSON::Repository::GitHub::Person, self<author>
    }
    method committer() {
        bless-hash-as JSON::Repository::GitHub::Person, self<committer>
    }
    method timestamp() { try self<timestamp>.DateTime }
}

#- JSON::Repository::GitHub::Push ----------------------------------------------
class JSON::Repository::GitHub::Push is Map {
    method after()    { self<after>    }
    method base-ref() { self<base_ref> }
    method before()   { self<before>   }
    method compare()  { self<compare>  }
    method created()  { self<created>  }
    method deleted()  { self<deleted>  }
    method forced()   { self<forced>   }
    method ref()      { self<ref>      }

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
}

# vim: expandtab shiftwidth=4
