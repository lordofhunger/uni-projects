package cellLogic
import cellLogic.{MainCell,Unmovable,Unpushable,Unturnable}

class unturnableCell extends MainCell, Unturnable {
  override val cellTypeID = 8
  
}
