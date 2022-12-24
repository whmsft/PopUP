
import "dome" for Window
import "random" for Random
import "input" for Keyboard, Mouse
import "graphics" for Canvas, Color, Font
import "io" for FileSystem

// Window.fullscreen = true

var VERSION = "0.5.8" // changes every update
var SCORE = 0
var GAME = "boot" // modes: boot, play, over
var DATA = ""
var HIGHSCORE = 0

if (FileSystem.listFiles("./").contains(".data")) {
  DATA = FileSystem.load(".data")
  HIGHSCORE = Num.fromString(DATA[1..4])
} else {
  FileSystem.save(".data", "|0000|")
  DATA = FileSystem.load(".data")
  HIGHSCORE = Num.fromString(DATA[1..4])
}

/*
  [DIALOGS] map contains the pop-up's "data"
  width -> width of dialog
  height -> height of dialog
  title -> the heading/title of the dialog box
  body -> contents in the dialog
*/
var DIALOGS = {
  0: {
    "width": 240*4.25,
    "height": 160*4,
    "title": "LUCKY!.exe",
    "body": "You've WON\n$10000!"
  },
  1: {
    "width": 240*4.25,
    "height": 160*4,
    "title": "DRIVERZ.exe",
    "body": "Install the new\ndriver!"
  },
  2: {
    "width": 280*4.25,
    "height": 160*4,
    "title": "UNREGISTERED",
    "body": "Please register this\nproduct!"
  },
  3: {
    "width": 280*4.25,
    "height": 160*4,
    "title": "SALE!!!",
    "body": "FREE xPhones and\nxPads for just $5!!"
  },
  4: {
    "width": 280*4.25,
    "height": 160*4,
    "title": "Antivirus",
    "body": "Popup.wren detected\nplease delete it."
  },
  5: {
    "width": 300*4.25,
    "height" : 160*4,
    "title": "FREE Trip!",
    "body": "Get a FREE trip to Bazil!\n >>> CLAIM NOW!! <<<"
  }
}

class Dialog {
  finish {_finish}
  type {_type}
  x {_x}
  y {_y}
  w {_w}
  h {_h}
  scrollX {_scrollX}
  scrollY {_scrollY}
  lastx {_lastx}
  lasty {_lasty}
  random {_rand}
  
  roundrectfill(x, y, w, h, r, c) {
    Canvas.circlefill(x+r, y+r, r-1, c)
    Canvas.circlefill(x+r, y+h-r, r-1, c)
    Canvas.circlefill(x+w-r, y+r, r-1, c)
    Canvas.circlefill(x+w-r, y+h-r, r-1, c)
    Canvas.rectfill(x+r, y, w-r-r, h, c)
    Canvas.rectfill(x, y+r, w, h-r-r, c)
  }
  
  construct new() {
    _finish = false
    _scrollX = 0
    _scrollY = 0
    _lastx = Mouse.x
    _lasty = Mouse.y
    _rand = Random.new()
    _type = random.int(DIALOGS.count)
    _w = DIALOGS[type]["width"]
    _h = DIALOGS[type]["height"]
    _x = random.int(4096-1000)
    _y = random.int(2160-500)
  }
  update() {
    _scrollX = _lastx - Mouse.x // four variables,
    _scrollY = _lasty - Mouse.y // containing data
    _lastx = Mouse.x            // for scrolling
    _lasty = Mouse.y            // the popup
    
    // check for click on the right spot
    if ((((Mouse.x > _x+_w-12*5*4.25) && (Mouse.x < _x+_w)) && ((Mouse.y < _y+8*5*4) && (Mouse.y > _y))) && (Mouse.isButtonPressed("left"))) {
      _finish = true
      SCORE = SCORE + 1
    }
    // check for scrolling
    if (((Mouse.x > _x && Mouse.x < _x+_w) && (Mouse.y > _y && Mouse.y < _y+_h)) && (Mouse.isButtonPressed("left"))) {
      _x = _x - _scrollX
      _y = _y - _scrollY
    }
  }
  draw() {
    if (finish == false) {
      roundrectfill(_x, _y, _w, _h, 50, Color.white)
      Canvas.rectfill(_x+_w-12*5*4.25, _y, 12*5*4.25,8*5*4, Color.hex("f00"))
      Canvas.line(_x+_w-10*5*4.25, y+2*5*4, _x+w-2*5*4.25, y+6*5*4, Color.white, 2*4.25)
      Canvas.line(_x+_w-2*5*4.25, y+2*5*4, _x+w-10*5*4.25, y+6*5*4, Color.white, 2*4.25)
      // Canvas.rect(_x-1,_y-1, _w+1, _h+1, Color.black)
      Font["OpenSans"].print(DIALOGS[type]["title"],_x+5*4.25, _y+1*4.25, Color.black)
      Font["OpenSans"].print(DIALOGS[type]["body"], _x+5*4.25, _y+40*4.25, Color.black)
    }
  }
}

