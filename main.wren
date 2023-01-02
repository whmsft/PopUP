import "dome" for Window
import "random" for Random
import "input" for Keyboard, Mouse
import "graphics" for Canvas, Color, Font, ImageData
import "io" for FileSystem

Window.fullscreen = true

var VERSION = "0.6.4" // changes every update
var SCORE = 0
var MODE = "desktop" // modes: boot, desktop, play, over
var DATA = ""
var HIGHSCORE = 0
var SCALE = 5

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
    "width": 1020/SCALE,
    "height": 640/SCALE,
    "title": "LUCKY!.exe",
    "body": "You've WON\n$10000!"
  },
  1: {
    "width": 1020/SCALE,
    "height": 640/SCALE,
    "title": "DRIVERZ.exe",
    "body": "Install the new\ndriver!"
  },
  2: {
    "width": 1190/SCALE,
    "height": 640/SCALE,
    "title": "UNREGISTERED",
    "body": "Please register this\nproduct!"
  },
  3: {
    "width": 1190/SCALE,
    "height": 640/SCALE,
    "title": "SALE!!!",
    "body": "FREE xPhones and\nxPads for just $5!!"
  },
  4: {
    "width": 1190/SCALE,
    "height": 640/SCALE,
    "title": "Antivirus",
    "body": "Popup.wren detected\nplease delete it."
  },
  5: {
    "width": 1275/SCALE,
    "height" : 640/SCALE,
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
    _x = random.int(4096/SCALE-1000/SCALE)
    _y = random.int(2160/SCALE-500/SCALE)
  }
  update() {
    _scrollX = _lastx - Mouse.x // four variables,
    _scrollY = _lasty - Mouse.y // containing data
    _lastx = Mouse.x            // for scrolling
    _lasty = Mouse.y            // the popup
    
    // check for click on the right spot
    if ((((Mouse.x > _x+_w-255/SCALE) && (Mouse.x < _x+_w)) && ((Mouse.y < _y+160/SCALE) && (Mouse.y > _y))) && (Mouse.isButtonPressed("left"))) {
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
      roundrectfill(_x, _y, _w, _h, 50/SCALE, Color.white)
      Canvas.rectfill(_x+_w-255/SCALE, _y, 255/SCALE, 160/SCALE, Color.hex("f00"))
      Canvas.line(_x+_w-212.5/SCALE, y+40/SCALE, _x+w-42.5/SCALE, y+120/SCALE, Color.white, 8.5/SCALE)
      Canvas.line(_x+_w-42.5/SCALE, y+40/SCALE, _x+w-212.5/SCALE, y+120/SCALE, Color.white, 8.5/SCALE)
      // Canvas.rect(_x-1,_y-1, _w+1, _h+1, Color.black)
      Font["OpenSans"].print(DIALOGS[type]["title"],_x+21.25/SCALE, _y+4.25/SCALE, Color.black)
      Font["OpenSans"].print(DIALOGS[type]["body"], _x+21.25/SCALE, _y+170/SCALE, Color.black)
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
    Mouse.hidden = false
    _varpostmp = 0
    _popups = []
    _rand = Random.new()
    _wait = _rand.float(0.25, 1.25)
    _tick = 0
    _scale = 0.3
    Canvas.resize(4096/SCALE, 2160/SCALE)
    Window.resize(_scale * Canvas.width, _scale * Canvas.height)
    Window.title = "PopUp "+VERSION
    Font.load("OpenSans_S", "./OpenSans.ttf", 85/SCALE)
    Font.load("OpenSans", "./OpenSans.ttf", 106.25/SCALE)
    Font.load("OpenSans_XL", "./OpenSans.ttf", 212.5/SCALE)
    Font.load("OpenSans_XXL", "./OpenSans.ttf", 340/SCALE)
    Font.load("OpenSans_XXXL", "./OpenSans.ttf", 1275/SCALE)
  }
  update() {
    if (MODE == "play") {
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
        MODE = "over"
        _popups = []
        Canvas.cls()
      }
    } else {
      if (Keyboard.isKeyDown("return")) {
        MODE = "play"
      }
    }
  }
  draw(alpha) {
    Canvas.cls(Color.hex("0084ff"))
	if (MODE == "desktop") {
		ImageData.loadFromFile("./resc/about.png").transform({"scaleX":2/SCALE, "scaleY":2/SCALE}).draw(25/SCALE, 25/SCALE)
		Canvas.rectfill(0, 2160/SCALE-(150/SCALE), 4096/SCALE, 150/SCALE, Color.blue)
	}
    if (MODE == "play") {
      _popups.each{ |pop|
        pop.draw()
      }
      if (_popups.count >= 10) {
        Font["OpenSans_XXL"].print("MEMORY FULL", 858.5/SCALE, 808/SCALE, Color.hex("fff"))
        Font["OpenSans_XXL"].print("MEMORY FULL", 850/SCALE, 800/SCALE, Color.hex("f22"))
      }
      Font["OpenSans_XL"].print("Score: "+SCORE.toString, 29.75/SCALE, -52/SCALE, Color.black)
      Font["OpenSans_XL"].print("Score: "+SCORE.toString, 21.25/SCALE, -60/SCALE, Color.white)
	} else if (MODE == "over") {
    if (HIGHSCORE < SCORE) {
      HIGHSCORE = SCORE
      FileSystem.save(".data", "|"+num2str(HIGHSCORE)+"|")
    }
		Font["OpenSans_XXXL"].print(":(", 42.5/SCALE, -500/SCALE, Color.white)
  	Font["OpenSans_XXL"].print("PopUp "+VERSION, 850/SCALE, 360/SCALE, Color.white)
		Font["OpenSans"].print("Your PC ran into a problem and needs to restart\nWe're just collecting some error info, then\nplease throw this PC into the bin.\nAlternatively, you shall hit <RETURN> again.", 42.5/SCALE, 1220/SCALE, Color.white)
		Font["OpenSans_S"].print("If you would like to learn more then don't search online\nblue_screen_of_death_in_whmsft_popup_err_101", 42.5/SCALE, 475*4/SCALE, Color.white)
		SCORE = 0
	} else if (MODE == "boot") {
      Canvas.cls(Color.hex("000"))
      Font["OpenSans"].print("HIGHSCORE:"+HIGHSCORE.toString, 42.5/SCALE, 2000/SCALE, Color.white)
      Font["OpenSans_XXXL"].print(":)", 42.5/SCALE, -500/SCALE, Color.white)
      Font["OpenSans_XXL"].print("PopUp "+VERSION, 850/SCALE, 360/SCALE, Color.white)
      Font["OpenSans"].print("Hit <RETURN> to spark it up!", 42.5/SCALE, 1200/SCALE, Color.white)
    }

	// ImageData.loadFromFile("./resc/cursor.png").draw(Mouse.x, Mouse.y)
	
  }
}

var Game = main.new()
