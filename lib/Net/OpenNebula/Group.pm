use strict;
use warnings;

package Net::OpenNebula::Group;

use Net::OpenNebula::RPC;
push our @ISA , qw(Net::OpenNebula::RPC);

use constant ONERPC => 'group';

sub name {
   my ($self) = @_;
   $self->_get_info();

   # if user NAME is set, use that instead of template NAME
   return $self->{data}->{NAME}->[0] || $self->{data}->{TEMPLATE}->[0]->{NAME}->[0];
}

sub create {
   my ($self, $name) = @_;
   return $self->_allocate([ string => $name ]);
}

1;
