use Mojo::Base -strict;

use Test::More tests => 4;
use Test::Mojo;

use_ok 'Portablebbs';

my $t = Test::Mojo->new('Portablebbs');
$t->get_ok('/');
