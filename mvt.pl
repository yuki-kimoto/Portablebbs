use strict;
use warnings;
use Test::ModuleVersion;
use FindBin;

# Create module test
my $tm = Test::ModuleVersion->new;
$tm->before(<<'EOS');
use 5.010001;

=pod

run mvt.pl to create this module version test(t/module.t).

  perl mvt.pl

=cut

EOS
$tm->lib(['../extlib/lib/perl5']);
$tm->modules([
  [DBI => '1.617'],
  ['DBD::SQLite' => '1.35'],
  ['Object::Simple' => '3.0625'],
  ['Validator::Custom' => '0.1426'],
  ['DBIx::Custom' => '0.2111'],
  [Mojolicious => '2.51'],
  ['DBIx::Connector' => '0.47']
]);
$tm->test_script(output => "$FindBin::Bin/t/module.t");

1;
