@echo off
vim -u NONE -N --cmd "let &rtp .= ',' . getcwd()" -S test/run.vim
set EXIT=%ERRORLEVEL%
if exist test.log type test.log
exit /b %EXIT%
