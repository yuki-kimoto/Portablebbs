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
  
  # Routes
  my $r = $self->routes;
  {
    # Bridge
    my $r = $r->under(sub {
      my $self = shift;
      
      # Database is setupped?
      my $path = $self->req->url->path->to_string;
      eval { $dbi->select(table => 'entry', where => '1 = 0') };
      if ($@) {
        return 1 if $path eq '/setup' || $path eq '/init-bbs';
        $self->redirect_to('/setup');
        return 0;
      }
      
      return 1;
    });
    
    {
      my $r = $r->route->to('main#');

      $r->get('/')->to('#home');
      $r->get('/setup')->to('#setup');

      $r->post('/init-bbs')->to('#init_bbs');
      $r->post('/create-entry')->to('#create_entry');
    }
  }
}

1;
