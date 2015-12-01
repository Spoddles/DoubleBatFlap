Game = Game or class()

function Game:init(gamedata)
--print(readGlobalData("gametype_1_maximum"),readGlobalData("gametype_2_maximum"),readGlobalData("gametype_3_maximum"))
    gState="InProgress"
    self.buttons=Buttons(self)
    self.gamedata=gamedata
    self.type=gamedata[1]
    self.gamename=gamedata[2]
    self.scoreactive=false
    self:createborders()
    self.timelinedelta=0
    self.tl=gtimelinedouble
    self.pointdelta=0
    self.pointrate=gPointRate
    self.prevpointrate=gPointRate
    self.pulsespeed=gPulseSpeed
    self.pulsemax=4
    self.totaldeltamax=6
    self.framedeltamin=0.03
    self.framedeltamax=.06
    self.touchdeltamax=.5
    self.bgroundrate=.25
    self.bgroundposx=0
    self.bgrounddelta=0
    self.nasties={}
    self.obstacles={}
    self.obstaclecurrent=1
    self.obstaclerate=0
    self.obstacledelta=0
    self.nastyattackrate=0
    self.nastyattackdelta=0
    self.gamedelta=0
    self.currentstate="" self.currentmessage="" self.prevstate=""
    self.splats={}
    self.touchdelta=0
    physics.gravity(0,-200)
    spriteMode(CENTER)
    ellipseMode(CENTER)
    self.score={}
    self.score["left"]=Score(self,"left",gScoreWidthSmall)
    self.score["right"]=Score(self,"right",gScoreWidthSmall)
    self.scoretable={self.score["left"],self.score["right"]}
    self.score["maxtotal"]=Score(self,"maxtotal",gScoreWidthBig,self.scoretable)
    
    self.leftbat=Bat(self,"left")
    self.rightbat=Bat(self,"right")
    
    self.scoretweens={}
    self.obsttweens={}
    local i=20
    local k=i*60+i*2
    self.pavement=image(k,30)
    setContext(self.pavement)
    pushStyle()
    fill(225, 225, 225, 255)
    spriteMode(CORNER)
    rectMode(CORNER)
    rect(0,0,WIDTH,30)
    tint(200,200,200, 255)
    for j=1,i do
        sprite("Dropbox:brick"..math.ceil(j/5),((j-1)*60+j*2),0,60)
    end
    noTint()
    spriteMode(CENTER)
    setContext()
    self.screen=image(WIDTH, HEIGHT)
end

