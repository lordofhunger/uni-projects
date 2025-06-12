package cellLogic
import cellLogic.{MainCell,Unmovable,Unpushable,Unturnable}

class enemyCell extends MainCell, Unmovable, Unpushable {
  override val cellTypeID = 2
}
