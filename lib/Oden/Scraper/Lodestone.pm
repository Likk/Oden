package Oden::Scraper::Lodestone;
use 5.38.0;
use base 'Class::Accessor::Fast';

use Furl;
use Web::Query;

use Function::Parameters;
use Function::Return;
use Types::Standard -types;

=head1 NAME

  Oden::Scraper::Lodestone - ffxiv lodestone scraper.

=head1 SYNOPSIS

  my $lodestone = Oden::Scraper::Lodestone->new;
  my $members   = $lodestone->crossworld_linkshell('XXXXX');
  for my $member (@$members){
      say $member->{name};
  }

=head1 Accessor

=over

=item B<ua>

  Furl object.

=cut

method ua(Maybe[Str] $agent = undef): Return(InstanceOf['Furl']){
    my $ua = $self->{ua} || do {
        $self->{ua} = Furl->new(
            agent      => 'Mozilla/5.0 (Windows NT 6.1; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/53.0.2785.89 Safari/537.36',
            timeout    => 60,
        );
    };
    $ua->agent($agent) if $agent;
    return $ua;
}

=item B<interval>

  http request interval.

=cut

method interval(Maybe[Num] $interval = undef) :Return(Num){
    $self->{interval} = $interval if defined $interval;
    return $self->{interval} // do { $self->{interval} = 1 };
}

=item B<last_request_time>

  request time at last request.

=cut

method last_request_time(Maybe[Int] $last_req = undef): Return(Int){
    $self->{last_req} = $last_req if defined $last_req;
    return $self->{last_req} // do { $self->{last_req} = time };
}

=item B<last_content>

  cache at last decoded content.

=cut

method last_content(Maybe[Str] $last_content = undef): Return(Str){
    $self->{last_content} = $last_content if defined $last_content;
    return $self->{last_content} // do { $self->{last_content} = ''};
}

=head1 METHDOS

=head1 lang

  set lang at lodestone.
  default jp.

=cut

method lang(Maybe[Str] $lang = 'jp'): Return(Str){
    $self->{lang} = $lang if defined $lang;
}

=head1 base_url

  ffxiv lodestone url.

=cut

method base_url(Maybe[Str] $base_url = undef): Return(Str){
    $self->{base_url} = $base_url if defined $base_url;
    return $self->{base_url} || do {
        my $lang = $self->lang;
        my $is_supported_lang = scalar grep { $_ eq $lang } qw/jp na eu fr de/;
        unless($is_supported_lang){
           $self->lang('jp');
          $lang = 'jp';
        };
        $self->{base_url} = sprintf('https://%s.finalfantasyxiv.com/lodestone', $lang);
    };
}

=head2 conf

  url path config

=cut

method conf(Maybe[HashRef] $conf = undef ): Return(HashRef) {
    $self->{conf} = $conf if defined $conf;
    return $self->{conf} || do {
        +{
            top                  => '/',
            crossworld_linkshell => "%s/crossworld_linkshell/%s/",
        };
    };
}

=head2 crossworld_linkshell

  show crossworld_linkshell member list;
  TODO: over 50 members (now: first page only).

=cut

method crossworld_linkshell(Str $cwls_id): Return(ArrayRef[HashRef]){
    my $url = sprintf($self->conf->{crossworld_linkshell}, $self->base_url, $cwls_id);

    $self->_get($url);

    my $members = $self->_scrape_crossworld_linkshell();
    return $members;
}

=head1 PRIVATE METHODS

=head2 SCRAPE METHODS

=over

=item B<_scape_crossworld_linkshell>

  scrape crossworld linkshell page.

=cut

sub _scrape_crossworld_linkshell {
    my ($self) = @_;
    my $members = [];
    my $content = $self->last_content;

    my $wq = Web::Query->new_from_html($content);
    $wq->find(\q{//div[@class='ls__member']/div[@class="entry"]})->each(sub {
        my ($i, $elem) = @_;

        my $id          = [split m{/}, $elem->find(q{a.entry__link})->attr('href')]->[-1];
        my $name        = $elem->find(q{a.entry__link})->find(q{div.entry__box})->find(q{p.entry__name})->text;
        my $world       = $elem->find(q{a.entry__link})->find(q{div.entry__box})->find(q{p.entry__world})->text;
        my $level       = $elem->find(q{a.entry__link})->find(q{div.entry__box})->find(q{ul.entry__chara_info})->find(q{li})->first->find(q{span})->text;
        my $role        = $elem->find(q{div.entry__chara_info__linkshell})->find(q{span})->text;
        my $freecompany = $elem->find(q{a.entry__freecompany__link})->find(q{span})->text;

        my $member = +{
            id          => $id,
            name        => $name,
            world       => $world,
            level       => $level,
            role        => $role,
            freecompany => $freecompany,
        };
        push @$members, $member;
    });

    return $members;
}

=back

=head2 HTTP REQUEST METHODS

=cut

=item B<_sleep_interval>

  interval for http accessing.

=cut

sub _sleep_interval {
    my $self = shift;
    my $wait = $self->interval - (time - $self->last_request_time);
    sleep $wait if $wait > 0;
    $self->_set_last_request_time();
}

=item B<_set_last_request_time>

  set request time

=cut

sub _set_last_request_time { shift->{last_req} = time }

=item B<_get>

  furl get with interval.

=cut

sub _get {
    my ($self, $url, $header, $content) = @_;
    $self->_sleep_interval;
    my $response = $self->ua->get($url);
    if(!$response->is_success){
        die sprintf("%s => %s", $response->status_line, $url);
    }
    return $self->_content($response);
}


=item b<_content>

  decode content from furl request.

=cut

sub _content {
    my ($self, $res, $encoding)  = @_;
    my $content = $res->decoded_content();
    return $self->last_content($content);
}

=back

=cut

=head1 SEE ALSO

L<https://jp.finalfantasyxiv.com/lodestone/>

=cut
