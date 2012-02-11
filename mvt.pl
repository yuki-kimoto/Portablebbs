use strict;
use warnings;
use Test::ModuleVersion;

my $tm = Test::ModuleVersion->new;
$tm->lib(['extlib/perl5/lib']);
$tm->modules([
  [DBI => '1.616'],
  ['DBD::SQLite' => '1.35'],
  ['Object::Simple' => '3.0625'],
  ['Validator::Custom' => '0.1426'],
  ['DBIx::Custom' => '0.2110'],
  [Mojolicious => '2.46'],
]);
print $tm->test_script;

1;
