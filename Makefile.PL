use inc::Module::Install;

name 'Text-Discount';
all_from 'lib/Text/Discount.pm';

requires 'parent';
requires 'XSLoader';

use_ppport 3.20;
cc_src_paths 'src';
cc_include_paths 'deps/discount';
cc_warnings;

makemaker_args->{MYEXTLIB} = 'deps/discount/libmarkdown$(LIB_EXT)';

{
    package MY;
    sub postamble {
        <<'__EOF__';
$(MYEXTLIB):
	cd deps/discount && sh configure.sh --enable-all-features --with-id-anchor && $(MAKE)
__EOF__
    }
}

WriteAll;
