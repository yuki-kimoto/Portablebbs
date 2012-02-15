use strict;
use warnings;
use Test::ModuleVersion;
use FindBin;

# Create module test
my $tm = Test::ModuleVersion->new;
$tm->before(<<'EOS');
use 5.010001;

=pod

You can create this script by the following command

  perl t/mvt.pl

=cut

EOS
$tm->lib(['../extlib/lib/perl5']);
$tm->modules([
  [DBI => '1.616'],
  ['DBD::SQLite' => '1.35'],
  ['Object::Simple' => '3.0625'],
  ['Validator::Custom' => '0.1426'],
  ['DBIx::Custom' => '0.2111'],
  [Mojolicious => '2.46'],
  ['DBIx::Connector' => '0.47']
]);
my $file = "$FindBin::Bin/module.t";
open my $fh, '>', $file
  or die qq/Can't open file "$file": $!/;
print $fh $tm->test_script;

1;
