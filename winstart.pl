use strict;
use warnings;
use FindBin;

my $app = shift // 'portablebbs';
my $args = shift // 'daemon --listen=http://*:10000';

$ENV{MOJO_MODE} //= 'production';

# Process IDs
my $old_wperl_pids = get_wperl_pids();

# Check if wperl exists
system('wperl') == 0 or die "wperl is not found";

# Check if application script is exists
my $app_path = "$FindBin::Bin/script/$app";
die qq/Application "$app_path" is not found/ unless -f $app_path;

# Process id file
my $pid_file = "$FindBin::Bin/winstart.pid";
die "Application is already running\n" if -f $pid_file;

# Start
system("start wperl $app_path $args");

sleep 1;

# Check if application is running
my $new_wperl_pids = get_wperl_pids();;
my $pid = get_new_wperl_pid($old_wperl_pids, $new_wperl_pids);
die "Application starting fail" unless defined $pid;

# Save process id
open my $pid_fh, '>', $pid_file
  or die qq/Can't open file "$pid_file": $!/;
print $pid_fh $pid;
close $pid_fh;

# Start message
print "Server start\nApplication: $app\nArguments: $args\n";

sub get_wperl_pids {
  my $self = shift;
  
  my $pids = {};
  my @lines = split /\n/, `tasklist`;
  for my $line (@lines) {
    my ($name, $pid) = split /\s+/, $line;
    next unless defined $name && defined $pid;
    $pids->{$pid} = 1 if $name eq 'wperl.exe';
  }
  
  return $pids;
}

sub get_new_wperl_pid {
  my ($old_pids, $new_pids) = @_;
  
  # Get new wperl pid
  my $wperl_pid;
  for my $pid (keys %$new_pids) {
    unless ($old_pids->{$pid}) {
      $wperl_pid = $pid;
      last;
    }
  }
  
  return $wperl_pid;
}
