$pdf_mode = 4;
$lualatex = "lualatex -synctex=1 -interaction=nonstopmode -file-line-error -shell-escape %O %S";
$clean_ext = "acn glg loc nav pyg snm soc synctex.gz thm vrb";
$success_cmd = "cp %D ~/Documents/latexmk/"
