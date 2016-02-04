#
# (c) Jan Gehring <jan.gehring@gmail.com>
#
# vim: set ts=3 sw=3 tw=0:
# vim: set expandtab:
#
use strict;
use warnings;

package Net::OpenNebula::User;

use Net::OpenNebula::RPC;
push our @ISA , qw(Net::OpenNebula::RPC);

use constant ONERPC => 'user';

sub name {
   my ($self) = @_;
   $self->_get_info();

   # if user NAME is set, use that instead of template NAME
   return $self->{data}->{NAME}->[0] || $self->{data}->{TEMPLATE}->[0]->{NAME}->[0];
}

sub create {
   my ($self, $name, $password, $driver) = @_;
   if (! defined $driver) {
       $driver = "core";
   }
   return $self->_allocate([ string => $name ],
                           [ string => $password ],
                           [ string => $driver ],
                          );
}

# foir current user, apply method to groupid
sub _do_grp {
    my ($self, $grp_id, $method) = @_;

    $self->has_id($method) || return;

    $self->debug(1, "$self->{ONERPC} $method id ".$self->id." group id $grp_id");
    return $self->_onerpc($method,
                          [ int => $self->id ],
                          [ int => $grp_id ],
                          );
}

# chgrp groupid
sub chgrp {
    my ($self, $grp_id) = shift;
    return $self->_do_grp($grp_id, 'chgrp');
}

# addgroup groupid
sub addgroup {
    my ($self, $grp_id) = shift;
    return $self->_do_grp($grp_id, 'addgroup');
}

# delgroup groupid
sub delgroup {
    my ($self, $grp_id) = shift;
    return $self->_do_grp($grp_id, 'delgroup');
}

1;
