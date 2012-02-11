package Portablebbs;
use Mojo::Base 'Mojolicious';
use DBIx::Custom;

has 'dbi';

sub startup {
  my $self = shift;
  
  # DBI
  my $dbi = DBIx::Custom->connect(
    dsn => 'dbi:SQLite:portablebbs'
    connector => 1
  );
  $self->dbi($dbi);
  
  # Route
  my $r = $self->routes;

  # BBS
  $r->get('/')->to('index#default');
  $r->post('/entry/create')->to('entry#create');

  # Install page
  $r->get('/install')->to('install#default');
  $r->post('/database/init')->to('database#init');
}

1;
