package cellLogic

abstract class MainCell {
  val turnable: Boolean = true                    // is de cel draaibaar
  val movable:  Boolean = true                   // is de cel beweegbaar, nodig voor niet de enemies en unpushableblocks te kunnen verslepen 
  val cellTypeID: Int = 0                       // de manier waarop ik cellen kan identificeren
  var orientation: Char = 'R'                  // 'R'ight - 'L'eft - 'U'p - 'D'own
  var RotateDirection: String = "Clockwise"   // "Clockwise" or "Counter-clockwise"

  def turnTheCell(RotateDirection: String) = { // pas de orientation aan van de cel
    if turnable then {
      RotateDirection match
        case "Clockwise" => orientation match
          case 'R' => orientation = 'D'
          case 'D' => orientation = 'L'
          case 'L' => orientation = 'U'
          case 'U' => orientation = 'R'

        case "Counter-clockwise" => orientation match
          case 'R' => orientation = 'U'
          case 'U' => orientation = 'L'
          case 'L' => orientation = 'D'
          case 'D' => orientation = 'R'
    }
  }
  
  def mirrorRotating() = { // spiegel de draairichting - alleen nuttig in de turncell
    RotateDirection match {
      case "Clockwise" => RotateDirection = "Counter-clockwise"
      case "Counter-clockwise" => RotateDirection = "Clockwise"
    }
  }



}
