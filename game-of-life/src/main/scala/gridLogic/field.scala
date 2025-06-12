package gridLogic

import cellLogic.MainCell
import cellLogic.emptyCell
import cellLogic.enemyCell
import cellLogic.generatorCell
import cellLogic.pushableCell
import cellLogic.pushCell
import cellLogic.turnCell
import cellLogic.unpushableBlock
import cellLogic.unturnableCell
import drawLogic.drawCell

import scala.reflect.ClassTag

class field[T: ClassTag] (Xelements: Int, Yelements: Int, nullType: T){
  var field: Array[Array[T]] = Array.ofDim[T](Xelements, Yelements) //generisch zodat het veld herbruikbaar is voor andere implementaties

  def fillField(): Unit ={ // vul het veld met lege elementen
    for i <- 0 to Xelements - 1 do{
      for j <- 0 to Yelements - 1 do{
        field(i)(j) = nullType
      }
    }
  }

  def fillSide(side:String, element:T): Unit ={ // vul een van de randen met een bep element, obv een for loop 
    side match {
      case "U" =>{
        for i <- 0 to Xelements - 1 do{
          field(i)(0) = element
        }
      }
      case "D" =>{
        for i <- 0 to Xelements - 1 do{
          field(i)(Yelements - 1) = element
        }
      }
      case "R" =>{
        for i <- 0 to Yelements - 1 do{
          field(Xelements - 1)(i) = element
        }
      }
      case "L" =>{
        for i <- 0 to Yelements - 1 do{
          field(0)(i) = element
        }
      }
    }
  }
  
  def copyField(otherField:field[T]): Unit ={ //kopieer het gehele veld van een ander veld naar dit veld
    for i <- 0 to Xelements - 1 do{
      for j <- 0 to Yelements - 1 do{
        field(i)(j) = otherField.get(i,j)
      }
    }
  }

  fillField()

  def insert(x:Int, y:Int, element: T): Unit ={ // voeg een element toe
    if element != nullType & x < Xelements & x > -1 & y < Yelements & y > -1 then field(x)(y) = element
  }

  def remove(x:Int, y:Int): Unit ={ // verwijder een element
    field(x)(y) = nullType
  }

  def get(x: Int,y: Int): T ={ // geef het element op positie (x,y) terug
    if x < Xelements & x > -1 & y < Yelements & y > -1 then {
      field(x)(y)
    } else {
      nullType
    }
  }
//geef het element boven, onder, rechts of links van (x,y) terug
  def elementAbove(x:Int, y:Int): T = {
    field(x)(y - 1)
  }
  def elementUnder(x:Int, y:Int): T = {
    field(x)(y + 1)
  }
  def elementRightOf(x:Int, y:Int): T = {
    field(x + 1)(y)
  }
  def elementLeftOf(x:Int, y:Int): T = {
    field(x - 1)(y)
  }
  def insideField(x:Int, y:Int): Boolean ={ // bevindt het element zich in het veld
    if x <= Xelements & x >= 0 & y <= Yelements & y >= 0 then
      true
    else false
  }
}
