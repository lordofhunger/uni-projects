package cellLogic

import org.scalatest.flatspec.AnyFlatSpec

class cellTest extends AnyFlatSpec {
  var voorbeeldCel:MainCell = enemyCell()
  var voorbeelCel2:MainCell = unturnableCell()
  var orientation = voorbeeldCel.orientation
  var orientation2 = voorbeeldCel.orientation
  var cellTypeID = voorbeeldCel.cellTypeID
  var turnable1 = voorbeeldCel.turnable
  var turnable2 = voorbeelCel2.turnable
  "orientation" should "equal 'R'" in {
    assert(orientation == 'R')
  }

  "orientation" should "equal 'D'" in {
    voorbeeldCel.turnTheCell("Clockwise")
    orientation = voorbeeldCel.orientation
    assert(orientation == 'D')
  }

  "orientation" should "equal 'L'" in {
    voorbeeldCel.turnTheCell("Clockwise")
    orientation = voorbeeldCel.orientation
    assert(orientation == 'L')
  }

  "orientation" should "equal 'U'" in {
    voorbeeldCel.turnTheCell("Clockwise")
    orientation = voorbeeldCel.orientation
    assert(orientation == 'U')
  }
  "orientation2" should "equal 'L'" in {
    voorbeeldCel.turnTheCell("Counter-clockwise")
    orientation2 = voorbeeldCel.orientation
    assert(orientation2 == 'L')
  }
  "orientation2" should "equal 'D'" in {
    voorbeeldCel.turnTheCell("Counter-clockwise")
    orientation2 = voorbeeldCel.orientation
    assert(orientation2 == 'D')
  }
  "orientation2" should "equal 'R'" in {
    voorbeeldCel.turnTheCell("Counter-clockwise")
    orientation2 = voorbeeldCel.orientation
    assert(orientation2 == 'R')
  }
  "cellTypeID" should "equal 2" in {
    assert(cellTypeID == 2)
  }
  "turnable1" should "equal true" in{
    assert(turnable1 == true)
  }
  "turnable2" should "equal false" in{
    assert(turnable2 == false)
  }
}