function Game:draw()
    local dt=DeltaTime
    setContext(self.screen)
    background(0, 0, 0, 255)
    pushMatrix()
    spriteMode(CORNER)
    translate(self.bgroundposx,0)
    sprite("Dropbox:skyline2")
    popMatrix()
    pushMatrix()
    spriteMode(CORNER)
    translate(0,0)
    sprite(self.pavement)
    popMatrix()
    pushMatrix() pushStyle()
    translate(0,HEIGHT-(gScoreWidthBig*1.5)*2)
    fill(0,0,0,80)
    rect(0,0,WIDTH,(gScoreWidthBig*1.5)*2)
    popMatrix() popStyle()
    noFill()
    spriteMode(CENTER)
    self.score["right"]:draw()
    self.score["left"]:draw()
    self.score["maxtotal"]:draw()
    noTint()

    --Purge expired objects and tweens
    local o={self.leftbat.pulses,self.rightbat.pulses,self.nasties,self.splats,self.obstacles,self.scoretweens,self.obsttweens}
    for i,j in pairs(o) do
        if #j>0 then
            self:purgeexpired(j)
        end
    end
    
    --draw the bats and the buttons
    self.leftbat:draw()
    self.rightbat:draw()
    
    -- then draw what's left after purge
    -- firstly scoretweens...
    
       local o={self.leftbat.pulses,self.rightbat.pulses,self.nasties,self.splats,self.obstacles}
    for i,j in pairs(o) do
        if #j>0 then
            for k,l in pairs(j) do
                l:draw()
            end
        end
    end
    
    self:drawscoretweens()
    -- and then remaining  objects
 
    
    -- if there is a current touch registered then and we have passed pulse trigger threshold then give the bat a push
    if not gPaused then
      if self.leftbat.lasttouch~="None" and self.leftbat.tapdelta>=0 then
         self.leftbat.body:applyForce( vec2(0,gBatForce),vec2(self.leftbat.body.x,self.leftbat.body.y-50))
         
      end
      if self.rightbat.lasttouch~="None" and self.rightbat.tapdelta>=0 then
         self.rightbat.body:applyForce( vec2(0,gBatForce),vec2(self.rightbat.body.x,self.rightbat.body.y-50))
      end
      -- 
      local obj={self.leftbat.pulses,self.rightbat.pulses,self.nasties,self.splats,self.obstacles}
      -- if the point reduction timer is activated then add delta time from last frame
      if self.scoreactive==true then
          self.pointdelta = self.pointdelta + dt
          -- if we hit the number of seconds when a time penalty is due the then we need to subtract it from score 
          if self.pointdelta >=self.pointrate then
              
              for i,j in pairs(self.scoretable) do
                  j:subscore(gTimerPenalty,"timer")
              end
              self.pointdelta = self.pointdelta - self.pointrate
          end
          
      end
    
      local p1=0
      if #self.tl>0 then
          self.trigger=self.tl[1]
          p1=self.trigger[1]
  
      end
      self.timelinedelta = self.timelinedelta + dt
      if self.timelinedelta>p1 and self.trigger~=nil then
          self:processtrigger()
          table.remove(self.tl,1)
      end
      
      self.bgroundposx = self.bgroundposx + self.bgroundrate
      if self.bgroundposx>0 then
          self.bgroundposx=0
          self.bgroundrate=-self.bgroundrate
      end
      local x,y=spriteSize("Dropbox:skyline2")
      if self.bgroundposx< -(x-WIDTH) then
          self.bgroundposx=-(x-WIDTH)
          self.bgroundrate=-self.bgroundrate
      end 
      if self.nastyattackrate~=0 then
          self.nastyattackdelta=self.nastyattackdelta+dt
          if self.nastyattackdelta>self.nastyattackrate then
              if #self.nasties<gNastyMax then
                  self.nastyattackdelta=self.nastyattackdelta-self.nastyattackrate
                  local i,yloc,xlocl,dest1,dest2
                  if game.type==3 then
                      xlocl=WIDTH/2 xlocr=WIDTH/2
                      dest1="left" dest2="right"
                      elseif game.type==1 then
                      xlocl=0 xlocr=WIDTH
                      dest1="left" dest2="right"
                      elseif game.type==2 then
                      xlocl=WIDTH xlocr=WIDTH
                      dest1="left" dest2="left"
                  end
                  i=math.random(1,2)
                  yloc=math.random(100,HEIGHT-gScoreWidthSmall*3)
                  table.insert(self.nasties,Nasty(i,xlocr,yloc,dest1))
                  yloc=math.random(100,HEIGHT-gScoreWidthSmall*3)
                  i=math.random(1,2)
                  table.insert(self.nasties,Nasty(i,xlocl,yloc,dest2))
              end
          end
      end
    end
    if self.currentmessage~="" then
        pushMatrix() pushStyle()
        textWrapWidth(400)
        textAlign(CENTER)
        fill(255, 255, 255, 146)
        font("MarkerFelt-Wide")
        fontSize(32)
        translate(WIDTH/2,HEIGHT/2)
        text(self.currentmessage)
        popStyle()
        popMatrix()

        end
        if self.currentoverlay~=nil then
        pushMatrix() pushStyle()
        spriteMode(CENTER)
        translate(WIDTH/2,HEIGHT/2)
        sprite(self.currentoverlay,0,0)
        popStyle()
        popMatrix()

        end
    if self.obstaclerate~=0 then
        self.obstacledelta = self.obstacledelta + dt
        if self.obstacledelta > self.obstaclerate then
            self.obstacledelta = self.obstacledelta - self.obstaclerate
            if #self.obstacles<gObstacleMax then
                local xloc1,xloc2,dest1,dest2,obst1,obst2,yloc
                local o={}
                if self.obstaclecurrent~=0 then
                    obst1=self.obstaclecurrent obst2=self.obstaclecurrent
                else
                    obst1=math.random(1,3) obst2=math.random(1,3)
                end
                if game.type==3 then
                    xloc1=WIDTH/2 xloc2=WIDTH/2
                    dest1="left" dest2="right"
                    elseif game.type==1 then
                    xloc1=0 xloc2=WIDTH
                    dest1="right" dest2="left"
                    elseif game.type==2 then
                    xloc1=WIDTH xloc2=WIDTH
                    dest1="left"
                    obst2=nil
                end
                if obst1~=nil then
                    if obst1==1 or obst1==2 then
                        yloc=30
                        elseif obst1==3 then
                        yloc=HEIGHT+math.random(1,75)
                    end
                    o=Obstacle(obst1,xloc1,yloc,dest1)
                    table.insert(self.obstacles,o)
                    table.insert(self.obsttweens,TweenObst(o,0,255))
                end
                if obst2~=nil then
                    if obst2==1 or obst2==2 then
                        yloc=30
                        elseif obst2==3 then
                        yloc=HEIGHT
                    end
                    o=Obstacle(obst2,xloc2,yloc,dest2)
                    table.insert(self.obstacles,o)
                    table.insert(self.obsttweens,TweenObst(o,0,255))
                end
            end
        end
    end
  spriteMode(CENTER)
  setContext()
  --resetMatrix()
  spriteMode(CORNER)
  translate(0,0)
  sprite(self.screen)
  self.buttons:draw()
    if gDialog~=nil then
    gDialog:draw()
    end
