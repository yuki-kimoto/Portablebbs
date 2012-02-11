package Portablebbs;
use Mojo::Base 'Mojolicious';
use DBIx::Custom;
use Validator::Custom;

has validator => sub { Validator::Custom->new };
has 'dbi';

sub startup {
  my $self = shift;
  
  # Database
  my $database_dir = $self->home->rel_file('db');
  mkdir $database_dir unless -d $database_dir;
  my $database = $self->home->rel_file('db/portablebbs');
  
  # DBI
  my $dbi = DBIx::Custom->connect(
    dsn => "dbi:SQLite:$database",
    connector => 1
  );
  $self->dbi($dbi);
  
  # Model
  $dbi->create_model(table => 'entry', primary_key => 'entry_id');
  
  # Route
  my $r = $self->routes;
  
  # Brige
  my $b = $r->under(sub {
    my $self = shift;
    
    # Database is setupped?
    my $path = $self->req->url->path->to_string;
    eval { $dbi->select(table => 'entry', where => '1 = 0') };
    if ($@) {
      return 1 if $path eq '/install' || $path eq '/database/init';
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
  $b->post('/database/init')->to('database#init');
}

1;
