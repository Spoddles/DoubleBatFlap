Bat = Bat or class()

function Bat:init(parent,name)
    self.name=name
    self.alive=true
    self.spawncounter=0
    self.timer=0
    self.score=0
    self.scoreactive=false
    self.touchdelta=0
    self.tapdelta=0
    self.count=1
    self.size=gBatSize
    self.framecount=7
    self.pulses={}
    self.frames={}
    self.parent=parent
    self.object="bat"
    self.kind="bat"
    self.lasttouch="None"
    self.mydelta=0
    self.framedelta=gFrameDelta
    self.body=physics.body(CIRCLE,gBatSize/2*gBatPhysicsRatio)
    self.body.object="bat"
    self.body.kind="bat"
    self.body.parent=self
    self.body.name=name
    self.body.sensor=false
    if self.name=="left" then
        if parent.type==3 or parent.type==2 then
            self.body.x=100 self.body.y=HEIGHT-gBatSize
            for i=1,self.framecount do
                self.frames[i]="Dropbox:l"..i
            end
        end
         if parent.type==1 then
            self.body.x=gBatLeftDoubleX self.body.y=HEIGHT-gBatSize
            for i=1,self.framecount do
                self.frames[i]="Dropbox:r"..i
            end
        end
        
        
    end
    if self.name=="right" then
    self.count=2
        if parent.type==3 then
            self.body.x=WIDTH-100 self.body.y=HEIGHT-gBatSize
            for i=1,self.framecount do
                self.frames[i]="Dropbox:r"..i
            end
        end
        if parent.type==1 or parent.type==2 then
            self.body.x=gBatRightDoubleX self.body.y=HEIGHT-gBatSize
            for i=1,self.framecount do
                self.frames[i]="Dropbox:l"..i
            end
        end
    end
end

function Bat:draw()
    pushMatrix() pushStyle()
    spriteMode(CENTER)
    translate(self.body.x,self.body.y)
    local spawnscalar
    if not self.alive then
        if self.spawncounter==0 then
            self.body.y=HEIGHT-gBatSize
        end
        self.spawncounter=self.spawncounter+DeltaTime
        spawnscalar=self.spawncounter/gBatSpawnTime
        if self.spawncounter>gBatSpawnTime then
            self.alive=true
            self.spawncounter=0
        else
            --tint(255,255,255,75+self.spawncounter/gBatSpawnTime*180)
        end
    else
    spawnscalar=1
    end
    sprite(self.frames[self.count],0,0,gBatSize*spawnscalar)
    noTint()
--    if not self.alive then
--    pushStyle()
--    fill(255,255,255,255-self.spawncounter/gBatSpawnTime*180)
--    ellipse(0,0,self.size)
--    popStyle()
--    end
    if not gPaused then
      local dt=DeltaTime
      self.tapdelta = self.tapdelta + dt
      self.mydelta=self.mydelta+dt
      if self.mydelta>self.framedelta then
          self.mydelta=self.mydelta-self.framedelta
          self.count=self.count+1
          if self.count>self.framecount then self.count=1 end --sound("Dropbox:flap") end
      end
    end
    popStyle() popMatrix()
end

function Bat:touched(touch)
    -- Codea does not automatically call this method
end
