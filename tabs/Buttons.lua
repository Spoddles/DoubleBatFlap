Buttons = Buttons or class()
function Buttons:init()
  self.buttons={}
  self.scores={}
  self.selected=nil
  local b,w,h
  if gState=="Title" then
    local tw=gGameTitleWidest
    local gamestotal=#gGameTitles
    local dest,start1,start2
    
    for i=1,gamestotal do
      g=gGameData[i]
      pushStyle()
      fontSize(gGameTitleSize) font("MarkerFelt-Wide")
      w,h=textSize(g[2])
      popStyle()
      dest = vec2(WIDTH/2-tw/2, HEIGHT/2-i*gGameTitleHeight*1.1)
      if (i%2==0) then
        start1=WIDTH+tw
      else
        start1=-tw
      end
      --print (start1)
      start2=HEIGHT+50
      b=Button("gametype",i,g[2],vec2(start1, dest.y),true,true)
      b.height=gGameTitleHeight b.width=w
      table.insert(self.buttons,b)
      local t1=tween(2,b.location,{x=dest.x},tween.easing.backOut)
      dest=vec2(WIDTH/2+(gGameTitleWidest/2)*1.1, HEIGHT/2-i*gGameTitleHeight*1.1)
      self.scores[i]={gamehigh=readGlobalData("gametype_"..i.."_maximum"),location=vec2(dest.x, start2)}
      local t2=tween(1,self.scores[i].location,{y=dest.y},tween.easing.backOut)
      tween.sequence(t1,t2)
    end
    w,h=spriteSize("Dropbox:audio-on")
    b=Button("audio",gamestotal+1,"",vec2(60, 60),true,true)
    b.height=h b.width=w
    --print(h,w)
    table.insert(self.buttons,b)
    w,h=spriteSize("Dropbox:checkbox")
    b=Button("tutorial",gamestotal+2,"",vec2(WIDTH/2, 60),true,true)
    b.height=h b.width=w
    table.insert(self.buttons,b)

  elseif gState=="InProgress" then
    local w,h=spriteSize("Dropbox:pause")
    b=Button("pause",1,"pause",vec2(WIDTH*.66,HEIGHT-(h/2)-10),true,true)
    b.width=w b.height=h
    table.insert(self.buttons,b)
    w,h=spriteSize("Dropbox:play")
    b=Button("stop",2,"stop",vec2(WIDTH*.33,HEIGHT-(h/2)-10),true,true)
    b.width=w b.height=h
    table.insert(self.buttons,b)
  end
end

function Buttons:findtouched(point)
  local tb={}
  local gb=self.buttons
  for i,k in pairs(gb) do
    local loc=k.location
    local t=loc.y+k.height/2
    local b=loc.y-k.height/2
    local l=loc.x-k.width/2
    local r=loc.x+k.width/2
    if (point.x>l and point.x<r) and (point.y>b and point.y<t) and k.active==true then
      table.insert(tb,k)
    end
  end
    --print("tb",tb)
  return(tb)
end

function Buttons:draw()
  for i,j in pairs(self.buttons) do
  if j.visible then
 -- if j.visible then
    j:draw(self.selected==j)
    --print("draw")
    end
 -- end
  end
end

function Buttons:touched(touch,tb)
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


Button = Button or class()
function Button:init(type,id,text,location,isactive,isvisible) --width,height,isactive,isvisible)
  self.type=type
  self.id=id
  self.state = "normal"
  self.text = text
  self.location = location
--  self.width = width
--  self.height = height
  self.visible = isvisible
  self.active=isactive
  
end

function Button:draw(isselected)
  pushMatrix() pushStyle()
        spriteMode(CENTER)
  if self.visible == true then
    --print("is visible",gState,isselected,self.active)
    local thesprite
    if gState=="Title" then
      if self.type=="gametype" then
        tint(255,255,255,100)
        thesprite="Dropbox:gametype"..self.id
        translate(self.location.x,self.location.y)
        pushStyle()
        if isselected then
          --sprite("Dropbox:gametypeoverlay")
          fill(255,255,255,255)
         else
                fill(0, 113, 255, 255)
        end
        fontSize(40)
        font("MarkerFelt-Wide")
                textMode(CENTER)
        text(self.text)
        popStyle()
        
      elseif self.type=="audio" then
        translate(self.location.x,self.location.y)
        if isselected then
          tint(196, 145, 30, 255)
        end
        if gSoundOn then
          sprite("Dropbox:audio-on")
        else
          sprite("Dropbox:audio-off")
        end
      elseif self.type=="tutorial" then
                
        translate(self.location.x,self.location.y)
        if isselected then
          tint(196, 145, 30, 255)
        end
        local w,h
        if gTutorial then
        w,h=spriteSize("Dropbox:checkboxchecked")
        else
        w,h=spriteSize("Dropbox:checkbox")
        end
        if gTutorial then
          sprite("Dropbox:checkboxchecked")
        else
        
          sprite("Dropbox:checkbox")
        end
                translate(w,-(h/1.5))
                fontSize(40)
                textMode(CORNER)
                text("Tutorial")
      end
    elseif gState=="InProgress" then
      if self.type=="pause" then
        tint(255,255,255,100)
        if gPaused then
          thesprite="Dropbox:play"
        else
          thesprite="Dropbox:pause"
        end

      elseif self.type=="stop" then
        tint(255,255,255,100)
        thesprite="Dropbox:stop"

      elseif self.type=="ok" then
        tint(255,255,255,100)
        thesprite="Dropbox:ok"

      elseif self.type=="cross" then
        tint(255,255,255,100)
        thesprite="Dropbox:cross"

      elseif self.type=="tick" then
        tint(255,255,255,100)
        thesprite="Dropbox:tick"
      elseif self.type=="continue" then
        tint(255,255,255,100)
        thesprite="Dropbox:b_continue"
      end
      translate(self.location.x,self.location.y)
      spriteMode(CENTER)
      sprite(thesprite)
    end

  end
  popMatrix() popStyle()
end

function Button:touched(touch)
  if touch.state==BEGAN then
    self.pressed=true
    self.id=nil
  end
end

function Button:istouched(touch)
  local r=false
  if self.visible then
    if touch.x >= self.location.x-self.width/2 and touch.x <= self.location.x + self.width/2 and touch.y >= self.location.y-self.height/2 and touch.y <= self.location.y + self.height/2 then
      r=true
    end 
  end
  return(r)
end