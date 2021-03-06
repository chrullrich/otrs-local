# --
# Copyright (C) 2001-2021 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::Language::en;

use strict;
use warnings;
use utf8;

sub Data {
    my $Self = shift;

    # http://en.wikipedia.org/wiki/Date_and_time_notation_by_country#United_States
    # month-day-year (e.g., "12/31/99")

    # $$START$$
    # Last translation file sync: Fri Jan 12 14:50:51 2018

    # possible charsets
    $Self->{Charset} = ['utf-8'];

    # date formats (%A=WeekDay;%B=LongMonth;%T=Time;%D=Day;%M=Month;%Y=Year;)
    $Self->{DateFormat}          = '%Y-%M-%D %T';
    $Self->{DateFormatLong}      = '%T - %Y-%M-%D';
    $Self->{DateFormatShort}     = '%Y-%M-%D';
    $Self->{DateInputFormat}     = '%Y-%M-%D';
    $Self->{DateInputFormatLong} = '%Y-%M-%D - %T';
    $Self->{Separator}           = ',';
    $Self->{DecimalSeparator}    = '.';
    $Self->{ThousandSeparator}   = ',';

    $Self->{Translation} = {
        'May_long' => 'May',
    };

    $Self->{JavaScriptStrings} = [
        'May_long',
    ];

    # $$STOP$$
    return;
}

1;
