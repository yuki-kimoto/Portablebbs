package Portablebbs::Install;
use Mojo::Base 'Mojolicious::Controller';

sub default {
  my $self = shift;
  
  # Database is setupped
  eval { $self->app->dbi->select(table => 'entry', where => '1 = 0') };
  if ($@) { $self->render }
  else { $self->render('install/installed') }
}

1;
