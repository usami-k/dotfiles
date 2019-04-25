#!/usr/bin/env perl
$latex = 'uplatex %O -interaction=nonstopmode %S';
$pdflatex = 'pdflatex %O -interaction=nonstopmode %S';
$lualatex = 'lualatex %O -interaction=nonstopmode %S';
$xelatex = 'xelatex %O -interaction=nonstopmode %S';
$biber = 'biber %O --bblencoding=utf8 -u -U --output_safechars %B';
$bibtex = 'upbibtex %O %B';
$makeindex = 'upmendex %O -o %D %S';
$dvipdf = 'dvipdfmx %O -o %D %S';
$dvips = 'dvips %O -z -f %S | convbkmk -u > %D';
$ps2pdf = 'ps2pdf %O %S %D';
$pdf_mode = 4;
