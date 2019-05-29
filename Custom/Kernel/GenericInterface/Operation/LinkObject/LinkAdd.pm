# --
# Kernel/GenericInterface/Operation/LinkObject/LinkAdd.pm - GenericInterface LinkAdd operation backend
# Copyright (C) 2016 ArtyCo (Artjoms Petrovs), http://artjoms.lv/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::GenericInterface::Operation::LinkObject::LinkAdd;

use strict;
use warnings;

use Kernel::System::VariableCheck qw(IsStringWithData IsHashRefWithData);

use parent qw(
    Kernel::GenericInterface::Operation::Common
    Kernel::System::LinkObject
);

=head1 NAME

Kernel::GenericInterface::Operation::LinkObject::LinkAdd - GenericInterface Link Create Operation backend

=head1 SYNOPSIS

=head1 PUBLIC INTERFACE

=head2 new()

usually, you want to create an instance of this
by using Kernel::GenericInterface::Operation->new();

=cut

sub new {
    my ( $Type, %Param ) = @_;

    my $Self = {};
    bless( $Self, $Type );

    # check needed objects
    for my $Needed (qw( DebuggerObject WebserviceID )) {
        if ( !$Param{$Needed} ) {
            return {
                Success      => 0,
                ErrorMessage => "Got no $Needed!",
            };
        }

        $Self->{$Needed} = $Param{$Needed};
    }

    # create additional objects
    $Self->{LinkObject}
        = $Kernel::OM->Get('Kernel::System::LinkObject');

    return $Self;
}

=item Run()

Create a new link.

    my $Result = $OperationObject->Run(
        Data => {
            SourceObject => 'Ticket',
            SourceKey    => '321',
            TargetObject => 'Ticket',
            TargetKey    => '12345',
            Type         => 'ParentChild',
            State        => 'Valid',
            UserID       => 1,
        },
    );

    $Result = {
        Success      => 1,                                # 0 or 1
        ErrorMessage => '',                               # In case of an error
        Data         => {
            Result => 1,                                  # 0 or 1 
        },
    };

=cut

sub Run {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !IsHashRefWithData( $Param{Data} ) ) {
        return $Self->ReturnError(
            ErrorCode    => 'LinkAdd.MissingParameter',
            ErrorMessage => "LinkAdd: The request data is invalid!",
        );
    }

    if ( !$Param{Data}->{SourceObject} || !$Param{Data}->{TargetObject} ) {
        return $Self->ReturnError(
            ErrorCode    => 'LinkAdd.MissingParameter',
            ErrorMessage => "LinkAdd: SourceObject and TargetObject are required!"
        );
    }

    if (
        !$Param{Data}->{UserLogin}
        && !$Param{Data}->{SessionID}
        )
    {
        return $Self->ReturnError(
            ErrorCode    => 'LinkAdd.MissingParameter',
            ErrorMessage => "LinkAdd: UserLogin or SessionID is required!",
        );
    }

    if ( $Param{Data}->{UserLogin} && !$Param{Data}->{Password} ) {
        return $Self->ReturnError(
            ErrorCode    => 'LinkAdd.MissingParameter',
            ErrorMessage => "LinkAdd: Password or SessionID is required!",
        );
    }

    # authenticate user
    my ( $UserID, $UserType ) = $Self->Auth(%Param);

    if ( !$UserID ) {
        return $Self->ReturnError(
            ErrorCode    => 'LinkAdd.AuthFail',
            ErrorMessage => "LinkAdd: User could not be authenticated!",
        );
    }

    my $PermissionUserID = $UserID;

    my $LinkID = $Self->{LinkObject}->LinkAdd(
        SourceObject => $Param{Data}->{SourceObject},
        SourceKey => $Param{Data}->{SourceKey},
        TargetObject => $Param{Data}->{TargetObject},
        TargetKey => $Param{Data}->{TargetKey},
        Type => $Param{Data}->{Type},
        State => $Param{Data}->{State},
        UserID => $Param{Data}->{UserID},
    );

    if ( !$LinkID ) {
        return $Self->ReturnError(
            ErrorCode    => 'LinkAdd.Failed',
            ErrorMessage => "LinkAdd: Operation failed.",
        );
    }

    return {
        Success => 1,
        Data    => {
            Result => $LinkID,
        },
    };
}

1;

=back

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (L<http://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (AGPL). If you
did not receive this file, see L<http://www.gnu.org/licenses/agpl.txt>.

=cut

