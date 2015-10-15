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
