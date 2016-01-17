#!perl

use Test::More tests => 4;

END { done_testing }

use Attribute::Universal Begin => 'BEGIN', Check => 'CHECK', Init => 'INIT', End => 'END';

sub ATTRIBUTE {
	my ($package, $symbol, $referent, $attr, $data, $phase, $filename, $linenum) = @_;
	if ($ENV{AUTHOR_TESTING} and $^V < 5.016) {
		pass("skip phase $phase");
		diag("phase $phase: ".explain($referent));
	} else {
		my $should = $referent->();
		is($should, $phase, "phase");
	}
}

sub Early  : Begin { 'BEGIN' }
sub Normal : Check { 'CHECK' }
sub Late   : Init  { 'INIT'  }
sub Final  : End   { 'END'   }

