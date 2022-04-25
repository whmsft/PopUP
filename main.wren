import "dome" for Window
import "random" for Random
import "input" for Keyboard, Mouse
import "graphics" for Canvas, Color

class Dialog {
  finish {_finish}
  x {_x}
  y {_y}
  w {_w}
  h {_h}
  scrollX {_scrollX}
  scrollY {_scrollY}
  lastx {_lastx}
  lasty {_lasty}
  random {_rand}
  construct new() {
    _finish = false
    _scrollX = 0
    _scrollY = 0
    _lastx = Mouse.x
    _lasty = Mouse.y
    _w = 60
    _h = 40
    _rand = Random.new()
    _x = random.int(180)
    _y = random.int(94)
  }
  update() {
    _scrollX = _lastx - Mouse.x
    _scrollY = _lasty - Mouse.y
    _lastx = Mouse.x
    _lasty = Mouse.y
    // (Canvas.pget(Mouse.x, Mouse.y) == Color.red)
    if ((((Mouse.x > _x+_w-6) && (Mouse.x < _x+_w-2)) && ((Mouse.y < _y+6) && (Mouse.y > _y+2))) && (Mouse.isButtonPressed("left"))) {
      _finish = true
    }
    if (((Mouse.x > _x && Mouse.x < _x+_w) && (Mouse.y > _y && Mouse.y < _y+_h)) && (Mouse.isButtonPressed("left"))) {
      _x = _x - _scrollX
      _y = _y - _scrollY
    }
  }
  draw() {
    if (finish == false) {
      Canvas.rectfill(_x, _y, _w, _h, Color.white)
      Canvas.rect(_x+-1, _y-1, _w+2, _h+2, Color.black)
      Canvas.circlefill(_x+_w-4, _y+3, 2, Color.red)
    }
  }
}

class main {
  construct new() {}
  init() {
    _varpostmp = 0
    _popups = []
    _rand = Random.new()
    _wait = _rand.float(0.4, 1.5)
    _tick = 0
    _scale = 4
    Canvas.resize(240, 136)
    Window.resize(_scale * Canvas.width, _scale * Canvas.height)
    Window.title = "PopUP - wren"
  }
  update() {
    _tick = _tick+1
    if (_tick >= 60 * _wait) {
      _popups.add(Dialog.new())
      _tick = 0
      _wait = _rand.float(0.1, 1.5)
    }
    _popups.each { |pop|
      pop.update()
      if (pop.finish == true) {
        _popups.removeAt(_varpostmp)
      }
      _varpostmp = _varpostmp + 1
    }
    _varpostmp = 0
  }
  draw(alpha) {
    Canvas.cls()
    Canvas.print(_popups.count, 5, 5, Color.white)
    _popups.each{ |pop|
      pop.draw()
    }
  }
}

var Game = main.new()
