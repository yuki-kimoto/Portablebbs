package Portablebbs::Index;
use Mojo::Base 'Mojolicious::Controller';

sub default {
  my $self = shift;
  
  # DBI
  my $dbi = $self->app->dbi;
  
  # Select
  my $model = $dbi->model('entry');
  my $result = $model->select(append => 'order by ctime desc');
  
  # Render index page
  $self->render(entries => $result->all);
}

1;
