use 5.016;
use strict;
use warnings FATAL => 'all';

package Attribute::Universal;

# ABSTRACT: Install L<attribute handlers|Attribute::Handlers> directly into UNIVERSAL namespace

use Attribute::Handlers 0.99;

# VERSION

sub import {
  my $class = shift;
  my $caller = scalar caller;
  my %cfg = @_;
  foreach my $name (keys %cfg) {
    my $cfg = uc($cfg{$name});
    ## no critic
    eval qq{
      sub UNIVERSAL::$name : ATTR($cfg) {
        goto &${caller}::ATTRIBUTE;
      }
    };
    ## use critic
    die "cannot install universal attribute $name in $caller: $@" if $@;
  }
}

=func to_hash

    sub ATTRIBUTE {
        my $hash = Attribute::Universal::to_hash(@_);
    }

Its hard to remember what arguments are given to C<ATTRIBUTE()>. This helper function converts the list into a hashref, with these keywords:

=over 4

=item * I<package>

The package the attribute was used

=item * I<symbol>

The GlobRef to the named symbol or the string L<LEXICAL>.

=item * I<referent>

The reference to the object itself (CodeRef, HashRef, ArrayRef or ScalarRef)

=item * I<attribute>

The name of the attribute

=item * I<payload>

The payload of all attributes, if used more than once. This is an ArrayRef of strings!

=item * I<phase>

The phase the attribute was covered. (BEGIN, CHECK, INIT, END)

=item * I<file>

The filename, if known

=item * I<line>

The linenumber, if known

=back

And these additional keywords:

=over 4

=item * I<label>

The name of the symbol. Imagine you have:

    sub MyFunction : Attribute;
    our $MyScalar : Attribute;

so I<label> becomes C<MyFunction> and C<MyScalar>

A lexical symbol cannot have a label.

=item * I<type>

The reftype of the referent (CODE, HASH, ARRAY, SCALAR)

=back

=cut

sub to_hash {
    shift if $_[0] eq __PACKAGE__;
    my ($package, $symbol, $referent, $attribute, $payload, $phase, $file, $line) = @_;
    my $label = ref ($symbol) ? *{$symbol}{NAME} : undef;
    my $type  = ref $referent;
    return {
      package   => $package,
      symbol    => $symbol,
      referent  => $referent,
      attribute => $attribute,
      payload   => $payload,
      phase     => $phase,
      file      => $file,
      line      => $line,
      label     => $label,
      type      => $type,
    };
}

1;

=head1 SYNOPSIS

    package Disco;
    
    use Attribute::Universal Loud => 'CODE';
    
    sub ATTRIBUTE {
        my ($package, $symbol, $referent, $attr, $data) = @_;
        # See Attribute::Handlers
    }
    
    # Attribute is installed global
    
    sub Noise : Loud {
        ...
    }

=head1 DESCRIPTION

According to the example above, this module does just this on import:

    use Attribute::Handlers;
    
    sub UNIVERSAL::Load : ATTR(CODE) {
        goto &Disco::ATTRIBUTE;
    }

Hint: the I<redefine> warning is still enabled.

More than one attribute may be defined at import, with any allowed option:

    use Attribute::Universal RealLoud => 'BEGIN,END', TooLoud => 'ANY,RAWDATA';

See L<Attributes::Handlers> for more information about attribute handlers.
