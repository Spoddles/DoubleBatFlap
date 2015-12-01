--[[
-- function collide(c)
    --local bA=bodyA
    if c.state==BEGAN then 
        cbA=c.bodyA cbB=c.bodyB
        if cbA.object=="pulse" or cbB.object=="pulse" then
            if cbA.object=="pulse" then
                if cbB.object=="pulse"then
                    cbA.parent.expired=true
                    cbB.parent.expired=true
                elseif cbB.parent.object=="bat" then
                    if cbB.parent~=cbA.parent.parent then
                        cbA.parent.expired =true
                        cbA.parent.parent.parent.score[cbB.parent.name]:subscore(10,"pulse")
                        game:addscoretween(-10,cbB.x,cbB.y)
                    end
                elseif cbB.parent.object=="insect1" or cbB.parent.object=="insect2" then
                    cbA.parent.expired=true
                    cbB.parent.expired=true
                    table.insert(game.splats,Splat("splat1",cbB.x,cbB.y))
                    cbA.parent.parent.parent.score[cbA.parent.parent.name]:addscore(10,"splat")
                    game:addscoretween(10,cbB.x,cbB.y)
                end
            elseif cbB.object=="pulse" then
                if cbA.object=="pulse"then
                    cbA.parent.expired=true
                    cbB.parent.expired=true
                elseif cbA.parent.object=="bat" then
                    if cbA.parent~=cbB.parent.parent then
                        cbB.parent.expired =true
                        cbB.parent.parent.parent.score[cbA.parent.name]:subscore(10,"pulse")
                        game:addscoretween(-10,cbA.x,cbA.y)
                    end
                 elseif cbA.parent.object=="insect1" or cbA.parent.object=="insect2" then
                    cbA.parent.expired =true
                    cbB.parent.expired=true
                    
                    table.insert(game.splats,Splat("splat1",cbA.x,cbB.y))
                    cbB.parent.parent.parent.score[cbB.parent.parent.name]:addscore(10,"splat")
                    game:addscoretween(10,cbA.x,cbA.y)
                end
            end
        elseif cbA.object=="insect1" or cbA.object=="insect2" then
            if cbB.object=="bat" then
                cbA.parent.expired=true
                cbB.parent.parent.score[cbB.parent.name]:subscore(5,"nasty")
                game:addscoretween(-5,cbA.x,cbA.y)
            end
        elseif cbB.object=="insect1" or cbB.object=="insect2" then
            if cbA.object=="bat"then
                cbB.parent.expired=true
                cbA.parent.parent.score[cbA.parent.name]:subscore(5,"nasty")
                game:addscoretween(-5,cbB.x,cbB.y)
           	end
        end
	en
      ]]

--[[
function Dialog:draw()
    pushStyle() pushMatrix()
    local dialogimg=image(self.width,self.height)
    setContext(dialogimg)
    
    
    fill(0, 0, 0, 255)
    stroke(107, 212, 193, 255)
    strokeWidth(2)
    rectMode(CENTER)
    rect(0,0,self.width,self.height)
    textMode(CENTER)
    font("ArialRoundedMTBold")
    fontSize(50)
    textAlign(CENTER)
    fill(0, 255, 209, 255)
    textWrapWidth(self.width*.75)
    text(self.text,0,self.buttonrowheight)
    popMatrix() popStyle()
    pushMatrix() pushStyle()
    tint(25, 44, 41, 255)
    for i,j in pairs(self.mybuttons) do
        
        j:draw()
    end
    noTint()
    translate(self.location.x,self.location.y)--+self.buttonrowheight)
    popMatrix() popStyle()
    -- Codea does not automatically call this method
en
  ]]