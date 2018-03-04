# --
# Copyright (C) 2001-2017 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

use strict;
use warnings;
use utf8;

use vars (qw($Self));

# get helper object
$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Helper' => {
        RestoreDatabase => 1,
    },
);
my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

# get command object
my $CommandObject = $Kernel::OM->Get('Kernel::System::Console::Command::Dev::Tools::Database::RandomDataInsert');

my ( $Result, $ExitCode );

# try to execute command without any options
$ExitCode = $CommandObject->Execute();
$Self->Is(
    $ExitCode,
    1,
    "No options",
);

$ExitCode = $CommandObject->Execute( '--generate-tickets', 1 );
$Self->Is(
    $ExitCode,
    0,
    "Ticket created",
);

# cleanup cache is done by RestoreDatabase

1;
