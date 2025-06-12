package game

import collection.JavaConverters.asJavaIterableConverter
import mygame.GUI
import gridLogic.Grid
import drawLogic.drawCell
import cellLogic.enemyCell
import cellLogic.{MainCell, pushableCell, emptyCell, enemyCell, generatorCell, pushCell, turnCell, unpushableBlock, unturnableCell, uiCell}


object Game:
  @main def run(): Unit =
    val gui = Grid(20, 10) // aanmaken van ons grid
    val grid = gui.grid

    var selection: Boolean = false              // bijhouden of er iets geselecteerd is
    var started: Boolean = false               // zien of we op de play knop gedrukt hebben
    var step: Boolean = false                 // hebben we een stap gezet
    var selectedCell: MainCell = emptyCell() // welke cel hebben we geselecteerd
    //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++//
    def inBounds(x: Int, y: Int): Boolean ={ // zijn deze coordinaten binnen het veld
      x >= 20 & y >= 20 & x < (20 * 50) + 20 & y < (10 * 50) + 20
    }
    //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++//
    def notFinished():Boolean = { // zijn er nog enemyCells
      if gui.fieldHasCell(enemyCell()) then true else false
    }
    //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++//
    def drawGUI(): Unit ={ // teken de gui - speelknop, stapknop, achtergrond en pixel-border cells voor de knoppen die het spel starten
      var playCell:uiCell = uiCell()
      var stepCell:uiCell = uiCell()
      var backgroundCell:uiCell = uiCell()
      var maskCell:uiCell = uiCell()
      stepCell.turnTheCell("Clockwise")
      backgroundCell.turnTheCell("Clockwise")
      backgroundCell.turnTheCell("Clockwise")
      maskCell.turnTheCell("Counter-clockwise")

      grid.addCells(List(drawCell(2,11,backgroundCell,gui.padding, gui.elementSize)).asJava)
      grid.addCells(List(drawCell(2,11,playCell,gui.padding, gui.elementSize)).asJava)
      grid.addCells(List(drawCell(3,11,backgroundCell,gui.padding, gui.elementSize)).asJava)
      grid.addCells(List(drawCell(3,11,stepCell,gui.padding, gui.elementSize)).asJava)
    }
    //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++//
    def tekenLoop() = { //teken het gehele veld, ga via een dubbele for over elk element en teken het element
      for i <- 0 to (gui.getXelements() - 1) do {
        for j <- 0 to (gui.getYelements() - 1) do {
          var cell: MainCell = gui.feld.get(i, j)
            drawCell(i, j, cell,gui.padding, gui.elementSize)
            grid.addCells(List(drawCell(i + 1,j + 1,cell,gui.padding, gui.elementSize)).asJava)
        }
      }
      drawGUI()
    }
    while notFinished() do { // als er nog enemies zijn gaan we gewoon tekenen en de klik en beweegfuncties normaal laten

      if started || step then {
        grid.clear()
        gui.iteration()
        step = false
      }

      grid.setPressListener((x: Int, y: Int) => {
        if inBounds(x, y) then {

          selection = !selection // als er geklikt wordt is een cel oftewel geselecteerd of gedeselecteerd

          grid.clear()

          if !selection & !(selectedCell == null || selectedCell.cellTypeID == 1 || selectedCell.movable == false) then {
            // stel selectie is false wilt dit zeggen dat we de geselecteerde cel gaan plaatsen op de plaats waar net geklikt is
            gui.insert(gui.convertToCoord(x), gui.convertToCoord(y), selectedCell)
          }

          selectedCell = gui.getCell(gui.convertToCoord(x), gui.convertToCoord(y))

          if selection & !(selectedCell == null || selectedCell.cellTypeID == 1 || selectedCell.movable == false) then {
            // stel selectie is waar dan hebben we net een cel geselecteerd verwijderen we de lege cel die we verplaatsen
            gui.remove(gui.convertToCoord(x), gui.convertToCoord(y))
          }

        } else if gui.convertToCoord(x) == 2 then{
          step = true

        } else if gui.convertToCoord(x) == 1 then{
          started = true
        }
        tekenLoop()
      })
      
      grid.setMoveListener((x: Int, y: Int) => {
        if inBounds(x, y) then {
          if selection & !(selectedCell == null || selectedCell.cellTypeID == 1 || selectedCell.movable == false) & (gui.getCell(gui.convertToCoord(x), gui.convertToCoord(y)) == null || gui.getCell(gui.convertToCoord(x), gui.convertToCoord(y)).cellTypeID == 1) then {

            gui.insert(gui.convertToCoord(x), gui.convertToCoord(y), selectedCell)
            // Maak het grid leeg nadat je hebt geklikt

            grid.clear()
            tekenLoop()
            gui.remove(gui.convertToCoord(x), gui.convertToCoord(y))
          }
        }
      })
      tekenLoop()
      Thread.sleep(1000) // zonder de sleep is het spel direct gedaan omdat de while extreem snel loopt


    }
    grid.setPressListener((x: Int, y: Int) => { // als alle enemies weg zijn moeten we geen cellen meer verplaatsen dus zet ik deze functionaliteit uit
      println("All enemies are defeated.")
    })

    grid.setMoveListener((x: Int, y: Int) => { // als ik hier een println zou zetten zoals bij de presslistener zou dit constant printen
      if false then println("")
    })



    grid.repaint()
