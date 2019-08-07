#
# (c) Jan Gehring <jan.gehring@gmail.com>
#
# vim: set ts=3 sw=3 tw=0:
# vim: set expandtab:
#
# !no_doc!
use strict;
use warnings;

package Net::OpenNebula::VMGroup;

use Net::OpenNebula::RPC;
push our @ISA , qw(Net::OpenNebula::RPC);

use constant ONERPC => 'vmgroup';

sub create {
   my ($self, $tpl_txt) = @_;
   return $self->_allocate([ string => $tpl_txt ]);
}

1;
