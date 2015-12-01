Obstacle=Obstacle or class()

function Obstacle:init(object,x,y,dest)
  self.object=object
  self.kind="obstacle"
  self.alpha=255
  -- print("lightpole?",self.object)
  self.dest=dest
  self.expired=false
  self.index={}
  self.frames={}
  self.mydelta=0
  self.count=1
  if self.object==1 then
    self.drawwidth=gObstacle1Size
    if self.dest=="left" then self.framecount=1
    elseif self.dest=="right" then self.framecount=1
    end
    for i=1,self.framecount do
      if self.dest=="left" then
        self.frames[i]="Dropbox:lightpolel"..i
      elseif self.dest=="right" then
        self.frames[i]="Dropbox:lightpoler"..i
      end
    end
    if self.dest=="left" then
      self.framedelta=.03
      self.speed=1
      self.verticalspeed=0
      self.maxvertical=0
      self.width,self.height=spriteSize("Dropbox:lightpolel1")
      local w=self.width
      local h=self.height
      self.body=physics.body(POLYGON,vec2(w*0.80,h*0.00),vec2(w*0.98,h*0.00),vec2(w*0.98,h*0.83),vec2(w*0.81,h*0.83),vec2(w*0.65,h*0.89),vec2(w*0.49,h*0.93),vec2(w*0.45,h*0.97),vec2(w*0.33,h*1.00),vec2(w*0.19,h*1.00),vec2(w*0.02,h*0.99),vec2(w*0.00,h*0.96),vec2(w*0.16,h*0.93),vec2(w*0.30,h*0.93),vec2(w*0.35,h*0.92),vec2(w*0.42,h*0.92),vec2(w*0.65,h*0.85),vec2(w*0.86,h*0.74))
    elseif self.dest=="right" then
      self.framedelta=.03
      self.speed=1
      self.verticalspeed=0
      self.maxvertical=0
      self.width,self.height=spriteSize("Dropbox:lightpoler1")
      local w=self.width
      local h=self.height
      self.body=physics.body(POLYGON,vec2(w*0.20,h*0.00),vec2(w*0.02,h*0.00),vec2(w*0.02,h*0.83),vec2(w*0.19,h*0.83),vec2(w*0.35,h*0.89),vec2(w*0.51,h*0.93),vec2(w*0.55,h*0.97),vec2(w*0.67,h*1.00),vec2(w*0.81,h*1.00),vec2(w*0.98,h*0.99),vec2(w*1.00,h*0.96),vec2(w*0.84,h*0.93),vec2(w*0.70,h*0.93),vec2(w*0.65,h*0.92),vec2(w*0.58,h*0.92),vec2(w*0.35,h*0.85),vec2(w*0.14,h*0.74))
    end
    self.body.x = x
    self.body.y = y
    self.body.object = object
    self.body.gravityScale=0
    self.body.sensor=true
    self.body.friction=0
    self.body.linearVelocity=vec2(0,0)
    self.body.parent=self
  end
  if self.object==2 then
    self.drawwidth=gObstacle2Size
    if self.dest=="left" then
      self.framecount=1
    elseif self.dest=="right" then
      self.framecount=1
    end
    for i=1,self.framecount do
      if self.dest=="left" then
        self.frames[i]="Dropbox:rubbishbinl"..i
      elseif self.dest=="right" then
        self.frames[i]="Dropbox:rubbishbinr"..i
      end
    end
    if self.dest=="left" then 
      self.framedelta=.03
      self.speed=1
      self.verticalspeed=0
      self.maxvertical=0
      self.width,self.height=spriteSize("Dropbox:rubbishbinl1")
      local w=self.drawwidth
      local h=self.drawwidth/self.width*self.height
      self.body=physics.body(POLYGON,vec2(0,0),vec2(w,0),vec2(w,h),vec2(0,h))
    elseif self.dest=="right" then
      self.framedelta=.03
      self.speed=1
      self.verticalspeed=0
      self.maxvertical=0
      self.width,self.height=spriteSize("Dropbox:rubbishbinr1")
      local w=self.drawwidth
      local h=self.drawwidth/self.width*self.height
      self.body=physics.body(POLYGON,vec2(0,0),vec2(w,0),vec2(w,h),vec2(0,h))
    end
    self.body.x = x
    self.body.y = y
    self.body.gravityScale=0
    self.body.object=object
    self.body.sensor=true
    self.body.friction=0
    self.body.linearVelocity=vec2(0,0)
    self.body.parent=self
  end
  
    if self.object==3 then
      self.drawwidth=gObstacle3Size
      if self.dest=="left" then
        self.framecount=1
        self.framedelta=.03
        self.speed=.6
        self.verticalspeed=-math.random(7,15)/10
        self.maxvertical=175
        self.width,self.height=spriteSize("Dropbox:cranehook1")
        local w=self.width
        local h=self.height
        self.body=physics.body(POLYGON,vec2(w*0.53,h*0.00),vec2(w*0.83,h*0.02),vec2(w*0.95,h*0.08),vec2(w*0.85,h*0.13),vec2(w*0.66,h*0.17),vec2(w*0.80,h*0.19),vec2(w*1.00,h*0.35),vec2(w*1.00,h*0.38),vec2(w*0.90,h*0.42),vec2(w*0.90,h*1.00),vec2(w*0.08,h*1.00),vec2(w*0.08,h*0.42),vec2(w*0.00,h*0.38),vec2(w*0.02,h*0.35),vec2(w*0.32,h*0.20),vec2(w*0.42,h*0.18),vec2(w*0.15,h*0.12),vec2(w*0.10,h*0.07),vec2(w*0.19,h*0.03),vec2(w*0.37,h*0.01))
  
      elseif self.dest=="right" then
        self.framecount=1
        self.framedelta=.03
        self.speed=.6
        self.verticalspeed=-math.random(7,15)/10
        self.maxvertical=175
        self.width,self.height=spriteSize("Dropbox:cranehook1")
        local w=self.width
        local h=self.height
        self.body=physics.body(POLYGON,vec2(w*0.53,h*0.00),vec2(w*0.83,h*0.02),vec2(w*0.95,h*0.08),vec2(w*0.85,h*0.13),vec2(w*0.66,h*0.17),vec2(w*0.80,h*0.19),vec2(w*1.00,h*0.35),vec2(w*1.00,h*0.38),vec2(w*0.90,h*0.42),vec2(w*0.90,h*1.00),vec2(w*0.08,h*1.00),vec2(w*0.08,h*0.42),vec2(w*0.00,h*0.38),vec2(w*0.02,h*0.35),vec2(w*0.32,h*0.20),vec2(w*0.42,h*0.18),vec2(w*0.15,h*0.12),vec2(w*0.10,h*0.07),vec2(w*0.19,h*0.03),vec2(w*0.37,h*0.01))
      end
      for i=1,self.framecount do
        if self.dest=="left" then
          self.frames[i]="Dropbox:cranehook"..i
        elseif self.dest=="right" then
          self.frames[i]="Dropbox:cranehook"..i
        end
      end
      self.body.x = x
      self.body.y = y
      self.body.gravityScale=0
      self.body.object=object
      self.body.sensor=true
      self.body.friction=0
      self.body.linearVelocity=vec2(0,0)
      self.body.parent=self
      self.body.type=KINEMATIC
   end
   
      self.body.kind="obstacle"
