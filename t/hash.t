#!perl

use Test::More tests => 1;

END { done_testing }

our $Stack = [];

END {
	is_deeply($Stack => [{
		attribute => 'Test',
		content => [ undef ],
		file => 't/hash.t',
		full_name => '&main::Code',
		label => 'Code',
		line => 80,
		name => '&Code',
		package => 'main',
		payload => undef,
		phase => 'END',
		referent => \&Code,
		sigil => '&',
		symbol => \*::Code,
		type => 'CODE',
	},{
		attribute => 'Test',
		content => [ undef ],
		file => 't/hash.t',
		full_name => '$main::Scalar',
		label => 'Scalar',
		line => 81,
		name => '$Scalar',
		package => 'main',
		payload => undef,
		phase => 'END',
		referent => \$Scalar,
		sigil => '$',
		symbol => \*::Scalar,
		type => 'SCALAR',
	},{
		attribute => 'Test',
		content => [ undef ],
		file => 't/hash.t',
		full_name => '@main::Array',
		label => 'Array',
		line => 82,
		name => '@Array',
		package => 'main',
		payload => undef,
		phase => 'END',
		referent => \@Array,
		sigil => '@',
		symbol => \*::Array,
		type => 'ARRAY',
	},{
		attribute => 'Test',
		content => [ undef ],
		file => 't/hash.t',
		full_name => '%main::Hash',
		label => 'Hash',
		line => 83,
		name => '%Hash',
		package => 'main',
		payload => undef,
		phase => 'END',
		referent => \%Hash,
		sigil => '%',
		symbol => \*::Hash,
		type => 'HASH',
	}]) or diag(explain($Stack));
}

use Attribute::Universal Test => 'END';

sub ATTRIBUTE {
	my $hash = Attribute::Universal::to_hash(@_);
	push @$Stack => $hash;
}

sub Code    : Test;
our $Scalar : Test;
our @Array  : Test;
our %Hash   : Test;
