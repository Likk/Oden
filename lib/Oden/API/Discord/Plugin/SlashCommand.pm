package Oden::API::Discord::Plugin::SlashCommand;
use strict;
use warnings;

=head1 NAME

  Oden::API::Discord::Plugin::SlashCommand

=head1 METHODS

=head2 enbpoint_config

  create named endpoint list.

=cut

sub endpoint_config {
    my ($self) = @_;
    return $self->{endpoint_list} ||= do {
            +{
                create_slash_command  => $self->{base_url} . "/applications/%s/guilds/%s/commands",
                callback_interactions => $self->{base_url} . "/interactions/%s/%s/callback",
            };
    };
}

=head2 create_slash_command

=cut

sub create_slash_command {
    my ($self, $application_id, $guild_id, $command_data) = @_;

    my $endpoint = sprintf($self->endpoint_config->{create_slash_command},
        $application_id,
        $guild_id,
    );
    my $req = POST(
        $endpoint,
        Content_Type    => 'application/json',
        Authorization   => sprintf("Bot %s", $self->{token}),
        User_Agent      => $self->_user_agent->agent,
        Content         => encode_json($command_data),
    );

    my $res = $self->_user_agent->request($req);

    unless($res->is_success()){
        warn $res->status;
        warn $res->messge;
        return ;
    }
    return 1;
}

=head2 callback_interactions

=cut

sub callback_interactions {
    my ($self, $interaction_id, $interaction_token, $callback_data) = @_;

    my $endpoint = sprintf($self->endpoint_config->{callback_interactions},
        $interaction_id,
        $interaction_token
    );
    my $req = POST(
        $endpoint,
        Content_Type    => 'application/json',
        Authorization   => sprintf("Bot %s", $self->{token}),
        User_Agent      => $self->_user_agent->agent,
        Content         => encode_json($callback_data),
    );

    my $res = $self->_user_agent->request($req);

    unless($res->is_success()){
        warn $res->status;
        warn $res->message;
        return ;
    }
    return 1;

}

1;

