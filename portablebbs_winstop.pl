use strict;
use warnings;
use FindBin;

my $pid_file = "$FindBin::Bin/winstart.pid";
open my $pid_fh, '<', $pid_file
  or die "Application is not running\n";

my $pid = do { local $/; <$pid_fh> };
die "Process id is invalid"
  unless defined $pid && $pid =~ /^\d+$/;
close $pid_fh;

system("taskkill /F /PID $pid");

unlink $pid_file;
