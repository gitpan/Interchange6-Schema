use utf8;

package Interchange6::Schema::Result::Shipment;

=head1 NAME

Interchange6::Schema::Result::Shipment

=cut

use Interchange6::Schema::Candy -components =>
  [qw(InflateColumn::DateTime TimeStamp)];

=head1 ACCESSORS

=head2 shipments_id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0
  primary key

=cut

primary_column shipments_id =>
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0, };

=head2 tracking_number

  data_type: 'varchar'
  default_value: (empty string)
  is_nullable: 0
  size: 255

=cut

column tracking_number => {
    data_type     => "varchar",
    default_value => "",
    is_nullable   => 0,
    size          => 255
};

=head2 shipment_carriers_id

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 0

=cut

column shipment_carriers_id =>
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 };

=head2 shipment_methods_id

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 0

=cut

column shipment_methods_id =>
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 };

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

=head1 RELATIONS

=head2 shipment_carrier

Type: belongs_to

Related object: L<Interchange6::Schema::Result::ShipmentCarrier>

=cut

belongs_to
  shipment_carrier => "Interchange6::Schema::Result::ShipmentCarrier",
  "shipment_carriers_id",
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" };

=head2 shipment_method

Type: belongs_to

Related object: L<Interchange6::Schema::Result::ShipmentMethod>

=cut

belongs_to
  shipment_method => "Interchange6::Schema::Result::ShipmentMethod",
  "shipment_methods_id",
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" };

1;
