package Portablebbs;
use Mojo::Base 'Mojolicious';
use DBIx::Custom;
use Validator::Custom;

has validator => sub { Validator::Custom->new };
has 'dbi';

sub startup {
  my $self = shift;
  
  # Config
  my $config = $self->plugin('Config');
  use Data::Dumper;
  warn Dumper [$config];
  
  # Database
  my $db = $ENV{PORTABLEBBE_DBNAME} || "portablebbs";
  my $dbpath = $self->home->rel_file("db/$db");
  
  # DBI
  my $dbi = DBIx::Custom->connect(
    dsn => "dbi:SQLite:$dbpath",
    option => {sqlite_unicode => 1},
    connector => 1
  );
  $self->dbi($dbi);
  
  # Model
  $dbi->create_model(table => 'entry');
  
  # Route
  my $r = $self->routes;
  
  # Brige
  my $b = $r->under(sub {
    my $self = shift;
    
    # Database is setupped?
    my $path = $self->req->url->path->to_string;
    eval { $dbi->select(table => 'entry', where => '1 = 0') };
    if ($@) {
      return 1 if $path eq '/install' || $path eq '/bbs/init';
      $self->redirect_to('/install');
      return 0;
    }
    
    return 1;
  });

  # Top page
  $b->get('/')->to('index#default');

  # Entry
  $b->post('/entry/create')->to('entry#create');

  # Install
  $b->get('/install')->to('install#default');
  $b->get('/install/success')->to('install#success');

  # Database
  $b->post('/bbs/init')->to('bbs#init');
}

1;
