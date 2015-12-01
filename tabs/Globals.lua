function setglobals()
gDrawPolygons=false gAssetsUsed={"Dropbox:cranehook","Dropbox:brick1","Dropbox:brick2","Dropbox:brick3","Dropbox:brick4","Dropbox:insect1-l1","Dropbox:insect1-l2","Dropbox:insect1-l3","Dropbox:insect1-l4","Dropbox:insect1-l5","Dropbox:insect1-l6","Dropbox:insect1-l7","Dropbox:insect1-l8","Dropbox:insect1-r1","Dropbox:insect1-r2","Dropbox:insect1-r3","Dropbox:insect1-r4","Dropbox:insect1-r5","Dropbox:insect1-r6","Dropbox:insect1-r7","Dropbox:insect1-r8","Dropbox:insect2-l1","Dropbox:insect2-l2","Dropbox:insect2-l3","Dropbox:insect2-l4","Dropbox:insect2-r1","Dropbox:insect2-r2","Dropbox:insect2-r3","Dropbox:insect2-r4","Dropbox:l1","Dropbox:l1@2x","Dropbox:l2","Dropbox:l2@2x","Dropbox:l3","Dropbox:l3@2x","Dropbox:l4","Dropbox:l4@2x","Dropbox:l5","Dropbox:l5@2x","Dropbox:l6","Dropbox:l6@2x","Dropbox:l7","Dropbox:l7@2x","Dropbox:led0","Dropbox:led1","Dropbox:led2","Dropbox:led3","Dropbox:led4","Dropbox:led5","Dropbox:led6","Dropbox:led7","Dropbox:led8","Dropbox:led9","Dropbox:ledneg","Dropbox:lednil","Dropbox:lightpole","Dropbox:lightpolel1","Dropbox:lightpolel1@2x","Dropbox:lightpoler1","Dropbox:lightpoler1@2x","Dropbox:p1","Dropbox:p2","Dropbox:p3","Dropbox:p4","Dropbox:p5","Dropbox:p6","Dropbox:p7","Dropbox:pulse2","Dropbox:r1","Dropbox:r1@2x","Dropbox:r2","Dropbox:r2@2x","Dropbox:r3","Dropbox:r3@2x","Dropbox:r4","Dropbox:r4@2x","Dropbox:r5","Dropbox:r5@2x","Dropbox:r6","Dropbox:r6@2x","Dropbox:r7","Dropbox:r7@2x","Dropbox:rubbishbinl1","Dropbox:rubbishbinr1","Dropbox:splat1","Dropbox:splat2","Dropbox:splat3","Dropbox:splat4","Dropbox:splat5","Dropbox:splat6","Dropbox:splat7","Dropbox:splat8","Dropbox:splat9","Dropbox:splat10","Dropbox:stopwatch"}
    gtimelinedouble={{1,"TextHelpOn","Press and hold on left or right of the screen to raise the matching bat"},{1.3,"ImageOn","Dropbox:pressfinger"},{2.0,"Change","game.obstaclecurrent",0},{2.5,"Change","game.nastyattackrate",3},{5.5,"ImageOff"},{6,"TextHelpOn","A Quick Tap will fire a sonic pulse"},{6.3,"ImageOn","Dropbox:pressfingerup"},{7.3,"ImageOn","Dropbox:pressfinger"},{7.5,"ImageOn","Dropbox:pressfingerup"},{8.2,"ImageOn","Dropbox:pressfinger"},{8.3,"ImageOn","Dropbox:pressfingerup"},{9.8,"ImageOff"},{13.7,"TextHelpOn","Now avoid the light pole"},{6.8,"Change","game.obstaclerate",1},{10,"Change","game.nastyattackrate",3},{12,"Change","game.nastyattackrate",3},{4.5,"TextHelpOff"}} --{2,"Change","game.obstaclecurrent",0},,{12.0,"TextHelpOff"},{12.1,"TextHelpOn","And the crane!"},{12.4,"Change","game.obstaclerate",8},{18,"TextHelpOff"},{19,"Change","game.obstaclecurrent",3},{20,"Change","game.obstaclerate",10}}
    gDebugCounter=0
    gGameButtonFont="Noteworthy-Bold"
    gState="InProgress"
    gTutorial=true
    gPaused=false
    gScreenCentre={} gScreenCentre.x=WIDTH/2 gScreenCentre.y=HEIGHT/2
    gDebugFont="ArialRoundedMTBold"
    parameter.number("gBatSize",50,150,80)
    gBatPhysicsRatio=.7
    gBatLeftDoubleX=WIDTH/2-gBatSize
    gBatRightDoubleX=WIDTH/2+gBatSize
    gLeftObjectSourceX=0
    gRightObjectSourceX=WIDTH
    gBatSpawnTime=2
    gNastyMax=8
    gInsect1Size=20 gInsect1PhysicsRatio=.75 gInsect1Speed=1 gInsect1Score=10 gInsect2Score=10
    gInsect2Size=20 gInsect2PhysicsRatio=.75 gInsect2Speed=1.7
    gObstacleMax=4
    gObstacleIndMax=1
    gObstacle1Size=55 gObstacle2Size=60 gObstacle3Size=50
    gPulseSize=30 gPulseSpeed=5 gPulsePhysicsRatio=1
    gSplat1Size=30
    gFrameDelta=.08
    gFrameDeltaFast=.04
    gFrameDeltaSlow=.11
    gHookRadius=20
    gTimerPenalty=1 gPointRate=5
    parameter.number("gBatForce",1,200,36)
    parameter.number("gBatPush",20,100,25)
    gMaxDigits=5 gMaxScore=math.pow(10,5)
    gScoreWidthBig=28 gScoreWidthSmall=22
    gScoreBigScalar=1.4
    gScoreSpaceScalar=1
    gSoundOn=true
    gGameData={}
    gGameTitles={"Got your Back","Watch Your Aim","Head to Head"}
    gGameTitleSize=40
    gGameTitleFont="MarkerFelt-Wide"
    pushStyle()
    fontSize(gGameTitleSize) font(gGameTitleFont)
    gGameTitleWidest=0
    local wdth,hght
    for i=1,#gGameTitles do
      table.insert(gGameData,{i,gGameTitles[i],0,0,0,0,0,0})
      if readGlobalData("gametype_"..i.."_maximum") ==nil then
        saveGlobalData("gametype_"..i.."_maximum",0)
      end
      wdth,hght=textSize(gGameTitles[i])
      if wdth>gGameTitleWidest then gGameTitleWidest=wdth end
    end
    gGameTitleHeight=hght
    popStyle()
    gPaused=false
    gMaxScoreTint={x=0,y=255,z=0,a=255}
    gAlltimeMaxScoreTint={x=0,y=0,z=255,a=255}
    gMaxScorePulseTint={x=255,y=255,z=0,a=255}
end