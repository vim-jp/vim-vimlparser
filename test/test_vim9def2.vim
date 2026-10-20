vim9script
def SubBlankHyphen(
    text: string,  # the text
    separator: string = ' '
): string
  return text->substitute('[[:blank:]]', separator, 'g')
enddef
def Zip<T, U>(first: list<T>, second: list<U>): list<tuple<T, U>>
  return []
enddef
def In20s(_, _, year: number): void
  count += year >= 2020 ? 1 : 0
enddef
def F(...l: list<number>): number # comment
  return Zip<number, number>(l, l)->len()
enddef
def! g:Global()
  def Inner(): string
    return 'inner'
  enddef
  echo Inner()
enddef
