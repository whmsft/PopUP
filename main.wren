import "dome" for Window
import "random" for Random
import "input" for Keyboard, Mouse
import "graphics" for Canvas, Color, Font
import "io" for FileSystem

var VERSION = "0.1.5"
var SCORE = 0
var GAME = "boot" // modes: boot, play, over

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
    _w = 240
    _h = 160
    _rand = Random.new()
    _x = random.int(960-20)
    _y = random.int(544-20)
  }
  update() {
    _scrollX = _lastx - Mouse.x
    _scrollY = _lasty - Mouse.y
    _lastx = Mouse.x
    _lasty = Mouse.y
    if ((((Mouse.x > _x+_w-12*5) && (Mouse.x < _x+_w)) && ((Mouse.y < _y+8*5) && (Mouse.y > _y))) && (Mouse.isButtonPressed("left"))) {
      _finish = true
      SCORE = SCORE + 1
    }
    if (((Mouse.x > _x && Mouse.x < _x+_w) && (Mouse.y > _y && Mouse.y < _y+_h)) && (Mouse.isButtonPressed("left"))) {
      _x = _x - _scrollX
      _y = _y - _scrollY
    }
  }
  draw() {
    if (finish == false) {
      Canvas.rectfill(_x, _y, _w, _h, Color.white)
      Canvas.rectfill(_x+_w-12*5, _y, 12*5,8*5, Color.hex("f00"))
      Canvas.line(_x+_w-10*5, y+2*5, _x+w-2*5, y+6*5, Color.white, 2)
      Canvas.line(_x+_w-2*5, y+2*5, _x+w-10*5, y+6*5, Color.white, 2)
      Font["OpenSans"].print("PopUp",_x+5, _y+1, Color.black)
    }
  }
}

class main {
  construct new() {}
  init() {
    _varpostmp = 0
    _popups = []
    _rand = Random.new()
    _wait = _rand.float(0.25, 1.25)
    _tick = 0
    _scale = 1
    Canvas.resize(960, 544)
    Window.resize(_scale * Canvas.width, _scale * Canvas.height)
    Window.title = "Pop-Up d1"
    Font.load("OpenSans", "./OpenSans.ttf", 25)
    Font.load("OpenSans_XL", "./OpenSans.ttf", 50)
    Font.load("OpenSans_XXL", "./OpenSans.ttf", 80)
    Font.load("OpenSans_XXXL", "./OpenSans.ttf", 300)
  }
  update() {
    if (GAME == "play") {
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
      if (_popups.count >= 15) {
        GAME = "over"
        _popups = []
        Canvas.cls()
      }
    } else {
      if (Keyboard.isKeyDown("return")) {
        GAME = "play"
      }
    }
  }
  draw(alpha) {
    Canvas.cls(Color.hex("0084ff"))
    if (GAME == "play") {
      _popups.each{ |pop|
        pop.draw()
      }
      if (_popups.count >= 10) {
        Font["OpenSans_XXL"].print("MEMORY FULL", 252, 282, Color.hex("fff"))
        Font["OpenSans_XXL"].print("MEMORY FULL", 250, 280, Color.hex("f22"))
      }
      Font["OpenSans_XL"].print("Score: "+SCORE.toString, 5, -15, Color.white)
	} else if (GAME == "over") {
		Font["OpenSans_XXXL"].print(":(", 10, -125, Color.white)
		Font["OpenSans_XXL"].print("PopUp "+VERSION, 200, 90, Color.white)
	} else if (GAME == "boot") {
      Canvas.cls(Color.hex("000"))
      Font["OpenSans"].print("hit <RETURN> to begin", 5, 10, Color.white)
      Font["OpenSans"].print("HOW-TO\n  Close Popups\n  when popups are +10:\n    MEMORY FULL\n  when popups are 15:\n    GAME OVER", 5, 55, Color.white)
    }
  }
}

var Game = main.new()
