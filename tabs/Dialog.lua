Dialog = class()

function Dialog:init(text,location,type,mybuttons,b)
    self.text = text
    self.location=location
    self.type=type
    self.mybuttons={}
    self.width=WIDTH*.5
    self.height=HEIGHT*.5
    self.origbutton=b
    self.buttonrowheight=0
    self.dialogimg=image(self.width,self.height)
    for i,j in pairs(mybuttons) do
        local thesprite
        if j=="ok" then
            thesprite="Dropbox:ok"
            elseif j=="no" then
            thesprite="Dropbox:no"
            elseif j=="continue" then
            thesprite="Dropbox:b_continue"
        end
        local w,h=spriteSize(thesprite)
        self.buttonrowheight=math.max(self.buttonrowheight,h*1.25)
        --print(self.buttonrowheight)
        local l=vec2(self.width/2,self.buttonrowheight)
        table.insert(self.mybuttons,DButton(j,l,true,true))
    end
end

function Dialog:draw()
    pushStyle() pushMatrix()
    
    setContext(self.dialogimg)
    
    fill(0, 0, 0, 255)
    stroke(107, 212, 193, 255)
    strokeWidth(2)
    rectMode(CORNER)
    rect(0,0,self.width,self.height)
    textMode(CENTER)
    font("MarkerFelt-Wide")
    fontSize(50)
    textAlign(CENTER)
    fill(0, 255, 209, 255)
    textWrapWidth(self.width*.75)
    text(self.text,self.width/2,self.buttonrowheight+self.height/2)
    popMatrix() popStyle()
    pushMatrix() pushStyle()
    --tint(25, 44, 41, 255)
    for i,j in pairs(self.mybuttons) do
        j:draw()
    end
    --noTint()
    setContext()
    translate(self.location.x,self.location.y)
    spriteMode(CENTER)
    sprite(self.dialogimg)
    popMatrix() popStyle()
end

function Dialog:findtouched(touch)
  local localx=touch.x-self.width/2
  local localy=touch.y-self.height/2
  local tb={}
  for i,j in pairs(self.mybuttons) do
    local loc,t,b,l,r
    loc=j.location
    t=loc.y+j.height/2
    b=loc.y-j.height/2
    l=loc.x-j.width/2
    r=loc.x+j.width/2
    if (localx>l and localx<r) and (localy>b and localy<t) and j.isactive==true then
      table.insert(tb,j)
    end
  end
  return(tb)
end

function Dialog:touched(touch,tb)
  local r
  if touch.state==BEGAN or touch.state==MOVING then
    r="pressing" self.lasttouch=touch self.selected=tb
  elseif touch.state==ENDED then
    if tb==self.selected then
      self.lasttouch=nil r="pressed" self.selected=nil
    end
  end
  tb.state=r
  return(r)
end

DButton=DButton or class()

function DButton:init(type,location,isvisible,isactive)
    self.type=type
    self.location=location
    self.isvisible=isvisible
    self.state="normal"
    if isvisible~=nil then self.isvisible=isvisible
        else self.isvisible=true
    end
    if isactive~=nil then self.isactive=isactive
        else self.isactive=true
    end
    local s
    if self.type=="ok" then
      s="Dropbox:ok"
    elseif self.type=="no" then
      s="Dropbox:no"
    elseif self.type=="continue" then
      s="Dropbox:b_continue"
    end
    self.width,self.height=spriteSize(s)
    self.sprite=s
end

function DButton:draw()
    pushStyle() pushMatrix()
    spriteMode(CENTER)
    if self.isvisible then
        translate(self.location.x,self.location.y)
        sprite(self.sprite,0,0)
    end
    popMatrix() popStyle()
end
