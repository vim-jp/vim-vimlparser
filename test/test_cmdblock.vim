" legacy script
command -register YankHelpGrep {
  const SAVE = @"
  normal! y
  execute $"helpgrep {getreg('<register>')}"
  @" = SAVE
  copen
}
autocmd BufWritePre * {
  var x = 1
  echo x
}
command NoBlock echo '{'
