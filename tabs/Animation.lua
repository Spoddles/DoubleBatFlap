Splat=Splat or class()
function Splat:init(object,x,y)
  self.x=x self.y=y
  self.object=object self.kind="splat"
  self.frames={} self.mydelta=0
  self.expired=false self.count=1
  self.parent=parent

  if self.object==1 then
    self.framedelta=.03 self.framecount=10 self.size=gSplat1Size
    for i=1,self.framecount do
      self.frames[i]="Dropbox:splat"..i
    end
  end
end

function Splat:draw()
  spriteMode(CENTER)
  pushMatrix() pushStyle()
  if not gPaused then
    self.mydelta=self.mydelta+DeltaTime
    if self.mydelta>self.framedelta then
      self.mydelta=self.mydelta-self.framedelta
      self.count=self.count+1
      if self.count>self.framecount then self.count=self.framecount self.expired=true end
    end
  end
  translate(self.x,self.y)
  if self.object=="splat1" then
    tint(100, 230, 213, 255)
    sprite(self.frames[self.count],0,0,self.size)
    noTint()
  end
  popStyle() popMatrix()
end

Nasty = Nasty or class()

function Nasty:init(object,x,y,dest)
  self.object=object
  self.kind="nasty"
  self.dest=dest
  self.wander=false
  self.index={}
  self.frames={}
  self.count=1
  self.mydelta=0
  self.expired=false
  if self.object==1 then 
    self.body=physics.body(CIRCLE,gInsect1Size/2*gInsect1PhysicsRatio)
    self.framedelta=.03
    self.framecount=8
    self.wander=true
    self.wandermax=1
    if game.type==1 or game.type==2 then
      self.speed=gInsect1Speed
      for i=1,self.framecount do
        if self.dest=="left" then
          self.frames[i]="Dropbox:insect1-l"..i
        elseif self.dest=="right" then
          self.frames[i]="Dropbox:insect1-r"..i
        end
      end
    elseif game.type==3 then
      self.speed=-gInsect1Speed
      for i=1,self.framecount do
        if self.dest=="left" then
          self.frames[i]="Dropbox:insect1-r"..i
        elseif self.dest=="right" then
          self.frames[i]="Dropbox:insect1-l"..i
        end
      end
    end
    self.size=gInsect1Size

  end
  if self.object==2 then
    self.body=physics.body(CIRCLE,gInsect2Size/2*gInsect2PhysicsRatio)
    self.framedelta=.03
    self.framecount=4
    self.wander=true 
    self.wandermax=3
    if game.type==1 or game.type==2 then
      self.speed=gInsect2Speed
      for i=1,self.framecount do
        if self.dest=="left" then
          self.frames[i]="Dropbox:insect2-l"..i
        elseif self.dest=="right" then
          self.frames[i]="Dropbox:insect2-r"..i
        end
      end
    elseif game.type==3 then
      self.speed=-gInsect2Speed
      for i=1,self.framecount do
        if self.dest=="left" then
          self.frames[i]="Dropbox:insect2-r"..i
        elseif self.dest=="right" then
          self.frames[i]="Dropbox:insect2-l"..i
        end
      end
    end
    self.size=gInsect2Size

  end
  self.body.x = x self.body.y = y
  self.body.gravityScale=0 self.body.sensor=true self.body.friction=0
  self.body.linearVelocity=vec2(0,0)
  self.body.parent=self self.body.mynasty=self self.body.object=self.object self.body.kind="nasty"
  self.count=1

end

function Nasty:draw()
  pushMatrix() pushStyle()
  local wandered=0
  local wanderdelta=0
  if not gPaused then
    wandered=math.random()
    if wandered<.5 then wandered=-1
    elseif wandered>.5 then wandered=1
    end
    if self.wander then
      wanderdelta=wandered*math.random()*self.wandermax
    end
    self.mydelta=self.mydelta+DeltaTime
    if self.mydelta>self.framedelta then
      self.mydelta=self.mydelta-self.framedelta
      self.count=self.count+1
      if self.count>self.framecount then self.count=1 end
    end
  end

  self.body.y=self.body.y+wanderdelta
  translate(self.body.x,self.body.y)
  spriteMode(CENTER)
  fill(0,0,0,0)
  stroke(255,255,255,128)
  strokeWidth(1)
  sprite(self.frames[self.count],0,0,self.size)
  popStyle() popMatrix()
  if not gPaused then
    if self.dest=="left" then
      self.body.x=self.body.x-self.speed 
    elseif self.dest=="right" then
      self.body.x=self.body.x+self.speed
    end
    if self.body.x>WIDTH or self.body.x<0 then self.expired=true end
  end
end

function Nasty:touched(touch)
end

Pulse = Pulse or class()

function Pulse:init(x,dest)
self.pulseowner=x
  self.parent=x
  --print("pulse",self.pulseowner,self.parent)
  -- general pulse variables
  self.object="pulse" self.kind="pulse"
  if self.parent.name=="left" then
    if game.type==3 or game.type==2 then
      self.speed=gPulseSpeed
    elseif game.type==1 then
      self.speed=-gPulseSpeed
    end
  end
  if self.parent.name=="right" then
    if game.type==1 or game.type==2 then
      self.speed=gPulseSpeed
    elseif game.type==3 then
      self.speed=-gPulseSpeed
    end
  end
  self.mydelta=0
  self.count=1
  self.framedelta=.08
  self.frames={}
  for i=1,7 do
    self.frames[i]="Dropbox:p"..i
  end

  self.expired=false
  --physics for pulse
  self.body=physics.body(CIRCLE,gPulseSize/2*gPulsePhysicsRatio)

  self.body.object="pulse"
  self.body.kind="pulse"
  self.body.parent=self
  self.body.mypulse=self
  self.body.pulseowner=self.pulseowner
  self.body.gravityScale=0
  self.body.sensor=true
  self.body.friction=0
  self.body.linearVelocity=vec2(0,0)
  self.body.x=x.body.x
  self.body.y=x.body.y
end

function Pulse:draw()
  --print(self.pulsespeed)
  pushMatrix() pushStyle()
  --increment cumulative time for animation frame change

  if not gPaused then
    self.mydelta=self.mydelta+DeltaTime
    --check to see if its time for another frame and cycle it after last frame
    if self.mydelta>self.framedelta then
      self.mydelta = self.mydelta - self.framedelta
      self.count=self.count+1
      if self.count>7 then self.count=1 end
    end
  end
  translate(self.body.x,self.body.y)
  if self.parent.name=="right" then
    if game.type==3 then rotate(180) end
  end
  if self.parent.name=="left" then
    if game.type==1 then rotate(180) end
  end
  spriteMode(CENTER)
  tint(255,255,255,200)
  sprite(self.frames[self.count],0,0,gPulseSize)
  noTint()
  popStyle() popMatrix()
  if not gPaused then
  self.body.x=self.body.x+self.speed
  if self.body.x>WIDTH or self.body.x<0 then self.expired=true end
  end
end

function Pulse:touched(touch)
-- Codea does not automatically call this method
end
        