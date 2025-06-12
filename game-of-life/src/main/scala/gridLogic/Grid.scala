package gridLogic
//package cellLogic

import collection.JavaConverters.asJavaIterableConverter
import mygame.GUI
import cellLogic.{MainCell, pushableCell, emptyCell, enemyCell, generatorCell, pushCell, turnCell, sliderCell, unpushableBlock, unturnableCell}
import gridLogic.field
import drawLogic.drawCell

import java.awt.{Color, Graphics, Graphics2D, Rectangle}


class Grid (Xelements: Int, Yelements: Int){
  val elementSize: Int = 50
  val padding: Int = 50
  val borders: Int = 2 * padding
  val gui = GUI((Xelements * elementSize) + borders, (Yelements * elementSize) + borders, Yelements, Xelements, padding)
  val grid = gui.getGridPanel()

  var feld = field[MainCell](Xelements, Yelements, emptyCell()) //het veld waar we uit halen
  var feld2 =  field[MainCell](Xelements, Yelements, emptyCell()) // het veld waar we insteken, we passen op het einde van elke iteratie feld aan naar feld2 en aan het begin feld2 naar feld
  var wasntPushed = field[Boolean](Xelements,Yelements,true)
 // pak de hoeveelheid x of y elementen
  def getXelements(): Int ={
    Xelements
  }
  def getYelements(): Int ={
    Yelements
  }

 def levelGenerator(levelNr:Int): Unit ={ //de 3 verschillende levels
   feld.fillSide("U",unpushableBlock())
   feld.fillSide("D",unpushableBlock())
   feld.fillSide("R",unpushableBlock())
   feld.fillSide("L",unpushableBlock())
   levelNr match
     case 1 =>{
       feld.insert(3, 2, generatorCell())
       feld.insert(4, 8, enemyCell())
       feld.insert(18, 4, enemyCell())
       feld.insert(13, 2, enemyCell())
       feld.insert(4, 7, enemyCell())
       feld.insert(7, 4, unturnableCell())
       feld.insert(1, 3, pushCell())
       feld.insert(11, 1, pushCell())
       feld.insert(6, 8, pushableCell())
       feld.insert(8, 8, unpushableBlock())
       feld.insert(9, 8, turnCell())
     }
     case 2 =>{
       var turntGen = generatorCell()
       turntGen.turnTheCell("Counter-clockwise")
       feld.insert(11, 1, unpushableBlock())
       feld.insert(7, 3, unpushableBlock())
       feld.insert(7, 4, unpushableBlock())
       feld.insert(9, 5, unpushableBlock())
       feld.insert(9, 6, unpushableBlock())
       feld.insert(9, 7, unpushableBlock())
       feld.insert(8, 4, enemyCell())
       feld.insert(7, 6, enemyCell())
       feld.insert(14, 2, enemyCell())
       feld.insert(3, 3, pushCell())
       feld.insert(3, 8, unturnableCell())
       feld.insert(5, 5, generatorCell())
       feld.insert(12, 6, turntGen)
       feld.insert(16, 5, pushableCell())
     }
     case 3 =>{
       feld.insert(4, 8, unpushableBlock())
       feld.insert(5, 8, unpushableBlock())
       feld.insert(5, 7, unpushableBlock())
       feld.insert(5, 6, unpushableBlock())
       feld.insert(7, 1, unpushableBlock())
       feld.insert(7, 2, unpushableBlock())
       feld.insert(9, 3, unpushableBlock())
       feld.insert(9, 4, unpushableBlock())
       feld.insert(9, 5, unpushableBlock())
       feld.insert(10, 6, unpushableBlock())
       feld.insert(10, 7, unpushableBlock())
       feld.insert(11, 8, unpushableBlock())
       feld.insert(16, 8, unpushableBlock())
       feld.insert(17, 7, unpushableBlock())
       feld.insert(17, 6, unpushableBlock())
       feld.insert(2, 3, sliderCell())
       feld.insert(5, 3, pushCell())
       feld.insert(16, 3, pushCell())
       feld.insert(9, 7, pushableCell())
       feld.insert(6, 4, enemyCell())
       feld.insert(11, 4, enemyCell())
       feld.insert(11, 3, enemyCell())
       feld.insert(14, 7, enemyCell())
       feld.insert(2, 7, turnCell())
     }
 }
  def setupStartingField() = {
    feld.fillField()
    levelGenerator(3) // pas het level aan adhv het gegeven nummer

  }

