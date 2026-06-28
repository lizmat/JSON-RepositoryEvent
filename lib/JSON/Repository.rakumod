use JSON::Repository::Forgejo;
use JSON::Repository::GitHub;

#- helpful subroutines ---------------------------------------------------------
my sub bless-hash-as($class, %hash) {
    use nqp;
    nqp::eqaddr(nqp::decont($class),Nil)
      ?? Nil
      !! nqp::p6bindattrinvres(
           nqp::create(nqp::decont($class)),
           Map,
           '$!storage',
           nqp::getattr(%hash,Map,'$!storage')
         )
}
my sub bless-array-elements-as($class, @array) {
    eager @array.map: { bless-hash-as($class,$_) }
}

#- JSON::Repository ------------------------------------------------------------
class JSON::Repository is Map {

    method !header2class(%headers) {
        if %headers<X-Forgejo-Event> -> $event {
            my $name := $event.tc;
            return JSON::Repository::Forgejo::{$name}
              if JSON::Repository::Forgejo::{$name}:exists;
        }
        elsif %headers<X-GitHub-Event> -> $event {
            my $name := $event.tc;
            return JSON::Repository::GitHub::{$name}
              if JSON::Repository::GitHub::{$name}:exists;
        }
        Nil
    }

    method new(%data, %headers) {
        (my $class := self!header2class(%headers)) =:= Nil
          ?? Nil
          !! bless-hash-as($class, %data)
    }
}

# vim: expandtab shiftwidth=4
