## Build from repo

### Requirements

    cpanm Module::Install
    cpanm Module::Install::XSUtil

### Build

    git clone git://github.com/typester/Text-Discount.git
    cd Text-Discount
    git submodule update --init
    perl Makefile.PL
    make