  setupStartingField()
// voeg een cel toe of verwijder er een
  def insert(x:Int, y:Int, cell: MainCell): Unit ={
    var trie = feld.get(3,2)
    feld.insert(x,y,cell)
  }
  def remove(x:Int, y:Int): Unit ={
    feld.remove(x,y)
  }

// pas het gegeven integer aan naar een coordinaat die we in het veld kunnen zetten
  def convertToCoord(coord:Int): Int ={
    (coord - padding) / elementSize
  }
// pak een bepaalde cel
  def getCell(x:Int, y:Int): MainCell ={
    feld.get(x,y)
  }
// check of er een cel van het bepaalde type in het veld zit
  def fieldHasCell(cellType:MainCell): Boolean ={
    var left = false
    for i <- 0 to Xelements do{
      for j <- 0 to Yelements do{
        if getCell(i,j).cellTypeID == cellType.cellTypeID then left = true
      }
    }
    left
  }
// geef een cel terug van hetzelfde type, maar niet dezelfde cel zelf
  def copyCellType(cell:MainCell): MainCell ={
    cell match
      case cell:enemyCell => new enemyCell()
      case cell:generatorCell => new generatorCell()
      case cell:pushableCell => new pushableCell()
      case cell:pushCell => new pushCell()
      case cell:turnCell => new turnCell()
      case cell:unpushableBlock => new unpushableBlock()
      case cell:unturnableCell => new unturnableCell()
      case _ => new emptyCell
  }
// heeft de cel buren
  def hasNeighbour(x: Int, y: Int): Boolean ={
    if (feld.elementAbove(x,y).cellTypeID != 1 || feld.elementUnder(x,y).cellTypeID != 1 || feld.elementLeftOf(x,y).cellTypeID != 1 || feld.elementRightOf(x,y).cellTypeID != 1) then {
      true
    } else {
      false
    }
  }
// set het wasntPushed veld op
  def setupPushed(): Unit ={
    wasntPushed.fillField()
  }
// kijk of er een vrije plek is om te duwen
  def findFree(x: Int, y:Int, Direction: Char): Int ={
    Direction match
      case 'U' => if feld.get(x,y).cellTypeID != 1 & feld.get(x,y).movable != false then findFree(x,y - 1,Direction) else y
      case 'D' => if feld.get(x,y).cellTypeID != 1 & feld.get(x,y).movable != false then findFree(x,y + 1,Direction) else y
      case 'R' => if feld.get(x,y).cellTypeID != 1 & feld.get(x,y).movable != false then findFree(x + 1,y,Direction) else x
      case 'L' => if feld.get(x,y).cellTypeID != 1 & feld.get(x,y).movable != false then findFree(x - 1,y,Direction) else x
  }
// raken we een onbeweegbare cel?
  def touchesImmobile(x: Int, y:Int, Direction: Char): Boolean ={
    var openSpot = false
    var touchesUnpushable = false
    var touchesEnemy = false
    Direction match
      case 'U' => {
        for i <- 0 to y do {
          if feld.get(x,i).cellTypeID == 1 then {
            openSpot = true
            touchesEnemy = false
            touchesUnpushable = false
          } else openSpot = false
          if feld.get(x,i).cellTypeID == 2 then touchesEnemy = true
          if feld.get(x,i).cellTypeID == 7 || (feld.get(x,i).cellTypeID == 10 && (feld.get(x,i).orientation == 'R' || feld.get(x,i).orientation == 'L')) then touchesUnpushable = true
        }
      }
      case 'D' => {
        for i <- y to Yelements do {
          if feld.get(x,i + 1).cellTypeID == 1 then openSpot = true
          if feld.get(x,i + 1).cellTypeID == 2 & !openSpot then touchesEnemy = true
          if (feld.get(x,i + 1).cellTypeID == 7 || (feld.get(x,i + 1).cellTypeID == 10 && (feld.get(x,i + 1).orientation == 'R' | feld.get(x,i + 1).orientation == 'L'))) & !openSpot then touchesUnpushable = true
        }
      }
      case 'R' => {
        for i <- x to Xelements + 1 do {
          if feld.get(i,y).cellTypeID == 1 then openSpot = true
          if feld.get(i,y).cellTypeID == 2 & !openSpot then touchesEnemy = true
          if (feld2.get(i,y).cellTypeID == 7 || (feld.get(i,y).cellTypeID == 10 && (feld.get(i,y).orientation == 'D' | feld.get(i,y).orientation == 'U'))) & !openSpot then touchesUnpushable = true
        }
      }
      case 'L' => {
        for i <- 0 to x do {
          if feld.get(i,y).cellTypeID == 1 then {
            openSpot = true
            touchesEnemy = false
            touchesUnpushable = false
          } else openSpot = false
          if feld.get(i,y).cellTypeID == 2 then touchesEnemy = true
          if feld.get(i,y).cellTypeID == 7 || (feld.get(i,y).cellTypeID == 10 && (feld.get(i,y).orientation == 'D' | feld.get(i,y).orientation == 'U')) then touchesUnpushable = true
        }
      }
      if !touchesEnemy then touchesUnpushable else false
  }
// duw de hele rij in een bep richting
  def pushRow(x: Int, y: Int, Direction:Char): Unit ={
    var limit = findFree(x, y, Direction)
      Direction match
        case 'U' => {
          for i <- limit to y - 1 do {
            wasntPushed.insert(x, i, false)
            if feld.get(x,i).cellTypeID != 2 then
              feld2.insert(x, i, feld.get(x, i + 1))
            else feld2.insert(x, i, emptyCell())
          }
          if feld.get(x, y).cellTypeID != 3 then feld2.remove(x, y)
        }
        case 'D' => {
          for i <- y + 1 to limit do {
            wasntPushed.insert(x, i, false)
            if feld.get(x,i).cellTypeID != 2 then
              feld2.insert(x, i, feld.get(x, i - 1))
            else feld2.insert(x, i, emptyCell())
          }
          if feld.get(x, y).cellTypeID != 3 then feld2.remove(x, y)
        }
        case 'R' => {
          for i <- x + 1 to limit do {
            wasntPushed.insert(i, y, false)
            if feld.get(i,y).cellTypeID != 2 then
              feld2.insert(i, y, feld.get(i - 1, y))
            else feld2.insert(i, y, emptyCell())
          }
          if feld.get(x, y).cellTypeID != 3 then feld2.remove(x, y)
        }
        case 'L' => {
          for i <- limit to x - 1 do {
            wasntPushed.insert(i, y, false)
            if feld.get(i,y).cellTypeID != 2 then
              feld2.insert(i, y, feld.get(i + 1, y))
            else feld2.insert(i, y, emptyCell())
          }
          if feld.get(x, y).cellTypeID != 3 then feld2.remove(x, y)
        }
  }
// draai de buren indien mogelijk
  def spinNeighbours(x: Int, y:Int, RotateDirection:String): Unit ={
    feld2.elementAbove(x,y).turnTheCell(RotateDirection)
    feld2.elementUnder(x,y).turnTheCell(RotateDirection)
    feld2.elementRightOf(x,y).turnTheCell(RotateDirection)
    feld2.elementLeftOf(x,y).turnTheCell(RotateDirection)
  }
// genereer een cel in de juiste richting, van de juiste source
def generate(x:Int, y:Int, Direction:Char): Unit ={
    Direction match
      case 'U' => if feld.get(x, y + 1).cellTypeID != 1 then feld2.insert(x, y - 1, copyCellType(feld.get(x, y + 1)))
      case 'D' => if feld.get(x, y - 1).cellTypeID != 1 then feld2.insert(x, y + 1, copyCellType(feld.get(x, y - 1)))
      case 'R' => if feld.get(x - 1, y).cellTypeID != 1 then feld2.insert(x + 1, y, copyCellType(feld.get(x - 1, y)))
      case 'L' => if feld.get(x + 1, y).cellTypeID != 1 then feld2.insert(x - 1, y, copyCellType(feld.get(x + 1, y)))
}
// kan ik een cel genereren? - staat er iets op de source
def canGenerate(x:Int, y:Int, Direction:Char): Boolean ={
  Direction match
    case 'U' => if feld.get(x, y + 1).cellTypeID != 1 then true else false
    case 'D' => if feld.get(x, y - 1).cellTypeID != 1 then true else false
    case 'R' => if feld.get(x - 1, y).cellTypeID != 1 then true else false
    case 'L' => if feld.get(x + 1, y).cellTypeID != 1 then true else false
}
// check de omgeving van dit coordinaat, functie die in elke iteratie wordt opgeroepen op de cellen die niet gepushed waren
  def checkSurrounding(x:Int, y:Int): Unit ={
    var notpushed = wasntPushed.get(x,y)
    var element = feld.get(x,y)
    var elementType = element.cellTypeID
    var elementAbove = feld.elementAbove(x,y)
    var elementUnder = feld.elementUnder(x,y)
    var elementRightOf = feld.elementLeftOf(x,y)
    var elementLeftOf = feld.elementRightOf(x,y)


    //---------------------------------------------------------------------------
    if notpushed != false then {
      elementType match
        case 3 => {
          if ! touchesImmobile(x,y,element.orientation) && canGenerate(x,y,element.orientation) then pushRow(x,y,element.orientation)
          if ! touchesImmobile(x,y,element.orientation) then generate(x,y,element.orientation)

        } // if inbounds check of er op de generated side iets staat, if so check of er plaats is in de rij om iets te zetten; hele rij gets pushed + insert
        case 5 => if !touchesImmobile(x,y,element.orientation) then pushRow(x,y,element.orientation) // als de pushable side ni de rand is en er plaats is in de rij om te duwen, duw dan de hele rij die de cel raakt 1 in de duwrichting
        case 6 => spinNeighbours(x,y,element.RotateDirection) // spin alle spinnable cellen in de direction van de spinner
        case _ => wasntPushed.insert(x,y,false)
      //---------------------------------------------------------------------------
      
    }
  }
  def iteration(): Unit ={ // iteratie van het spel
    feld2.copyField(feld)
    wasntPushed.fillField()
    for i <- 1 to Xelements - 2 do {
      for j <- 1 to Yelements - 2 do {
        checkSurrounding(i,j)
      }
    }
    feld.copyField(feld2)
  }


}
