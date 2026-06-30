#- helpful subroutines ---------------------------------------------------------
my sub bless-hash-as($class, \hash) is export {
    use nqp;
    nqp::istype(hash,Failure)
      ?? hash.throwl
      !! hash
        ?? nqp::p6bindattrinvres(
             nqp::create(nqp::decont($class)),
             Map,
             '$!storage',
             nqp::getattr(nqp::decont(hash),Map,'$!storage')
           )
        !! Nil
}

my sub bless-array-elements-as($class, @array) is export {  # UNCOVERABLE
    eager @array.map: { bless-hash-as($class, $_) }  # UNCOVERABLE
}

my sub add-simple-accessors($class, *@method-names) is export {  # UNCOVERABLE
    for @method-names -> $method-name {  # UNCOVERABLE
        my $field  := $method-name.trans("-" => "_");
        my $method := my method () { self{$field} }

        $method.^set_name($method-name);  # UNCOVERABLE
        $class.^add_method($method-name, $method);  # UNCOVERABLE
    }
}

my sub add-datetime-accessors($class, *@method-names) is export {  # UNCOVERABLE
    for @method-names -> $method-name {  # UNCOVERABLE
        my $field  := $method-name.trans("-" => "_");
        my $method := my method () {
            with self{$field} {  # UNCOVERABLE
                try DateTime.new(.contains(/^ \d+ $/) ?? +$_ !! $_)  # UNCOVERABLE
            }
            else {
                Nil
            }
        }

        $method.^set_name($method-name);  # UNCOVERABLE
        $class.^add_method($method-name, $method);  # UNCOVERABLE
    }
}

my sub add-list-accessors($class, *@method-names) is export {  # UNCOVERABLE
    for @method-names -> $method-name {  # UNCOVERABLE
        my $field  := $method-name.trans("-" => "_");
        my $method := my method () { self{$field} // () }

        $method.^set_name($method-name);  # UNCOVERABLE
        $class.^add_method($method-name, $method);  # UNCOVERABLE
    }
}

# vim: expandtab shiftwidth=4
