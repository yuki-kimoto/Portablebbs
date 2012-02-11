package Portablebbs::Database;
use Mojo::Base 'Mojolicious::Controller';

# Create database
sub init {
  my $self = shift;
  
  # Create entry table
  $self->app->dbi->execute(<<'EOS');
create table entry (
  id integer primary key autoincrement,
  title not null,
  message not null,
  ctime datetime not null
)
EOS
  
  $self->redirect_to('/install/success');
}

1;
