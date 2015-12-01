Score = Score or class()

function Score:init(parent,name,size,scoretable)
    -- you can accept and set parameters here
    self.name=name
    local w,h=spriteSize("Dropbox:scorefnt0")
    self.size=w
    self.bgsize=w
    self.height=h/w*self.size
    self.width=(self.size*gScoreSpaceScalar*gMaxDigits)-(self.size*.1)
    --print (self.size,self.width,temp.height)
    if self.name=="left" then
    self.x=WIDTH/7
    self.y=HEIGHT-self.height/2-10
    self.displayname="LEFT"
    elseif self.name=="right" then
        if parent.type==2 then
            self.x=WIDTH/2
        else
            self.x=(WIDTH-WIDTH/7)
        end
    self.y=HEIGHT-self.height/2-10
    self.displayname="RIGHT"
    elseif self.name=="total" then
    self.x=self.width*2-self.width/2+110
    self.y=HEIGHT-self.height/2-10
    self.displayname="CURRENT TOTAL"
    elseif self.name=="maxtotal" then
    self.width=(self.size*gScoreSpaceScalar*gScoreBigScalar*gMaxDigits)-(self.size*(gScoreSpaceScalar-1))
        if parent.type==2 then
            self.x=(WIDTH-WIDTH/7)
        else
            self.x=WIDTH/2
        end
    self.y=HEIGHT-self.height/2-10 --self.size*1.5
    self.displayname="MAXIMUM"
    end
    self.score=0
    self.parent=parent
    self.timer=30
    self.timeractive=false
    self.timerdelta=0
    self.scoretable=scoretable
    self.maxscoretint={}
    for i,j in pairs(gMaxScoreTint) do
    self.maxscoretint[i]=j
    end
end

function Score:draw()

  local dt=DeltaTime
  local sc=0
  local zeros
  local zc=""
  
    local keyname="gametype_"..self.parent.type.."_maximum"
    local currenthigh=readGlobalData(keyname)
  if self.name=="maxtotal" then
    for i,j in pairs(self.scoretable) do
      sc=math.abs(sc+j.score)
    end
    if sc>self.score then
    
    local gmst
    
      if self.score>currenthigh then
      gmst=gAlltimeMaxScoreTint
      saveGlobalData(keyname,self.score)
      else
      gmst=gMaxScoreTint
      end
      self.score=sc
            if self.scoresound==nil then
            self.scoresound=sound("A Hero's Quest:Defensive Cast 1")
            else
              if not self.scoresound.playing then
              self.scoresound=sound("A Hero's Quest:Defensive Cast 1")
              end
            end
      local t1=tween(.5,self.maxscoretint,{x=gMaxScorePulseTint.x,y=gMaxScorePulseTint.y,z=gMaxScorePulseTint.z})
      local t2=tween(.5,self.maxscoretint,{x=gmst.x,y=gmst.y,z=gmst.z})
      tween.sequence( t1, t2)
      local t3=tween(.5,self,{bgsize=self.size*1.2})
      local t4=tween(.5,self,{bgsize=self.size})
      tween.sequence( t3, t4)
    end
    if self.parent.scoreactive==false and self.score>50 then self.parent.scoreactive=true end
  end

  sc=math.abs(self.score)
  local scorelength=string.len(self.score)
  for i=gMaxDigits,1,-1 do
    if sc<math.pow(10,i) then
      zeros=gMaxDigits-i
    end
  end

  if self.score<0 then zeros=zeros-1 end
  if zeros>0 then
    for i=1,zeros do zc="Z"..zc end
  end
  zc=zc..self.score
  spriteMode(CENTER)
  local numled=gMaxDigits
  local scalar=1
  if self.score<0 then
    if not gPaused then
    if self.timerdelta-math.floor(self.timerdelta) <.5 then
      tint(255, 0, 0, 255)
    end
    end
  elseif self.name=="maxtotal" then scalar=gScoreBigScalar tint(self.maxscoretint.x,self.maxscoretint.y,self.maxscoretint.z,self.maxscoretint.a) end
  
  for i=0,scorelength-1 do
    local char=string.sub(self.score,i+1,i+1)
    pushMatrix() pushStyle()
    translate(self.x+i*self.size*scalar*gScoreSpaceScalar-(self.size*scalar*gScoreSpaceScalar*(scorelength-1))/2,self.y)
        
            pushStyle()
            noTint()
            if self.bgsize~=self.size then
                sprite("Dropbox:scorefnt"..char,0,0,self.bgsize*scalar)
            end
            popStyle()
            sprite("Dropbox:scorefnt"..char,0,0,self.size*scalar)
        popMatrix() popStyle() 
    end
    
  noTint()
  if self.name=="right" or self.name=="left" then

    if self.timeractive==true then
      if not gPaused then
        self.timerdelta=self.timerdelta+dt
      end
      if self.timerdelta>self.timer then
        self.timeractive=false
      else
        if self.score>=0 then
          self.timeractive=false
          self.timerdelta=0
        else
        
          spriteMode(CENTER)
          pushStyle()
          pushMatrix()
       local timerloc
          if self.name=="right" then
          timerloc=WIDTH-35.5*1.1
          else
          timerloc=35*1.1
          end
          translate(timerloc,self.y)
          local timerpercentage=self.timerdelta/self.timer
          local rotation=timerpercentage*360
          tint(255,0,0,255)
          if self.timerdelta<=self.timer/2 then
          pushMatrix()
            rotate(180)
            sprite("Dropbox:pieblack",0,0,35.5)
            --pushMatrix()
            rotate(rotation) 
            sprite("Dropbox:piewhite",0,0,35.5)
            popMatrix()
            sprite("Dropbox:piewhite",0,0,35.5)
          else
            pushMatrix()
            sprite("Dropbox:piewhite",0,0,35.5)
            rotate(180)
            sprite("Dropbox:pieblack",0,0,35.5)
            popMatrix()
            pushMatrix()
            rotate(rotation) 
            sprite("Dropbox:pieblack",0,0,35.5)
            popMatrix()
            
          end
          --print(self.timer,math.floor(self.timerdelta))
          pushMatrix() pushStyle()
          fontSize(20)
          font("GillSans")
          if self.timerdelta-math.floor(self.timerdelta) <.5 then
      
          fill(255,255,255,255)
          else
          fill(0,0,0,0)
          end
          --fill(255,255-timerpercentage*230+25,255-timerpercentage*230+25)
          text(self.timer-math.floor(self.timerdelta),0,0)
          popMatrix() popStyle()
          popStyle() popMatrix()
        end
      end
    else
      if self.score<0  then
        self.timeractive=true
        self.timerdelta=0
      end  
    end
  end
