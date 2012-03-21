package Text::Discount;
use strict;
use Carp;
use XSLoader;
use parent 'Exporter';

our $VERSION = '0.1';

BEGIN {
    my %constants = (
        MKD_NOLINKS         => 0x00000001, # /* don't do link processing, block <a> tags  */
        MKD_NOIMAGE         => 0x00000002, # /* don't do image processing, block <img> */
        MKD_NOPANTS         => 0x00000004, # /* don't run smartypants() */
        MKD_NOHTML          => 0x00000008, # /* don't allow raw html through AT ALL */
        MKD_STRICT          => 0x00000010, # /* disable SUPERSCRIPT, RELAXED_EMPHASIS */
        MKD_TAGTEXT         => 0x00000020, # /* process text inside an html tag, no
                                           #  * <em>, no <bold>, no html or [] expansion */
        MKD_NO_EXT          => 0x00000040, # /* don't allow pseudo-protocols */
        MKD_NOEXT           => 0x00000040, # /* ^^^ (aliased for user convenience) */
        MKD_CDATA           => 0x00000080, # /* generate code for xml ![CDATA[...]] */
        MKD_NOSUPERSCRIPT   => 0x00000100, # /* no A^B */
        MKD_NORELAXED       => 0x00000200, # /* emphasis happens /everywhere/ */
        MKD_NOTABLES        => 0x00000400, # /* disallow tables */
        MKD_NOSTRIKETHROUGH => 0x00000800, # /* forbid ~~strikethrough~~ */
        MKD_TOC             => 0x00001000, # /* do table-of-contents processing */
        MKD_1_COMPAT        => 0x00002000, # /* compatibility with MarkdownTest_1.0 */
        MKD_AUTOLINK        => 0x00004000, # /* make http://foo.com link even without <>s */
        MKD_SAFELINK        => 0x00008000, # /* paranoid check for link protocol */
        MKD_NOHEADER        => 0x00010000, # /* don't process header blocks */
        MKD_TABSTOP         => 0x00020000, # /* expand tabs to 4 spaces */
        MKD_NODIVQUOTE      => 0x00040000, # /* forbid >%class% blocks */
        MKD_NOALPHALIST     => 0x00080000, # /* forbid alphabetic lists */
        MKD_NODLIST         => 0x00100000, # /* forbid definition lists */
        MKD_EXTRA_FOOTNOTE  => 0x00200000, # /* enable markdown extra-style footnotes */
        MKD_EMBED           => 0x00000001|0x00000002|0x00000020,
    );

    require constant;
    import constant \%constants;

    our @EXPORT = keys %constants;
}

XSLoader::load __PACKAGE__, $VERSION;

sub new {
    my ($class, $string, $flags) = @_;

    my $self = $class->_new_from_string($string, $flags);
    $self->compile($flags);

    $self;
}

sub new_from_fh {
    my ($class, $fh, $flags) = @_;

    my $self = $class->_new_from_file($fh, $flags);
    $self->compile($flags);

    $self;
}

sub new_from_file {
    my ($class, $file, $flags) = @_;

    open my $fh, '<', $file or croak $!;
    my $self = $class->new_from_fh($fh);
    close $fh;

    $self;
}

sub DESTROY {
    $_[0]->cleanup;
}

1;

__END__

=head1 NAME

Text::Discount - 

=head1 AUTHOR

Daisuke Murase <typester@cpan.org>

=cut

