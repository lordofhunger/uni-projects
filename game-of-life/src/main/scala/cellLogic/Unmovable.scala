package cellLogic

trait Unmovable extends MainCell {
  override val movable: Boolean = false
}
