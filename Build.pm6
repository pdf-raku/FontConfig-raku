#Note `zef build .` will run the Build.build() method
class Build {
    need LibraryMake;
    # adapted from deprecated Native::Resources

    #| Sets up a C<Makefile> and runs C<make>.  C<$folder> should be
    #| C<"$folder/resources/libraries"> and C<$libname> should be the name of the library
    #| without any prefixes or extensions.
    sub make(Str $folder, Str $destfolder, IO() :$libname!,
             Str :$I is copy,
             Str :$L is copy) {

        if $*DISTRO.name eq 'macos' {
            for </opt/homebrew/include /usr/local/include> {
                $I //= $_ if .IO.d;
            }
        
            for </opt/homebrew/lib /usr/local/lib> {
                $L //= $_ if .IO.d;
            }
        }
        
        my %vars = LibraryMake::get-vars($destfolder);
        %vars<LIB_BASE> = $libname;
        %vars<LIB_NAME> = ~ $*VM.platform-library-name($libname);
        %vars<LIB-LDFLAGS> = $L ?? "-L$L" !! '';
        %vars<LIB-CFLAGS> = $I ?? "-I$I" !! '';
        %vars<LIBS> = '-lfontconfig';
        mkdir($destfolder);
        LibraryMake::process-makefile($folder, %vars);
        shell(%vars<MAKE>);
    }

    method build($workdir, Str :$I, Str :$L) {

        if Rakudo::Internals.IS-WIN {
            # DLLs are prebuilt on Windows. See 'build-libraries
            # job in .github/workflows/test.yml
            note "Using pre-built DLL on Windows";
        }
        else {
            my $destdir = 'resources/libraries';
            mkdir 'resources';
            mkdir $destdir;
            make($workdir, $destdir, :libname<fc_raku>, :$I, :$L);
        }
        True;
    }
}

# Build.pm6 can also be run standalone
sub MAIN(Str $working-directory = '.', Str :$I, Str :$L) {
    Build.new.build($working-directory, :$I, :$L);
}
