# --
# Copyright (C) 2001-2021 OTRS AG, https://otrs.com/
# Copyright (C) 2021 Znuny GmbH, https://znuny.org/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --
#  Note:
#
#  -->> Most Znuny configuration should be done via the Znuny web interface
#       and the SysConfig. Only for some configuration, such as database
#       credentials and customer data source changes, you should edit this
#       file. For changes do customer data sources you can copy the definitions
#       from Kernel/Config/Defaults.pm and paste them in this file.
#       Config.pm will not be overwritten when updating Znuny.
# --

package Kernel::Config;

use strict;
use warnings;
use utf8;

sub Load {
    my $Self = shift;

    # ---------------------------------------------------- #
    # database settings                                    #
    # ---------------------------------------------------- #

    # The database host
    $Self->{DatabaseHost} = '127.0.0.1';

    # The database name
    $Self->{Database} = 'znuny';

    # The database user
    $Self->{DatabaseUser} = 'znuny';

    # The password of database user. You also can use bin/znuny.Console.pl Maint::Database::PasswordCrypt
    # for crypted passwords
    $Self->{DatabasePw} = $ENV{"OTRS_DATABASE_PASSWORD"};

    # The database DSN for MySQL ==> more: "perldoc DBD::mysql"
    $Self->{DatabaseDSN} = "DBI:mysql:database=$Self->{Database};host=$Self->{DatabaseHost};";

    # The database DSN for PostgreSQL ==> more: "perldoc DBD::Pg"
    # if you want to use a local socket connection
#    $Self->{DatabaseDSN} = "DBI:Pg:dbname=$Self->{Database};";
    # if you want to use a TCP/IP connection
#    $Self->{DatabaseDSN} = "DBI:Pg:dbname=$Self->{Database};host=$Self->{DatabaseHost};";

    # The database DSN for Oracle ==> more: "perldoc DBD::oracle"
#    $Self->{DatabaseDSN} = "DBI:Oracle://$Self->{DatabaseHost}:1521/$Self->{Database}";
#
#    $ENV{ORACLE_HOME}     = '/path/to/your/oracle';
#    $ENV{NLS_DATE_FORMAT} = 'YYYY-MM-DD HH24:MI:SS';
#    $ENV{NLS_LANG}        = 'AMERICAN_AMERICA.AL32UTF8';

    # ---------------------------------------------------- #
    # fs root directory
    # ---------------------------------------------------- #
    $Self->{Home} = '/opt/znuny';

    # ---------------------------------------------------- #
    # insert your own config settings "here"               #
    # config settings taken from Kernel/Config/Defaults.pm #
    # ---------------------------------------------------- #
    # $Self->{SessionUseCookie} = 0;
    # $Self->{CheckMXRecord} = 0;

    $Self->{'AuthModule'} = 'Kernel::System::Auth::HTTPBasicAuth';
    $Self->{'Customer::AuthModule'} = 'Kernel::System::CustomerAuth::HTTPBasicAuth';
    $Self->{'CustomerPanelCreateAccount'} = 0;
    $Self->{'CustomerPanelLostPassword'} = 0;

    $Self->{CustomerUser1} = {
        Name   => 'Address Book',
        Module => 'Kernel::System::CustomerUser::DB',
        Params => {
            Table => 'ext.address_book',
            SearchCaseSensitive => 0,
        },

        # customer unique id
        CustomerKey => 'login',

        # customer #
        CustomerID    => 'customer_id',
        CustomerValid => 'valid_id',

        # The last field must always be the email address so that a valid
        #   email address like "John Doe" <john.doe@domain.com> can be constructed from the fields.
        CustomerUserListFields => [ 'full_name', 'email' ],

#        CustomerUserListFields => ['login', 'first_name', 'last_name', 'customer_id', 'email'],
        CustomerUserSearchFields           => [ 'full_name', 'customer_id', 'email' ],
        CustomerUserSearchPrefix           => '*',
        CustomerUserSearchSuffix           => '*',
        CustomerUserSearchListLimit        => 250,
        CustomerUserPostMasterSearchFields => [ 'email' ],
        CustomerUserNameFields             => [ 'full_name' ],
        CustomerUserEmailUniqCheck         => 1,

#        # Configures the character for joining customer user name parts. Join single space if it is not defined.
#        # CustomerUserNameFieldsJoin => '',

#        # show now own tickets in customer panel, CompanyTickets
#        CustomerUserExcludePrimaryCustomerID => 0,
#        # generate auto logins
#        AutoLoginCreation => 0,
#        # generate auto login prefix
#        AutoLoginCreationPrefix => 'auto',
#        # admin can change customer preferences
#        AdminSetPreferences => 1,
        # use customer company support (reference to company, See CustomerCompany settings)
        CustomerCompanySupport => 0,
        # cache time to live in sec. - cache any database queries
        CacheTTL => 60 * 60 * 24,
#        # Consider this source read only.
#        ReadOnly => 1,
        Map => [

            # Info about dynamic fields:
            #
            # Dynamic Fields of type CustomerUser can be used within the mapping (see example below).
            # The given storage (third column) then can also be used within the following configurations (see above):
            # CustomerUserSearchFields, CustomerUserPostMasterSearchFields, CustomerUserListFields, CustomerUserNameFields
            #
            # Note that the columns 'frontend' and 'readonly' will be ignored for dynamic fields.

            # note: Login, Email and CustomerID needed!
            # var, frontend, storage, shown (1=always,2=lite), required, storage-type, http-link, readonly, http-link-target, link class(es)
            [ 'UserName',    'Name',           'full_name',     1, 1, 'var', '', 0, undef, undef ],
            [ 'UserLogin',        'Username',            'login',          1, 1, 'var', '', 0, undef, undef ],
            [ 'UserEmail',        'Email',               'email',          1, 1, 'var', '', 0, undef, undef ],
#            [ 'UserEmail',        'Email',               'email',          1, 1, 'var', '[% Env("CGIHandle") %]?Action=AgentTicketCompose;ResponseID=1;TicketID=[% Data.TicketID | uri %];ArticleID=[% Data.ArticleID | uri %]', 0, '', 'AsPopup OTRSPopup_TicketAction' ],
            [ 'UserCustomerID',   'CustomerID',          'customer_id',    0, 1, 'var', '', 0, undef, undef ],
#            [ 'UserCustomerIDs',  'CustomerIDs',         'customer_ids',   1, 0, 'var', '', 0, undef, undef ],
	    #[ 'UserPhone',        'Phone',               'phone',          1, 0, 'var', '', 0, undef, undef ],
	    #[ 'UserFax',          'Fax',                 'fax',            1, 0, 'var', '', 0, undef, undef ],
	    #[ 'UserMobile',       'Mobile',              'mobile',         1, 0, 'var', '', 0, undef, undef ],
	    #[ 'UserStreet',       'Street',              'street',         1, 0, 'var', '', 0, undef, undef ],
	    #[ 'UserZip',          'Zip',                 'zip',            1, 0, 'var', '', 0, undef, undef ],
	    #[ 'UserCity',         'City',                'city',           1, 0, 'var', '', 0, undef, undef ],
	    #[ 'UserCountry',      'Country',             'country',        1, 0, 'var', '', 0, undef, undef ],
            [ 'UserComment',      'Comment',             'comments',       1, 0, 'var', '', 0, undef, undef ],
            [ 'ValidID',          'Valid',               'valid_id',       0, 1, 'int', '', 0, undef, undef ],

            # Dynamic field example
#            [ 'DynamicField_Name_X', undef, 'Name_X', 0, 0, 'dynamic_field', undef, 0, undef, undef ],
        ],

        # default selections
        Selections => {

#            UserTitle => {
#                'Mr.' => 'Mr.',
#                'Mrs.' => 'Mrs.',
#            },
        },
    };


    # ---------------------------------------------------- #

    # ---------------------------------------------------- #
    # data inserted by installer                           #
    # ---------------------------------------------------- #
    # $DIBI$

    # ---------------------------------------------------- #
    # ---------------------------------------------------- #
    #                                                      #
    # end of your own config options!!!                    #
    #                                                      #
    # ---------------------------------------------------- #
    # ---------------------------------------------------- #

    return 1;
}

# ---------------------------------------------------- #
# needed system stuff (don't edit this)                #
# ---------------------------------------------------- #

use Kernel::Config::Defaults; # import Translatable()
use parent qw(Kernel::Config::Defaults);

# -----------------------------------------------------#

1;