class main {
  construct new() {}
  num2str(num) {
    _newnum = num.toString
    return ("0"*(4-_newnum.count))+_newnum
  }
  init() {
    // Mouse.hidden = true
    _varpostmp = 0
    _popups = []
    _rand = Random.new()
    _wait = _rand.float(0.25, 1.25)
    _tick = 0
    _scale = 0.3
    Canvas.resize(4096, 2160)
    Window.resize(_scale * Canvas.width, _scale * Canvas.height)
    Window.title = "PopUp "+VERSION
    Font.load("OpenSans_S", "./OpenSans.ttf", 20*4.25)
    Font.load("OpenSans", "./OpenSans.ttf", 25*4.25)
    Font.load("OpenSans_XL", "./OpenSans.ttf", 50*4.25)
    Font.load("OpenSans_XXL", "./OpenSans.ttf", 80*4.25)
    Font.load("OpenSans_XXXL", "./OpenSans.ttf", 300*4.25)
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
      if ((_popups.count >= 15) || (Keyboard.isKeyDown("up"))) {
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
        Font["OpenSans_XXL"].print("MEMORY FULL", 202*4.25, 202*4, Color.hex("fff"))
        Font["OpenSans_XXL"].print("MEMORY FULL", 200*4.25, 200*4, Color.hex("f22"))
      }
      Font["OpenSans_XL"].print("Score: "+SCORE.toString, 7*4.25, -13*4, Color.black)
      Font["OpenSans_XL"].print("Score: "+SCORE.toString, 5*4.25, -15*4, Color.white)
	  //Canvas.rectfill(0, 2160-50, 4096, 50, Color.lightgray)
	} else if (GAME == "over") {
    if (HIGHSCORE < SCORE) {
      HIGHSCORE = SCORE
      FileSystem.save(".data", "|"+num2str(HIGHSCORE)+"|")
    }
		Font["OpenSans_XXXL"].print(":(", 10*4.25, -125*4, Color.white)
  	Font["OpenSans_XXL"].print("PopUp "+VERSION, 200*4.25, 90*4, Color.white)
		Font["OpenSans"].print("Your PC ran into a problem and needs to restart\nWe're just collecting some error info, then\nplease throw this PC into the bin.\nAlternatively, you shall hit <RETURN> again.", 10*4.25, 305*4, Color.white)
		Font["OpenSans_S"].print("If you would like to learn more then don't search online\nblue_screen_of_death_in_whmsft_popup_err_101", 10*4.25, 475*4, Color.white)
		SCORE = 0
	} else if (GAME == "boot") {
      Canvas.cls(Color.hex("000"))
      Font["OpenSans"].print("HIGHSCORE:"+HIGHSCORE.toString, 10*4.25, 500*4, Color.white)
      Font["OpenSans_XXXL"].print(":)", 10*4.25, -125*4, Color.white)
      Font["OpenSans_XXL"].print("PopUp "+VERSION, 200*4.25, 90*4, Color.white)
      Font["OpenSans"].print("Hit <RETURN> to spark it up!", 10*4.25, 300*4, Color.white)
    }
  }
}

var Game = main.new()
