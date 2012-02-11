package Portablebbs::Entry;
use Mojo::Base 'Mojolicious::Controller';

# Create message
sub create {
  my $self = shift; # ($self is Mojolicious::Controller object)
  
  # Form data(This data is Already decoded)
  my $title   = $self->param('title');
  my $message = $self->param('message');
  
  # Display error page if title is not exist.
  return $self->render(template => 'error', message  => 'Please input title')
    unless $title;
  
  # Display error page if message is not exist.
  return $self->render(template => 'error', message => 'Please input message')
    unless $message;
  
  # Check title length
  return $self->render(template => 'error', message => 'Title is too long')
    if length $title > 30;
  
  # Check message length
  return $self->render(template => 'error', message => 'Message is too long')
    if length $message > 100;
  
  # Data and time
  my ($sec, $min, $hour, $day, $month, $year) = localtime;
  $month = $month + 1; 
  $year = $year + 1900;
  
  # Format date (yyyy/mm/dd hh:MM:ss)
  my $datetime = sprintf("%04s/%02s/%02s %02s:%02s:%02s", 
                         $year, $month, $day, $hour, $min, $sec);
  
  # Delete line breakes
  $message =~ s/\x0D\x0A|\x0D|\x0A//g;
  
  # Writing data
  my $record = join("\t", $datetime, $title, $message) . "\n";
  
  # File open to write
  open my $data_fh, ">>", $data_file
    or die "Cannot open $data_file: $!";
  
  # Encode
  $record = b($record)->encode('UTF-8')->to_string;
  
  # Write
  print $data_fh $record;
  
  # Close
  close $data_fh;
  
  # Redirect
  $self->redirect_to('index');
}

1;
