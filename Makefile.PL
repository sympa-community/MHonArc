use ExtUtils::MakeMaker;

WriteMakefile(
    'NAME'         => 'MHonArc',
    'VERSION_FROM' => 'lib/MHonArc.pm',
    'AUTHOR'       => ['Earl Hood <mhonarc@mhonarc.org>'],
    'ABSTRACT'     => 'Convert mail/news messages to HTML',
    'EXE_FILES'    => [
        'mha-dbedit',
        'mha-dbrecover',
        'mha-decode',
        'mhonarc'
    ],
    'LICENSE'       => 'gpl_2',
    'PREREQ_PM'     => {
        'Fcntl'            => 0,
        'File::Basename'   => 0,
        'Getopt::Long'     => 0,
        'Symbol'           => 0,
        'Time::Local'      => 0
    },
    'META_MERGE'    => {
        "meta-spec" => { version => 2 },
        resources => {
            repository => {
                type => 'git',
                url  => 'https://github.com/sympa-community/mhonarc.git',
                web  => 'https://github.com/sympa-community/mhonarc'
            },
            bugtracker => {
                web  => 'https://github.com/sympa-community/mhonarc/issues'
            }
        },
        prereqs => {
            runtime => {
                recommends => {
                    'Digest::MD5'  => 0,
                    'Encode'       => 0,
                    'File::Temp'   => 0,
                    'MIME::Base64' => 0,
                    'POSIX'        => 0
                }
            }
        }
    }
);
