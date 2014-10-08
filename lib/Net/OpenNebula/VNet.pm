#
# (c) Jan Gehring <jan.gehring@gmail.com>
# 
# vim: set ts=3 sw=3 tw=0:
# vim: set expandtab:
#
# !no_doc!
  

package Net::OpenNebula::VNet;

use strict;
use warnings;
use version;

use Net::OpenNebula::RPC;
push our @ISA , qw(Net::OpenNebula::RPC);

use constant ONERPC => 'vn';
use constant ONEPOOLKEY => 'VNET';

sub create {
   my ($self, $tpl_txt, %option) = @_;
   return $self->_allocate([ string => $tpl_txt ],
                           [ int => (exists $option{cluster} ? $option{cluster} : -1) ],
                           );
}

sub name {
   my ($self) = @_;
   $self->_get_info();

   return $self->{extended_data}->{NAME}->[0];
}

sub used {
   my ($self) = @_;
   $self->_get_info();
   if ($self->{extended_data}->{TOTAL_LEASES}->[0]) {
       return 1;
   } 
};

# New since 4.8.0
sub _ar {
    my ($self, $txt, $mode) = @_;

    if ($self->{rpc}->version() < version->new('4.8.0')) {
        $self->error("AR RPC API new since 4.8.0");
        return;
    }

    $mode = "add" if (! ($mode && $mode =~ m/^(add|rm|update)$/));

    my $what = [ string => $txt ];
    if ($mode =~ m/^(rm|free)$/) {
        if ($txt =~ m/^\d+$/) {
            $what = [ int => $txt ];
        } else {
            $self->error("_ar mode $mode expects integer ID, got $txt");
            return;
        }
    };

    return $self->_onerpc("${mode}_ar",
                          [ int => $self->id ], 
                          $what,
                          );
}

sub addar {
    my ($self, $txt) = @_;
    return $self->_ar($txt, "add");
}

# the id is in the template as AR_ID
sub updatear {
    my ($self, $txt) = @_;
    return $self->_ar($txt, "update");
}

sub rmar {
    my ($self, $id) = @_;
    return $self->_ar($id, "rm");
}

sub freear {
    my ($self, $id) = @_;
    return $self->_ar($id, "free");
}

# Removed since 4.8.0
sub _leases {
    my ($self, $txt, $mode) = @_;

    if ($self->{rpc}->version() >= version->new('4.8.0')) {
        $self->error("Leases RPC API removed since 4.8.0");
        return;
    }

    $mode = "add" if (! ($mode && $mode =~ m/^(add|rm)$/));
	
    return $self->_onerpc("${mode}leases", 
                          [ int => $self->id ], 
                          [ string => $txt ]
                          );
}

sub addleases {
    my ($self, $txt) = @_;
    return $self->_leases($txt, "add");
}

sub rmleases {
    my ($self, $txt) = @_;
    return $self->_leases($txt, "rm");
}

1;
