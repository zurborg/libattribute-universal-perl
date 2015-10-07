use strict;
use warnings FATAL => 'all';

package Attribute::Universal;

# ABSTRACT: Install attribute handlers directly into UNIVERSAL namespace

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
