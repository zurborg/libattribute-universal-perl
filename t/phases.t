#!perl

use Test::More tests => 4;

END { done_testing }

use Attribute::Universal Begin => 'BEGIN', Check => 'CHECK', Init => 'INIT', End => 'END';

sub ATTRIBUTE {
	my ($package, $symbol, $referent, $attr, $data, $phase, $filename, $linenum) = @_;
	my $should = $referent->();
	is($should, $phase, "phase");
}

sub Early  : Begin { 'BEGIN' }
sub Normal : Check { 'CHECK' }
sub Late   : Init  { 'INIT'  }
sub Final  : End   { 'END'   }

