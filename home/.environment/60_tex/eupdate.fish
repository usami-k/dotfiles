#!/usr/bin/env fish

if command --query tlmgr
    tlmgr update --self --all --reinstall-forcibly-removed

    # Install cpan modules for latexindent
    yes | /usr/local/texlive/2021/texmf-dist/doc/support/latexindent/latexindent-module-installer.pl
end