end

function Game:touched(touch)
  local r,i
  self.lasttouch=touch
  local point=vec2(touch.x,touch.y)
  if gDialog~=nil then
    tb=gDialog:findtouched(touch)
    if #tb>0 then
      b=tb[1]
      r=gDialog:touched(touch,b)
      if r=="pressing" then
      elseif r=="pressed" then
        if b.type=="ok" then
          gDialog.origbutton.visible=true
          gDialog.origbutton.active=true
          gDialog=nil
          gPaused=false        
          physics.resume()
        elseif b.type=="no" then
          gDialog=nil
          gPaused=false
          physics.resume()
        elseif b.type=="continue" then
          gDialog.origbutton.visible=true
          gDialog.origbutton.active=true
          gDialog=nil
          gPaused=false        
          physics.resume()
        end
      end
    end
  else
    local tb=self.buttons:findtouched(point)
    if #tb>0 then
      b=tb[1]
      r=self.buttons:touched(touch,b)
      if r=="pressing" then
      elseif r=="pressed" then
        if b.type=="pause" then
          gPaused=not gPaused
          if gPaused then
            gDialog=Dialog("Game Paused",vec2(WIDTH/2,HEIGHT/2),"pause",{"continue"},b)
            b.active=false
            physics.pause()
          else
            gDialog=nil
            b.active=true
            physics.resume()
          end
        elseif b.type=="stop" then
            gPaused=true
            gDialog=Dialog("Are you sure you want to end game?",vec2(WIDTH/2,HEIGHT/2),"no",{"ok"},b)
        end
      end
    else
        self.buttons.lastouch=nil self.buttons.selected=nil
      if touch.state==BEGAN then
        local thebat
        if touch.x<=gScreenCentre.x then
          thebat=self.leftbat
        else
          thebat=self.rightbat
        end
        if thebat.lasttouch=="None" then
          thebat.lasttouch=touch.id
          thebat.body.linearVelocity=vec2(0,gBatPush)
          thebat.touchdelta=0
          thebat.framedelta=gFrameDeltaFast
          thebat.tapdelta = 0
          --thebat.body.gravityScale=.5
        end
      end
      if touch.state==MOVING then
        if touch.x<=gScreenCentre.x then
        else
        end
      end
      if touch.state==ENDED then
    --print("touch ended")
        if touch.id==self.leftbat.lasttouch then
          self.leftbat.framedelta=gFrameDeltaSlow
          if self.leftbat.tapdelta < .20 then
            if #self.leftbat.pulses<=self.pulsemax then
              local dest
              if self.type==1 then
                dest="left"
              elseif self.type==2 then
                dest="right"
              elseif self.type==3 then
                dest="left"
              end
              table.insert(self.leftbat.pulses,Pulse(self.leftbat,dest))
              --print("create apulse")
              sound("Dropbox:pulsev2") --sound("Dropbox:pulse") --
            end
          else
          end
          self.leftbat.body.gravityScale=1
          self.leftbat.lasttouch="None"
          self.leftbat.touchdelta=0
        elseif touch.id==self.rightbat.lasttouch then
          self.rightbat.framedelta=gFrameDeltaSlow
          if self.rightbat.tapdelta < .2 then
            if #self.rightbat.pulses<=self.pulsemax then
              local dest
              if self.type==1 then
                dest="left"
              elseif self.type==2 then
                dest="right"
              elseif self.type==3 then
                dest="left"
              end
              sound("Dropbox:pulsev2") --sound("Dropbox:pulse") --
              table.insert(self.rightbat.pulses,Pulse(self.rightbat,dest))

            end
          end
          self.rightbat.body.gravityScale=1
          self.rightbat.lasttouch="None"
          self.rightbat.touchdelta=0
        end
      end
    end
  end
