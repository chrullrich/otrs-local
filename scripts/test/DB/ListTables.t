# --
# Copyright (C) 2001-2019 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

use strict;
use warnings;
use utf8;

use vars (qw($Self));

my @Tables = $Kernel::OM->Get('Kernel::System::DB')->ListTables();

$Self->True(
    scalar( grep { $_ eq 'valid' } @Tables ),
    "Valid table found.",
);

1;