end

function Obstacle:draw()
    pushMatrix() pushStyle()
    if not gPaused then
    self.mydelta=self.mydelta+DeltaTime
    if self.mydelta>self.framedelta then
        self.mydelta=self.mydelta-self.framedelta
        self.count=self.count+1
        if self.count>self.framecount then self.count=1 end
    end
    end
    translate(self.body.x,self.body.y)
    spriteMode(CORNER)
    tint(255,255,255,self.alpha)
    sprite(self.frames[self.count],0,0,self.drawwidth)
    noTint()
    popStyle() popMatrix()
    if self.body2~=nil then
    --print(self.body.x,self.body.y,self.body2.x,self.body2.y)
      pushMatrix() pushStyle()
      translate(self.body2.x,self.body2.y)
      fill(255,255,255,255)
      ellipse(0,0,gHookRadius*2)
      popMatrix() popStyle()
    end
    if self.body.shapeType == POLYGON and gDrawPolygons then
        strokeWidth(1.0)
        local points=self.body.points
        local a,b
        for i,j in pairs(points) do
            --local points = body.points
            for j = 1,#points do
                a = points[j]
                b = points[(j % #points)+1]
                line(self.body.x+a.x, self.body.y+a.y, self.body.x+b.x,self.body.y+ b.y)
            end
        end
    end
    pushMatrix()
    translate(self.body.x+self.width/2,self.body.y)
    ellipse(0,0,10)
    popMatrix()
  if not gPaused then
    if self.dest=="left" then
      self.body.x=self.body.x-self.speed
    elseif self.dest=="right" then
      self.body.x=self.body.x+self.speed
    end
    self.body.y=self.body.y+self.verticalspeed
    if self.body.y>HEIGHT and self.object==3 then
      self.verticalspeed=-self.verticalspeed
      self.body.y=HEIGHT
    end
    if self.body.y<HEIGHT-self.maxvertical and self.object==3 then
      self.verticalspeed=-self.verticalspeed
      self.body.y=HEIGHT-self.maxvertical
    end
    if self.body.x<0-self.width or self.body.x>WIDTH then self.expired=true end --then self.expired=true end
  end
end

TweenObst = TweenObst or class()
function TweenObst:init(obst,a,b)
  obst.alpha=a
  tween.start(1,obst,{alpha=b},tween.easing.cubicIn,function() self.expired=true end)
end