package gridLogic

import org.scalatest.flatspec.AnyFlatSpec

class GridTest extends AnyFlatSpec{
  var gridtest = Grid(5,5)
  var Xelements = gridtest.getXelements()
  var Yelements = gridtest.getYelements()
  var coord = 2*gridtest.elementSize + gridtest.padding
  "Xelements" should "equal 5" in {
    assert(Xelements == 5)
  }
  "Yelements" should "equal 5" in {
    assert(Yelements == 5)
  }
  "coord" should "equal 2" in{
    coord = gridtest.convertToCoord(coord)
    assert(coord == 2)
  }
}
