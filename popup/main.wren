import "dome" for Window
import "random" for Random
import "input" for Keyboard, Mouse
import "graphics" for Canvas, Color, Font
import "io" for FileSystem

var VERSION = "0.5.5" // changes every update
var SCORE = 0
var MODE = "boot" // modes: boot, play, over
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
  dialogs map contains the pop-up's "data"
  width -> width of dialog
  height -> height of dialog
  title -> the heading/title of the dialog box
  body -> contents in the dialog
*/
var DIALOGS = {
  0: {
    "width": 240,
    "height": 160,
    "title": "LUCKY!.exe",
    "body": "You've WON\n$10000!"
  },
  1: {
    "width": 240,
    "height": 160,
    "title": "DRIVERZ.exe",
    "body": "Install the new\ndriver!"
  },
  2: {
    "width": 280,
    "height": 160,
    "title": "UNREGISTERED",
    "body": "Please register this\nproduct!"
  },
  3: {
    "width": 280,
    "height": 160,
    "title": "SALE!!!",
    "body": "FREE xPhones and\nxPads for just $5!!"
  },
  4: {
    "width":240,
    "height": 160,
    "title": "Antivirus",
    "body": "Popup.exe detected\nplease delete it."
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
    _x = random.int(Canvas.width-w)
    _y = random.int(Canvas.height-w)
  }
  position(newX, newY) {
    _x=newX
    _y=newY
  }
  update() {
    _scrollX = _lastx - Mouse.x // four variables,
    _scrollY = _lasty - Mouse.y // containing data
    _lastx = Mouse.x            // for scrolling
    _lasty = Mouse.y            // the popup
    
    // check for click on the right spot
    if ((((Mouse.x > _x+_w-12*5) && (Mouse.x < _x+_w)) && ((Mouse.y < _y+8*5) && (Mouse.y > _y))) && (Mouse.isButtonPressed("left"))) {
      _finish = true
      SCORE = SCORE + 1
    }
    // check for scrolling
    //if (((Mouse.x > _x && Mouse.x < _x+_w) && (Mouse.y > _y && Mouse.y < _y+_h)) && (Mouse.isButtonPressed("left"))) {
    //  _x = _x - _scrollX
    //  _y = _y - _scrollY
    //}
  }
  draw() {
    if (finish == false) {
      Canvas.rectfill(_x, _y, _w, _h, Color.white)
      Canvas.rectfill(_x+_w-12*5, _y, 12*5,8*5, Color.hex("f00"))
      Canvas.line(_x+_w-10*5, y+2*5, _x+w-2*5, y+6*5, Color.white, 2)
      Canvas.line(_x+_w-2*5, y+2*5, _x+w-10*5, y+6*5, Color.white, 2)
      Canvas.rect(_x-1,_y-1, _w+1, _h+1, Color.black)
      Font["OpenSans"].print(DIALOGS[type]["title"],_x+5, _y+1, Color.black)
      Font["OpenSans"].print(DIALOGS[type]["body"], _x+5, _y+40, Color.black)
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
    Window.fullscreen=true
    _mouseClick = [false, -1, -1, -1] // [isMouseRegisteredToPopup, popupIndex, mouseDistFromX, mouseDistFromY]
    _loopForPopupIndex = 0
    _popups = []
    _rand = Random.new()
    _wait = _rand.float(0.25, 1.25)
    _tick = 0
    _scale = 1
    //Canvas.resize(960, 544)
    Canvas.resize(Window.width,Window.height)
    //Window.resize(_scale * Canvas.width, _scale * Canvas.height)
    Window.title = "PopUp "+VERSION
    Font.load("OpenSans_S", "./_assets/OpenSans.ttf", 20)
    Font.load("OpenSans", "./_assets/OpenSans.ttf", 25)
    Font.load("OpenSans_XL", "./_assets/OpenSans.ttf", 50)
    Font.load("OpenSans_XXXL", "./_assets/OpenSans.ttf", Canvas.height/3)
  }
  update() {
    Canvas.resize(Window.width,Window.height)
    Font.load("OpenSans_XXL", "./_assets/OpenSans.ttf", Canvas.height/6)
    Font.load("OpenSans_XXXL", "./_assets/OpenSans.ttf", Canvas.height/2)
    if (MODE == "play") {
      _tick = _tick+1
      if (_tick >= 60 * _wait || Keyboard.isKeyDown("down")) {
        _popups.add(Dialog.new())
        _tick = 0
        _wait = _rand.float(0.5, 1.5)
      }
      if (!Mouse.isButtonPressed("left")) {
        _mouseClick=[false,-1,-1,-1]
      }
      _popups.each { |pop|
        pop.update()
        if (_mouseClick[0]==false && Mouse.isButtonPressed("left") && ((Mouse.x > pop.x && Mouse.x < pop.x+pop.w) && (Mouse.y > pop.y && Mouse.y < pop.y+pop.h))) {
          _mouseClick=[true, _loopForPopupIndex,Mouse.x-pop.x,Mouse.y-pop.y]
        }
        if (_mouseClick[1]==_loopForPopupIndex) {
          _popups[_loopForPopupIndex].position(Mouse.x-_mouseClick[2], Mouse.y-_mouseClick[3])
        }
        if (pop.finish == true) {
          _popups.removeAt(_loopForPopupIndex)
          _mouseClick=[false,-1,-1,-1]
        }
        _loopForPopupIndex=_loopForPopupIndex+1
      }
      _loopForPopupIndex=0
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
    if (MODE == "play") {
      Canvas.cls(Color.hex("#204050"))
      _popups.each{ |pop|
        pop.draw()
      }
      if (_popups.count >= 10) {
        Font["OpenSans_XXL"].print("MEMORY FULL", Canvas.width/6+2, Canvas.height/3+2, Color.hex("fff"))
        Font["OpenSans_XXL"].print("MEMORY FULL", Canvas.width/6, Canvas.height/3, Color.hex("f22"))
      }
      Font["OpenSans_XL"].print("Score: "+SCORE.toString, 4, -16, Color.black)
      Font["OpenSans_XL"].print("Score: "+SCORE.toString, 5, -15, Color.white)
    } else if (MODE == "over") {
      Canvas.cls(Color.hex("#0084ff"))
      if (HIGHSCORE < SCORE) HIGHSCORE = SCORE
      Font["OpenSans_XXXL"].print(":(", 10, -125, Color.white)
      Font["OpenSans_XXL"].print("PopUp "+VERSION, Canvas.width/5, Canvas.height/6, Color.white)
      Font["OpenSans"].print("Your PC ran into a problem and needs to restart\nWe're just collecting some error info, then\nplease throw this PC into the bin.", 10, Canvas.height/1.5, Color.white)
      Font["OpenSans_S"].print("If you would like to learn more then don't search online\nblue_screen_of_death_in_whmsft_popup_err_101", 10, Canvas.height-70, Color.white)
      SCORE = 0
      FileSystem.save(".data", "|"+num2str(HIGHSCORE)+"|")
    } else if (MODE == "boot") {
      Canvas.cls(Color.hex("#000"))
      Font["OpenSans"].print("HIGHSCORE:"+HIGHSCORE.toString, 10, Canvas.height-40, Color.white)
      Font["OpenSans_XXXL"].print(":)", 10, -125, Color.white)
      Font["OpenSans_XXL"].print("PopUp "+VERSION, Canvas.width/5, Canvas.height/6, Color.white)
      Font["OpenSans"].print("Hit <RETURN> to spark it up!", Canvas.width/5, Canvas.width/4, Color.white)
    }
  }
}

var Game = main.new()
