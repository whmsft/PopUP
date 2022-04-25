import "dome" for Window
import "random" for Random
import "input" for Keyboard, Mouse
import "graphics" for Canvas, Color

var GAME = false

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
    if ((((Mouse.x > _x+_w-12) && (Mouse.x < _x+_w)) && ((Mouse.y < _y+8) && (Mouse.y > _y))) && (Mouse.isButtonPressed("left"))) {
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
      Canvas.rectfill(_x+_w-12, _y, 12,8, Color.hex("f00"))
      Canvas.line(_x+_w-10,y+2, _x+w-3, y+5, Color.white)
      Canvas.line(_x+_w-3,y+2, _x+w-10, y+5, Color.white)
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
    if (GAME) {
      _tick = _tick+1
      if (_tick >= 60 * _wait) {
        _popups.add(Dialog.new())
        _tick = 0
        _wait = _rand.float(0.5, 1.5)
      }
      _popups.each { |pop|
        pop.update()
        if (pop.finish == true) {
          _popups.removeAt(_varpostmp)
        }
        _varpostmp = _varpostmp + 1
      }
      _varpostmp = 0
    } else {
      if (Keyboard.isKeyDown("return")) {
        GAME = true
      }
    }
  }
  draw(alpha) {
    if (GAME) {
      Canvas.cls()
      Canvas.print(_popups.count, 5, 5, Color.white)
      _popups.each{ |pop|
        pop.draw()
      }
    } else {
      Canvas.print("hit <RETURN> to begin", 5, 5, Color.white)
    }
  }
}

var Game = main.new()
