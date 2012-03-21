#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"
#define NEED_sv_2pvbyte
#include "ppport.h"

#include "mkdio.h"

static inline SV* MKD_BLESS(const char* class_name, MMIOT* obj) {
    SV* sv;
    HV* hv;

    hv = (HV*)sv_2mortal((SV*)newHV());
    sv = sv_2mortal(newRV_inc((SV*)hv));

    sv_bless(sv, gv_stashpv(class_name, 1));

    sv_magic((SV*)hv, NULL, PERL_MAGIC_ext, NULL, 0);
    mg_find((SV*)hv, PERL_MAGIC_ext)->mg_obj = obj;

    return sv;
}

MODULE=Text::Discount PACKAGE=Text::Discount PREFIX=mkd_

PROTOTYPES: DISABLE

# Input functions
void
_new_from_file(char* class, FILE* f, int flags = 0)
PREINIT:
    SV* sv;
    MMIOT* m;
CODE:
{
    m  = mkd_in(f, flags);
    sv = MKD_BLESS(class, m);

    ST(0) = sv;
    XSRETURN(1);
}

void
_new_from_string(char* class, SV* sv_str, int flags = 0)
PREINIT:
    char* str;
    STRLEN len;
    SV* sv;
    MMIOT* m;
CODE:
{
    str = SvPV(sv_str, len);
    m = mkd_string(str, len, flags);

    sv = MKD_BLESS(class, m);

    ST(0) = sv;
    XSRETURN(1);
}

# "Big Picture"-style processing functions
int
markdown(MMIOT* doc, FILE* out, int flags = 0)

int
mkd_line(char* bfr, int size, char*& out, int flags = 0)

int
mkd_generateline(char* bfr, int size, FILE* out, int flags = 0)

# Fine-grained access to the internals
int
mkd_compile(MMIOT* doc, int flags = 0)

int
mkd_generatehtml(MMIOT* doc, FILE* out)

void
mkd_document(MMIOT* doc)
PREINIT:
    char* out;
    SV* sv_out;
    int r;
CODE:
{
    r = mkd_document(doc, &out);

    sv_out = sv_2mortal(newSV(0));
    sv_setpv(sv_out, out);

    ST(0) = sv_out;
    XSRETURN(1);
}

void
mkd_css(MMIOT* doc)
PREINIT:
    char* out;
    SV* sv_out;
    int r;
CODE:
{
    r = mkd_css(doc, &out);

    sv_out = sv_2mortal(newSV(0));
    sv_setpv(sv_out, out);

    ST(0) = sv_out;
    XSRETURN(1);
}

int
mkd_generatecss(MMIOT* doc, FILE* out)

void
mkd_toc(MMIOT* doc)
PREINIT:
    char* out;
    SV* sv_out;
    int r;
CODE:
{
    r = mkd_toc(doc, &out);

    sv_out = sv_2mortal(newSV(0));
    sv_setpv(sv_out, out);

    ST(0) = sv_out;
    XSRETURN(1);
}

int
mkd_generatetoc(MMIOT* doc, FILE* out)

int
mkd_dump(MMIOT* doc, FILE* f, int flags, char* title)

void
mkd_cleanup(MMIOT* doc)

# Document header access functions
char*
mkd_doc_title(MMIOT* doc)

char*
mkd_doc_author(MMIOT* doc)

char*
mkd_doc_date(MMIOT* doc)


