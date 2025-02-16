#! /usr/bin/env perl6
#Note `zef build .` will run this script
use v6;

class Build {
    need LibraryMake;
    # adapted from deprecated Native::Resources

    #| Sets up a C<Makefile> and runs C<make>.  C<$folder> should be
    #| C<"$folder/resources/libraries"> and C<$libname> should be the name of the library
    #| without any prefixes or extensions.
    sub make(Str $folder, Str $destfolder, IO() :$libname!, Str :$I) {
        my %vars = LibraryMake::get-vars($destfolder);
        %vars<LIB_BASE> = $libname;
        %vars<LIB_NAME> = ~ $*VM.platform-library-name($libname);
        %vars<LIB-CFLAGS> = $I ?? "-I$I" !! '';
        %vars<LIBS> = '-lfontconfig';
        mkdir($destfolder);
        LibraryMake::process-makefile($folder, %vars);
        shell(%vars<MAKE>);
    }

    method build($workdir, Str :$I) {

        if Rakudo::Internals.IS-WIN {
            note "Using pre-built DLL on Windows";
        }
        else {
            # DLLs are prebuilt on Windows. See 'build-libraries
            # job in .github/workflows/test.yml

            my $destdir = 'resources/libraries';
            mkdir 'resources';
            mkdir $destdir;
            make($workdir, $destdir, :libname<fc_raku>, :$I);
        }
        True;
    }
}

# Build.pm can also be run standalone
sub MAIN(Str $working-directory = '.', Str :$I  ) {
    Build.new.build($working-directory, :$I);
}
