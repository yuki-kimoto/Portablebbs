package Portablebbs::Main;
use Mojo::Base 'Mojolicious::Controller';

sub home {
  my $self = shift;
  
  # DBI
  my $dbi = $self->app->dbi;
  
  # Select
  my $model = $dbi->model('entry');
  my $result = $model->select(append => 'order by ctime desc');
  
  # Render index page
  $self->render(entries => $result->all);
}

sub create_entry {
  my $self = shift;
  
  # Validation
  my $rule = [
    title => ['any'],
    message => {message => 'Message is empty'} => [
      'not_blank'
    ]
  ];
  my $raw_params = $self->req->body_params->to_hash;
  my $vresult = $self->app->validator->validate($raw_params, $rule);
  
  # Invalid
  unless ($vresult->is_ok) {
    my $messages = $vresult->messages;
    $self->flash(messages => $messages);
    return $self->redirect_to('/');
  }
  
  # Create entry
  my $params = $vresult->data;
  $params->{title} = 'unknown' unless length $params->{title};
  $self->app->dbi->model('entry')->insert($params, ctime => 'ctime');
  
  # Redirect
  $self->redirect_to('/');
}

sub init_bbs {
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
  
  # Redirect
  $self->redirect_to('/');
}

sub setup {
  my $self = shift;
  
  # Setup is done?
  eval { $self->app->dbi->select(table => 'entry', where => '1 = 0') };
  my $setup_done = $@ ? 0 : 1;

  # Render
  $self->render(setup_done => $setup_done);
}

1;

