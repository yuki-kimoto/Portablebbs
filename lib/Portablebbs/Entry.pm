package Portablebbs::Entry;
use Mojo::Base 'Mojolicious::Controller';

# Create entry
sub create {
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

1;
