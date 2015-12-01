Title = Title or class()

function Title:init()
  self.ang=0
  self.lasttouch=nil
  gState="Title"
  self.buttons=Buttons()
  --self.scores={}
  
end

function Title:draw()

  background(0,0,0,0)

  spriteMode(CENTER)
  pushMatrix()
  sprite("Dropbox:skyline",WIDTH/2,HEIGHT/2)
  textMode(CENTER) fill(196, 145, 30, 255)
  font("Papyrus")
  fontSize(90)
  text("Double Bat Flap",WIDTH/2,HEIGHT-(HEIGHT/4))
  popMatrix() pushMatrix()
  self.buttons:draw()
  
  popMatrix()
  pushStyle()
    textWrapWidth(100)
    textAlign(CENTER)
    font("MarkerFelt-Wide")
  fontSize(40)
  fill(163,223,20,255)
  for i,j in pairs(self.buttons.scores) do
    pushMatrix()
    translate(j.location.x,j.location.y)
    --rectMode(CENTER)
    --rect(0,0,50,50)
    text(math.floor(j.gamehigh))
    popMatrix()
  end
  pushMatrix()
  --dest=vec2(WIDTH/2+(gGameTitleWidest/2)*1.1, HEIGHT/2-i*h*1.1)
  popStyle()
end

function Title:touched(touch)
 --if touch.state==BEGAN then
    local r
    self.lasttouch=touch
    local point=vec2(touch.x,touch.y)
    local tb=self.buttons:findtouched(point)
    if #tb>0 then
        b=tb[1]
        r=self.buttons:touched(touch,b)
        if r=="pressed" then
            if b.type=="gametype" then
                game=Game(gGameData[b.id])
            elseif b.type=="audio" then
                gSoundOn= not gSoundOn
            elseif b.type=="tutorial" then
                gTutorial= not gTutorial
            end
        end
    else
    self.buttons.lastouch=nil self.buttons.selected=nil
    end
   --end
end
