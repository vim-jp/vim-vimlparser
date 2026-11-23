vim9script
def Highlight(new: string, list: list<string>)
  list
    ->add(new)
enddef
def Open()
  new
  vertical new
enddef
