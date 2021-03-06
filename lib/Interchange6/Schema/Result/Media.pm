use utf8;

package Interchange6::Schema::Result::Media;

=head1 NAME

Interchange6::Schema::Result::Media

=cut

use Interchange6::Schema::Candy -components =>
  [qw(InflateColumn::DateTime TimeStamp)];

=head1 ACCESSORS

=head2 media_id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0
  sequence: 'media_media_id_seq'
  primary key

=cut

primary_column media_id => {
    data_type         => "integer",
    is_auto_increment => 1,
    is_nullable       => 0,
    sequence          => "media_media_id_seq",
};

=head2 file

  data_type: 'varchar'
  default_value: (empty string)
  is_nullable: 0
  size: 255
  unique constraint

=cut

unique_column file => {
    data_type     => "varchar",
    default_value => "",
    is_nullable   => 0,
    size          => 255
};

=head2 uri

  data_type: 'varchar'
  default_value: (empty string)
  is_nullable: 0
  size: 255

=cut

column uri => {
    data_type     => "varchar",
    default_value => "",
    is_nullable   => 0,
    size          => 255
};

=head2 mime_type

  data_type: 'varchar'
  default_value: (empty string)
  is_nullable: 0
  size: 255

=cut

column mime_type => {
    data_type     => "varchar",
    default_value => "",
    is_nullable   => 0,
    size          => 255
};

=head2 label

  data_type: 'varchar'
  default_value: (empty string)
  is_nullable: 0
  size: 255

=cut

column label => {
    data_type     => "varchar",
    default_value => "",
    is_nullable   => 0,
    size          => 255
};

=head2 author_users_id

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 1

=cut

column author_users_id =>
  { data_type => "integer", is_foreign_key => 1, is_nullable => 1 };

=head2 created

  data_type: 'datetime'
  set_on_create: 1
  is_nullable: 0

=cut

column created =>
  { data_type => "datetime", set_on_create => 1, is_nullable => 0 };

=head2 last_modified

  data_type: 'datetime'
  set_on_create: 1
  set_on_update: 1
  is_nullable: 0

=cut

column last_modified => {
    data_type     => "datetime",
    set_on_create => 1,
    set_on_update => 1,
    is_nullable   => 0
};

=head2 active

  data_type: 'boolean'
  default_value: 1
  is_nullable: 0

=cut

column active =>
  { data_type => "boolean", default_value => 1, is_nullable => 0 };

=head2 media_types_id

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 0

=cut

column media_types_id =>
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 };

=head1 UNIQUE CONSTRAINTS

=head2 C<media_id_media_types_id_unique>

=over 4

=item * L</media_id>

=item * L</media_types_id>

=back

=cut

unique_constraint media_id_media_types_id_unique =>
  [ "media_id", "media_types_id" ];

=head1 RELATIONS

=head2 author

Type: belongs_to

Related object: L<Interchange6::Schema::Result::User>

=cut

belongs_to
  author => "Interchange6::Schema::Result::User",
  { "foreign.users_id" => "self.author_users_id" };

=head2 media_type

Type: belongs_to

Related object: L<Interchange6::Schema::Result::MediaType>

=cut

belongs_to
  media_type => "Interchange6::Schema::Result::MediaType",
  "media_types_id",
  { is_deferrable => 0, on_delete => "CASCADE", on_update => "CASCADE" };

=head2 media_products

Type: has_many

Related object: L<Interchange6::Schema::Result::MediaProduct>

=cut

has_many
  media_products => "Interchange6::Schema::Result::MediaProduct",
  "media_id",
  { cascade_copy => 0, cascade_delete => 0 };

=head2 products

Type: many_to_many with product.

=cut

many_to_many products => "media_products", "product";

=head2 displays

Type: many_to_many with media_displays

=cut

many_to_many displays => "media_type", "media_displays";

=head1 METHODS

=head2 type

Return the media type looking into MediaDisplay and MediaType.

=cut

sub type {
    my $self = shift;

    # here we return just the first result. UNCLEAR if more are
    # needed, but has many... Either we
    return $self->media_type->type;
}

=head2 display_uris

Return an hashref with the media display type and the final uri.

=cut

sub display_uris {
    my $self = shift;
    my %uris;
    foreach my $d ( $self->displays ) {
        my $path = $d->path;
        $path =~ s!/$!!;    # remove eventual trailing slash
        $uris{ $d->type } = $path . '/' . $self->uri;
    }
    return \%uris;
}

=head2 display_uri('display_type')

Return the uri for the display type (or undef if not found).

=cut

sub display_uri {
    my ( $self, $type ) = @_;
    return $self->display_uris->{$type};
}

1;
