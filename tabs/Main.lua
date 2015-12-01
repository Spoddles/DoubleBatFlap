-- Double Bat Flap

displayMode(FULLSCREEN)
supportedOrientations ( LANDSCAPE_ANY )
function setup()
  --backingMode( RETAINED  )
  local rs=os.clock()
  math.randomseed(rs*10000)
  setglobals()
  title=Title()
end

function draw()
  if gState=="Title" then
    title:draw()
  elseif gState=="InProgress" then
    game:draw()
  end
    --[[
  local fps = 1/DeltaTime
  pushMatrix() pushStyle()
  fill(255, 255, 255, 255)
  font("ArialMT") fontSize(18)
  translate(WIDTH/2,20) textAlign(CENTER) text(math.floor(fps).." fps.",0,0)
  popStyle() popMatrix()
      ]]
end

function touched(touch)

  if gState=="Title" then
    --print("title touch")
    title:touched(touch)
  elseif gState=="InProgress" then
    game:touched(touch)
  end
end

function collide(c)
  local cbA,cbB
  if c.state==BEGAN then 
    cbA=c.bodyA cbB=c.bodyB

    if cbA.kind=="pulse" or cbB.kind=="pulse" then
      if cbA.kind=="pulse" then
        if cbB.kind=="pulse"then
          --print(cbA.parent,cbA.pulseowner,cbB.parent,cbB.pulseowner)
          cbA.mypulse.expired=true
          cbB.mypulse.expired=true
        elseif cbB.parent.kind=="bat" and cbB.parent.alive==true then
          if cbB.parent~=cbA.parent.parent then
            cbA.parent.expired =true
            cbA.parent.parent.parent.score[cbB.parent.name]:subscore(10,"pulse")
            game:addscoretween(-10,cbB.x,cbB.y,1)
          end
        elseif cbB.parent.kind=="nasty" then
          --cbA.parent.expired=true
          --cbB.parent.expired=true
          cbA.mypulse.expired=true
          cbB.mynasty.expired=true
          
          --print("it worked")
          table.insert(game.splats,Splat(1,cbB.x,cbB.y))
          --cbA.parent.parent.parent.score[cbA.parent.parent.name]:addscore(10)
          cbA.mypulse.parent.parent.score[cbA.mypulse.parent.name]:addscore(10)
          game:addscoretween(10,cbB.x,cbB.y,1)
        elseif cbB.parent.kind=="obstacle" then
          cbA.parent.expired=true
        end
      else
        if cbA.kind=="pulse"then
          cbA.mypulse.expired=true
          cbB.mypulse.expired=true
        elseif cbA.parent.kind=="bat" and cbA.parent.alive==true then
          if cbA.parent~=cbB.parent.parent then
            cbB.parent.expired =true
            cbB.parent.parent.parent.score[cbA.parent.name]:subscore(10,"pulse")
            game:addscoretween(-10,cbA.x,cbA.y,1)
          end
        elseif cbA.parent.kind=="nasty" then
          cbA.mynasty.expired =true
          cbB.mypulse.expired=true

          table.insert(game.splats,Splat(1,cbA.x,cbB.y))
          cbB.parent.parent.parent.score[cbB.parent.parent.name]:addscore(10)
          game:addscoretween(10,cbA.x,cbA.y,1)
        elseif cbA.parent.kind=="obstacle" then
          cbB.parent.expired=true
        end
      end
    elseif cbA.kind=="nasty" or cbB.kind=="nasty" then
      if cbA.kind=="nasty" then
        if cbB.kind=="bat" and cbB.parent.alive==true then
          local sc
          if cbA.object==1 then
            sc=4
          elseif cbA.object==2 then
            sc=7
          end
          cbA.parent.expired=true
          cbB.parent.parent.score[cbB.parent.name]:subscore(sc,"nasty")
          game:addscoretween(-sc,cbA.x,cbA.y,1)
        end
      else
        if cbA.kind=="bat" and cbA.parent.alive==true then
          local sc
          if cbB.object==1 then
            sc=4
          elseif cbB.object==2 then
            sc=7
          end
          cbB.parent.expired=true
          cbA.parent.parent.score[cbA.parent.name]:subscore(sc,"nasty")
          game:addscoretween(-sc,cbB.x,cbB.y,1)
        end
      end
    elseif cbA.kind=="obstacle" or cbB.kind=="obstacle" then

      --print("Are we colliding?")
      if cbA.kind=="obstacle" then
        if cbB.kind=="bat" and cbB.parent.alive==true then
          --print("Houston we have a bat hitting an obstacle!")
          cbB.parent.alive=false
          cbB.parent.spawncounter=0
          cbB.parent.parent.score[cbB.parent.name]:subscore(30,"obstacle")
          game:addscoretween(-30,cbB.x,cbB.y,2)
        end
      else
        if cbA.kind=="bat" and cbA.parent.alive==true then
          cbA.parent.alive=false
          cbA.parent.spawncounter=0
          cbA.parent.parent.score[cbA.parent.name]:subscore(30,"obstacle")
          game:addscoretween(-5,cbA.x,cbA.y,2)
        end
      end
    end
  end
end