end

function Game:launchnasty()
    
end

function Game:addscoretween(i,x,y,t)
    local j={}
    local k,l=spriteSize("DropBox:splat1")
    table.insert(self.scoretweens,TweenScore(i,x,y,t))
end

function Game:drawscoretweens()
    pushStyle()
    textMode(CENTER)
    if #self.scoretweens>0 then
        for i,j in pairs(self.scoretweens) do
            j:draw()
        end
    end
    popStyle()
end

function Game:processtrigger()
    local p2,p3,p4  
    p2=self.trigger[2] p3=self.trigger[3] p4=self.trigger[4]
    if p2=="TextHelpOn" then
        self.currentmessage=p3
    end
    if p2=="TextHelpOff" then
        --self.prevstate=""
        self.currentmessage=""
    end
    if p2=="ImageOn" then
      self.currentoverlay=p3
    end
    if p2=="ImageOff" then
      self.currentoverlay=nil
    end
    if p2=="Change" then
        local command=p3.."="..p4
        loadstring(command)()
    end
    self.trigger=nil
end
    
function Game:purgeexpired(l)
    if #l>0 then
        for i,j in pairs(l) do
            if j.expired then
                if j.body~=nil then
                    j.body:destroy()
                    j.body=nil
                end
                if j.body2~=nil then
                    j.body2:destroy()
                    j.body2=nil
                end
                table.remove(l,i)
            end
        end
    end
end
    


function Game:createborders()
self.topedge={}
    self.topedge.body=physics.body(EDGE,vec2(0,HEIGHT),vec2(WIDTH,HEIGHT))
    self.topedge.body.object="wall"
    self.topedge.body.restitution=.5
    self.topedge.body.name="top"
    self.bottomedge={}
    self.bottomedge.body=physics.body(EDGE,vec2(0,30),vec2(WIDTH,30))
    self.bottomedge.body.object="wall"
    self.bottomedge.body.name="bottom"
end

