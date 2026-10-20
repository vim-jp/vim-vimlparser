vim9script
interface HasSurface
  var size: number
  def Surface(): number
endinterface
abstract class Shape
  var color = 'black'
  public var thickness = 10
  static var count: number
  public static var result: number
  static final LIMIT = 9
  abstract def Draw()
  static def Create(): Shape
    return null_object
  enddef
endclass
class Square extends Shape implements HasSurface
  var size: number
  var _protected: list<string>
  def new(this.size, this.color = v:none)
    this._protected = []
  enddef
  def Surface(): number
    return this.size * this.size
  enddef
  def Draw()
    super.Draw()
  enddef
endclass
enum Color
  White,
  Red,
  Green, Blue, Black
endenum
enum Planet implements HasSurface
  Earth(1, false),
  Jupiter(95, true),
  Saturn(146, true)
  var moons: number
  var has_rings: bool
  def GetMoons(): number
    return this.moons
  enddef
endenum
type ListOfStrings = list<string>
export class Exported
endclass
export abstract class ExportedAbstract
endclass
var sq = Square.new(3)
echo sq.Surface() Planet.Earth.GetMoons() Color.Red.name
