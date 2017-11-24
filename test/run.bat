@echo off
vim -Nu test/vimrc -S test/run.vim
set EXIT=%ERRORLEVEL%
if exist test.log type test.log
exit /b %EXIT%
