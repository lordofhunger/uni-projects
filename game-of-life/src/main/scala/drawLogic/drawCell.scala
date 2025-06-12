package drawLogic

import cellLogic.{MainCell, emptyCell, enemyCell, generatorCell, pushCell, pushableCell, turnCell, sliderCell, unpushableBlock, unturnableCell,uiCell}
import mygame.{AssetsLoader, Cell, GridPanel}
import gridLogic.Grid
import java.awt.{Graphics2D, Image}
import collection.JavaConverters.asJavaIterableConverter

class drawCell(x: Int, y:Int ,cell:MainCell, padding:Int, elementSize:Int) extends Cell{ // geef elke specifieke cel zijn juiste png
  // cellTypeID
  var pngName: String = "empty-cell.png"
  cell match 
    case cell:emptyCell => pngName = "background.png"
    case cell:enemyCell => pngName = "enemy.png"
    case cell:generatorCell => {  if cell.orientation == 'U' then {
                                    pngName = "generator1.png"
                                  }else if cell.orientation == 'R' then {
                                    pngName = "generator.png"
                                  }else if cell.orientation == 'D' then {
                                    pngName = "generator3.png"
                                  }else if cell.orientation == 'L' then {
                                    pngName = "generator4.png"
                                  }
                              }
    case cell:pushableCell => pngName = "push.png"

    case cell:pushCell =>   { if cell.orientation == 'U' then {
                                pngName = "mover1.png"
                              } else if cell.orientation == 'R' then {
                                pngName = "mover2.png"
                              } else if cell.orientation == 'D' then {
                                pngName = "mover3.png"
                              } else if cell.orientation == 'L' then {
                                pngName = "mover4.png"
                              }
                            }
    case cell:sliderCell => { if cell.orientation == 'U' || cell.orientation == 'D' then {
                                pngName = "slide2.png"
                              } else if cell.orientation == 'R' || cell.orientation == 'L' then {
                                pngName = "slide.png"
                              }
                            }
    case cell:turnCell => pngName = "spinner.png"
    case cell:unpushableBlock => pngName = "immobile.png"
    case cell:unturnableCell => pngName = "unspinnable.png"
    case cell:uiCell =>   { if cell.orientation == 'U' then {
                              pngName = "pixel-border.png"
                            } else if cell.orientation == 'R' then {
                              pngName = "play.png"
                            } else if cell.orientation == 'D' then {
                              pngName = "step.png"
                            } else if cell.orientation == 'L' then {
                              pngName = "field.png"
                            }
    }
    case _ => pngName = "empty-cell.png"

  override def draw(g: Graphics2D): Unit = // teken de png
    var image: Image = AssetsLoader.loadImage(pngName)
    g.drawImage(image,(x - 1)*elementSize + padding, (y - 1)*elementSize + padding,elementSize,elementSize,null)
    

}
