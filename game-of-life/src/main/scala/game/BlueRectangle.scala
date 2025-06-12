package game

import java.awt.Graphics2D
import java.awt.Rectangle
import java.awt.Color

import mygame.Cell

/** Dit is maar een voorbeeld van hoe je dingen kan tekenen op het scherm
  */
class BlueRectangle extends Cell {
  override def draw(g: Graphics2D): Unit =
    val r = Rectangle(0, 0, 1040, 540)
    g.setPaint(Color.DARK_GRAY)
    g.fill(r)
    g.setPaint(Color.BLACK)
    g.draw(r)
}
