use strict;
use warnings;
use Test::ModuleVersion;

# Create module test
my $tm = Test::ModuleVersion->new;
$tm->comment(<<'EOS');
Developer can create this test script by the following command

  perl t/mvt.pl > t/module.t
EOS
$tm->lib(['../extlib/lib/perl5']);
$tm->modules([
  [DBI => '1.616'],
  ['DBD::SQLite' => '1.35'],
  ['Object::Simple' => '3.0625'],
  ['Validator::Custom' => '0.1426'],
  ['DBIx::Custom' => '0.2111'],
  [Mojolicious => '2.46'],
]);
print $tm->test_script;

1;