end

function Score:addscore(score)
    self.score = self.score + score
    sound("Game Sounds One:Punch 1")
    --game:addscoretween(10,obj.x,obj.y)
end

function Score:subscore(score,hittype)
    if hittype=="nasty" then
        sound("Game Sounds One:Slap")
        self.score=self.score-score
    elseif hittype=="obstacle" then
        sound("Game Sounds One:Kick")
        self.score=self.score-score
    elseif hittype=="timer" then
        if self.parent.scoreactive then
            self.score=self.score-gTimerPenalty
        end
    elseif hittype=="pulse" then
        sound("A Hero's Quest:Hurt 4")
        self.score=self.score-score
        --self.score=0
    end
    if self.score <0 then
        
    end
    
end



function Score:touched(touch)
    -- Codea does not automatically call this method
end

TweenScore = TweenScore or class()
function TweenScore:init(i,x,y,t)
    self.type=t
    self.rawscore=i
    self.alpha=0 self.expired=false self.t1expired=false self.t2expired=false
    if i>=0 then
        self.drawscore="+"..i
        else
        self.drawscore=i
    end
    local dx,dy,d
    if self.type==1 then
    self.w,self.h=spriteSize("DropBox:splat1")
    local k=self.w local l=self.h
    self.x=x+k/2 self.y=y+k/2 dx=x+15 dy=y+20 d=.25
    end
    if self.type==2 then
    self.x=x self.y=y dx=x+15 dy=y+20 d=.15
    end
    tween.start(.5,self,{x=dx,y=dy})
    local t1=tween.start(d,self,{alpha=255},tween.easing.cubicIn,function() self.t1expired=true end)
    local t2=tween.start(d,self,{alpha=0},tween.easing.cubicOut,function() self.t2expired=true end)
    tween.sequence(t1,t2)
end

function TweenScore:draw()
    if self.t1expired and self.t2expired then
                self.expired=true
    end
    if not self.expired then
        pushMatrix()
        pushStyle()
        textMode(CORNER)
        translate(self.x,self.y)
        local fs
        if self.type==1 then
        fs=22
        elseif self.type==2 then
        fs=22
        end
        fontSize(fs)
        textAlign(CENTER)
        font("Papyrus")
        if self.rawscore<0 then
            fill(224, 50, 50, self.alpha)
        else
            fill(127, 213, 119,self.alpha )
        end
        text(self.drawscore,0,0)
        popStyle()
        popMatrix()
    end
end
