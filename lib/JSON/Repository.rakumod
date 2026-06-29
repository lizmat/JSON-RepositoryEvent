use JSON::Repository::Forgejo;
use JSON::Repository::GitHub;
use JSON::Repository::Helpers; # bless-hash-as

#- X::JSON::Repository::Unknown-Event ------------------------------------------
class X::JSON::Repository::Unknown-Event {
    has $.type;
    has $.name;
    method message() {
        "Don't know how to handle $.type event: $.name"
    }
}

#- JSON::Repository ------------------------------------------------------------
class JSON::Repository is Map {
    method !header2class(@headers) {
        if @headers.first(*.name eq 'X-Forgejo-Event') -> $event {
            my $name := $event.value.split("_").map(*.tc).join;
            JSON::Repository::Forgejo::{$name}:exists
              ?? JSON::Repository::Forgejo::{$name}
              !! X::JSON::Repository::Unknown-Event.new(
                   :type<Forgejo>, :$name
                 ).Failure
        }
        elsif @headers.first(*.name eq 'X-GitHub-Event') -> $event {
            my $name := $event.value.split("_").map(*.tc).join;
            JSON::Repository::GitHub::{$name}:exists
              ?? JSON::Repository::GitHub::{$name}
              !! X::JSON::Repository::Unknown-Event.new(
                   :type<GitHub>, :$name
                 ).Failure
        }
        else {
            Nil  # ignore for now
        }
    }

    proto method new(|) {*}
    multi method new(\data) {
        bless-hash-as(self, data)
    }
    multi method new(\payload, $request) {
        self.new(payload, $request.headers, $request.query-hash);
    }

    multi method new(
      \payload, @headers, %nameds
    ) is implementation-detail {
        (my $class := self!header2class(@headers)) =:= Nil
          ?? Nil
          !! bless-hash-as(self, my % is Map =
               :class($class.^name),
               :@headers,
               :%nameds,
               :payload(bless-hash-as($class, payload))
             )
    }

    method irc       { eager (self.nameds<irc> // "").split(",")      }
    method class()   {                        ::(self<class>)         }
    method headers() {                           self<headers> // ()  }
    method nameds()  {                           self<nameds>  // {}  }
    method payload() { bless-hash-as self.class, self<payload>        }
}

# vim: expandtab shiftwidth=4
