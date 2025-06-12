package gridLogic

import org.scalatest.flatspec.AnyFlatSpec

class fieldTest extends AnyFlatSpec{
  var feld = field[Int](5,5,0)
  var element = feld.get(2,3)
  var element2 = feld.get(2,3)
  var bool = feld.insideField(7,2)
  feld.fillField()
  "element" should "equal 0" in {
    assert(element == 0)
  }
  "element" should "equal 2" in{
    feld.insert(2,3,2)
    element = feld.get(2,3)
    assert(element == 2)
  }
  "element2" should "equal 0" in {
    feld.remove(2,3)
    element2 = feld.get(2,3)
    assert(element2 == 0)
  }
  "element2" should "equal 3" in {
    feld.insert(1,3, 3)
    element2 = feld.elementAbove(2,3)
    assert(element2 == 0)
  }
  "bool" should "equal false" in {
    assert(bool == false)
  }
  "bool" should "equal true" in {
    bool = feld.insideField(2,3)
    assert(bool == true)
  }
}
