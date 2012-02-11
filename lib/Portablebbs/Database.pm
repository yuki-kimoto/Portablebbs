package Portablebbs::Database;
use Mojo::Base 'Mojolicious::Controller';

# Create database
sub init {
  my $self = shift;
  
  $dbi->execute('<<EOS');
create table entry (
  id int integer primary key autoincrement,
  title,
  message
)
EOS
}

1;
