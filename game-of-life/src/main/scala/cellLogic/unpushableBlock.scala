package cellLogic
import cellLogic.{MainCell,Unmovable,Unpushable,Unturnable}

class unpushableBlock extends MainCell, Unpushable {
  override val cellTypeID = 7
}
