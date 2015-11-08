 ##+##########################################################################
 #
 # package: rattleCAD    ->    lib_cv_custom.tcl
 #
 #   canvasCAD is software of Manfred ROSENBERGER
 #       based on tclTk, BWidgets and tdom on their
 #       own Licenses.
 #
 # Copyright (c) Manfred ROSENBERGER, 2010/10/24
 #
 # The author  hereby grant permission to use,  copy, modify, distribute,
 # and  license this  software  and its  documentation  for any  purpose,
 # provided that  existing copyright notices  are retained in  all copies
 # and that  this notice  is included verbatim  in any  distributions. No
 # written agreement, license, or royalty  fee is required for any of the
 # authorized uses.  Modifications to this software may be copyrighted by
 # their authors and need not  follow the licensing terms described here,
 # provided that the new terms are clearly indicated on the first page of
 # each file where they apply.
 #
 # IN NO  EVENT SHALL THE AUTHOR  OR DISTRIBUTORS BE LIABLE  TO ANY PARTY
 # FOR  DIRECT, INDIRECT, SPECIAL,  INCIDENTAL, OR  CONSEQUENTIAL DAMAGES
 # ARISING OUT  OF THE  USE OF THIS  SOFTWARE, ITS DOCUMENTATION,  OR ANY
 # DERIVATIVES  THEREOF, EVEN  IF THE  AUTHOR  HAVE BEEN  ADVISED OF  THE
 # POSSIBILITY OF SUCH DAMAGE.
 #
 # THE  AUTHOR  AND DISTRIBUTORS  SPECIFICALLY  DISCLAIM ANY  WARRANTIES,
 # INCLUDING,   BUT   NOT  LIMITED   TO,   THE   IMPLIED  WARRANTIES   OF
 # MERCHANTABILITY,    FITNESS   FOR    A    PARTICULAR   PURPOSE,    AND
 # NON-INFRINGEMENT.  THIS  SOFTWARE IS PROVIDED  ON AN "AS  IS" BASIS,
 # AND  THE  AUTHOR  AND  DISTRIBUTORS  HAVE  NO  OBLIGATION  TO  PROVIDE
 # MAINTENANCE, SUPPORT, UPDATES, ENHANCEMENTS, OR MODIFICATIONS.
 #
 # ---------------------------------------------------------------------------
 #    namespace:  rattleCAD::cv_custom
 # ---------------------------------------------------------------------------
 #
 #

 namespace eval rattleCAD::cv_custom {

            variable    bottomCanvasBorder  30
            variable    stageScale          1.0
            variable    stageRefit          yes

            variable    baseLine        ;  array set baseLine       {}

            variable    Rendering       ;  array set Rendering      {}
            variable    Reference       ;  array set Reference      {}
            
            variable    BottomBracket   ;  array set BottomBracket  {}
            variable    DownTube        ;  array set DownTube       {}
            variable    Fork            ;  array set Fork           {}
            variable    FrameJig        ;  array set FrameJig       {}
            variable    FrontBrake      ;  array set FrontBrake     {}
            variable    FrontWheel      ;  array set FrontWheel     {}
            variable    HandleBar       ;  array set HandleBar      {}
            variable    HeadTube        ;  array set HeadTube       {}
            variable    LegClearance    ;  array set LegClearance   {}
            variable    RearBrake       ;  array set RearBrake      {}
            variable    RearDrop        ;  array set RearDrop       {}
            variable    RearWheel       ;  array set RearWheel      {}
            variable    Saddle          ;  array set Saddle         {}
            variable    SaddleNose      ;  array set SaddleNose     {}
            variable    SeatPost        ;  array set SeatPost       {}
            variable    SeatStay        ;  array set SeatStay       {}
            variable    SeatTube        ;  array set SeatTube       {}
            variable    Steerer         ;  array set Steerer        {}
            variable    Stem            ;  array set Stem           {}
            variable    TopTube         ;  array set TopTube        {}

            variable    Position        ;  array set Position       {}
            variable    Length          ;  array set Length         {}
            variable    Vector          ;  array set Vector         {}

            
    proc unset_Position {} { 
          # removes all position settings of any canvas 
	    variable  Position
        array unset Position
    }

    proc get_FormatFactor {stageFormat} {
            puts ""
            puts "   -------------------------------"
            puts "    get_FormatFactor::update"
            puts "       stageFormat:     $stageFormat"
            switch -regexp $stageFormat {
                ^A[0-9] {    set factorInt    [expr 1.0 * [string index $stageFormat end] ]
                            return            [expr pow(sqrt(2), $factorInt)]
                        }
                default    {return 1.0}
            }
    }


    proc update_cv_Parameter {cv_Name BB_Position} {

            variable    stageScale

            variable    Rendering
            variable    Reference

            
            variable    BottomBracket
            variable    DownTube
            variable    Fork
            variable    FrameJig
            variable    FrontBrake
            variable    FrontWheel
            variable    HandleBar
            variable    HeadTube
            variable    HeadSet
            variable    LegClearance
            variable    RearBrake
            variable    RearDrop
            variable    RearWheel
            variable    Saddle
            variable    SaddleNose
            variable    SeatPost
            variable    SeatStay
            variable    SeatTube
            variable    Steerer
            variable    Stem
            variable    TopTube
            
            variable    Position
            variable    Length
            variable    Angle
            variable    Vector


                # --- get stageScale
            set stageScale        [ $cv_Name  getNodeAttr  Stage    scale ]


                # --- get Rendering Style
            set Rendering(BrakeFront)       [rattleCAD::control::getValue Rendering/Brake/Front]
            set Rendering(BrakeRear)        [rattleCAD::control::getValue Rendering/Brake/Rear]
            set Rendering(BottleCage_ST)    [rattleCAD::control::getValue Rendering/BottleCage/SeatTube]
            set Rendering(BottleCage_DT)    [rattleCAD::control::getValue Rendering/BottleCage/DownTube]
            set Rendering(BottleCage_DT_L)  [rattleCAD::control::getValue Rendering/BottleCage/DownTube_Lower]
            
            


                # --- get defining Values ----------
            set RearWheel(RimDiameter)      $bikeGeometry::RearWheel(RimDiameter)
            set RearWheel(TyreHeight)       $bikeGeometry::RearWheel(TyreHeight)
            set FrontWheel(RimDiameter)     $bikeGeometry::FrontWheel(RimDiameter)
            set FrontWheel(TyreHeight)      $bikeGeometry::FrontWheel(TyreHeight)
            set Fork(Height)                $bikeGeometry::Fork(Height)
            set Fork(Rake)                  $bikeGeometry::Fork(Rake)
            set Stem(Length)                $bikeGeometry::Stem(Length)
            set Stem(Angle)                 $bikeGeometry::Stem(Angle)
            set BottomBracket(depth)        $bikeGeometry::BottomBracket(depth)
            set RearDrop(OffsetSSPerp)      $bikeGeometry::RearDrop(OffsetSSPerp)
            set RearDrop(OffsetCSPerp)      $bikeGeometry::RearDrop(OffsetCSPerp)
            set SeatTube(OffsetBB)          $bikeGeometry::SeatTube(OffsetBB)
            set DownTube(OffsetBB)          $bikeGeometry::DownTube(OffsetBB)


                # --- get Reference Values
            set Reference(HandleBar)        [ bikeGeometry::get_Object     Reference_HB        position    $BB_Position ]
            set Reference(SaddleNose)       [ bikeGeometry::get_Object     Reference_SN        position    $BB_Position ]


                # --- get defining Point coords ----------
            set BottomBracket(Position)       $BB_Position
            set RearWheel(Position)         [ bikeGeometry::get_Object     RearWheel           position    $BB_Position ]
            set FrontWheel(Position)        [ bikeGeometry::get_Object     FrontWheel          position    $BB_Position ]
            set SeatPost(Saddle)            [ bikeGeometry::get_Object     SeatPostSaddle      position    $BB_Position ]
            set SeatPost(PivotPosition)     [ bikeGeometry::get_Object     SeatPostPivot       position    $BB_Position ]
            set SeatPost(SeatTube)          [ bikeGeometry::get_Object     SeatPostSeatTube    position    $BB_Position ]
            set Saddle(Position)            [ bikeGeometry::get_Object     Saddle              position    $BB_Position ]
            set Saddle(Proposal)            [ bikeGeometry::get_Object     SaddleProposal      position    $BB_Position ]
            set SeatStay(SeatTube)          [ bikeGeometry::get_Object     SeatStay/End        position    $BB_Position ]
            set TopTube(SeatTube)           [ bikeGeometry::get_Object     TopTube/Start       position    $BB_Position ]
            set TopTube(Steerer)            [ bikeGeometry::get_Object     TopTube/End         position    $BB_Position ]
            set HeadTube(Stem)              [ bikeGeometry::get_Object     HeadTube/End        position    $BB_Position ]
            set HeadTube(Fork)              [ bikeGeometry::get_Object     HeadTube/Start      position    $BB_Position ]
            set Steerer(Stem)               [ bikeGeometry::get_Object     Steerer/End         position    $BB_Position ]
            set Steerer(Fork)               [ bikeGeometry::get_Object     Steerer/Start       position    $BB_Position ]
            set DownTube(Steerer)           [ bikeGeometry::get_Object     DownTube/End        position    $BB_Position ]
            set DownTube(BBracket)          [ bikeGeometry::get_Object     DownTube/Start      position    $BB_Position ]
            set HandleBar(Position)         [ bikeGeometry::get_Object     HandleBar           position    $BB_Position ]
            set SeatTube(TopTube)           [ bikeGeometry::get_Object     SeatTube/End        position    $BB_Position ]
            set SeatTube(Saddle)            [ bikeGeometry::get_Object     SeatTubeSaddle      position    $BB_Position ]
            set SeatTube(BBracket)          [ bikeGeometry::get_Object     SeatTube/Start      position    $BB_Position ]
            set SeatStay(End)               [ bikeGeometry::get_Object     SeatStay/End        position    $BB_Position ]
            set SeatTube(Ground)            [ bikeGeometry::get_Object     SeatTubeGround      position    $BB_Position ]
            set Steerer(Ground)             [ bikeGeometry::get_Object     SteererGround       position    $BB_Position ]
            set Position(BaseCenter)        [ bikeGeometry::get_Object     BottomBracketGround position    $BB_Position ]

            set RearBrake(Mount)            [ vectormath::addVector        $bikeGeometry::RearBrake(Mount)       $BB_Position ]
            set RearBrake(Help)             [ vectormath::addVector        $bikeGeometry::RearBrake(Help)        $BB_Position ]
            set RearBrake(Shoe)             [ vectormath::addVector        $bikeGeometry::RearBrake(Shoe)        $BB_Position ]
            set RearBrake(Definition)       [ vectormath::addVector        $bikeGeometry::RearBrake(Definition)  $BB_Position ]
            set FrontBrake(Mount)           [ vectormath::addVector        $bikeGeometry::FrontBrake(Mount)      $BB_Position ]
            set FrontBrake(Help)            [ vectormath::addVector        $bikeGeometry::FrontBrake(Help)       $BB_Position ]
            set FrontBrake(Shoe)            [ vectormath::addVector        $bikeGeometry::FrontBrake(Shoe)       $BB_Position ]
            set FrontBrake(Definition)      [ vectormath::addVector        $bikeGeometry::FrontBrake(Definition) $BB_Position ]

              # set FrameJig(HeadTube)      [ vectormath::addVector        $bikeGeometry::FrameJig(HeadTube)     $BB_Position ]
              # set FrameJig(SeatTube)      [ vectormath::addVector        $bikeGeometry::FrameJig(SeatTube)     $BB_Position ]
            set LegClearance(Position)      [ vectormath::addVector        $bikeGeometry::LegClearance(Position) $BB_Position ]
            set SaddleNose(Position)        [ vectormath::addVector        $bikeGeometry::Saddle(Nose)           $BB_Position ]
            set Position(IS_ChainSt_SeatSt) [ bikeGeometry::get_Object     ChainStay/SeatStay_IS   position        $BB_Position ]

            set Length(CrankSet)            [rattleCAD::control::getValue Component/CrankSet/Length]


                # --- help points for boot clearance -----
            set vct_90                      [ vectormath::unifyVector   $BottomBracket(Position)    $FrontWheel(Position) ]
            set Position(help_91)           [ vectormath::addVector     $BottomBracket(Position)    [ vectormath::unifyVector {0 0} $vct_90 $Length(CrankSet) ] ]
            set Position(help_92)           [ vectormath::addVector     $FrontWheel(Position)       [ vectormath::unifyVector {0 0} $vct_90 [ expr - ( 0.5 * $FrontWheel(RimDiameter) + $FrontWheel(TyreHeight)) ] ] ]
            set Position(help_93)           [ vectormath::addVector     $BottomBracket(Position)    [ vectormath::unifyVector $Saddle(Position) $BottomBracket(Position) $Length(CrankSet) ] ]
            # set Position(help_94)                $SeatTube(Saddle)
            # set Position(help_94)                [ vectormath::intersectPoint [list -500 [lindex $Saddle(Position) 1]] $Saddle(Position)  $BottomBracket(Position) $SeatPost(SeatTube) ]
            # set TopTube(SeatVirtual)    [ vectormath::intersectPoint [list -500 [lindex $TopTube(Steerer) 1]] $TopTube(Steerer)  $BottomBracket(Position) $SeatPost(SeatTube) ]

            set RearWheel(Ground)           [ list [lindex $RearWheel(Position)  0] [lindex $Steerer(Ground) 1] ]
            set FrontWheel(Ground)          [ list [lindex $FrontWheel(Position) 0] [lindex $Steerer(Ground) 1] ]


                # --- geometry for tubing dimension -----
            set HeadTube(Diameter)      $bikeGeometry::HeadTube(Diameter)
            set HeadTube(polygon)       [ bikeGeometry::get_Object HeadTube polygon $BB_Position ]
                set pt_01                   [ bikeGeometry::coords_get_xy $HeadTube(polygon) 2 ]
                set pt_02                   [ bikeGeometry::coords_get_xy $HeadTube(polygon) 1 ]
                set pt_03                   [ bikeGeometry::coords_get_xy $HeadTube(polygon) 3 ]
                set pt_04                   [ bikeGeometry::coords_get_xy $HeadTube(polygon) 0 ]
            set HeadTube(vct_Top)       [ list $pt_01 $pt_02 ]
            set HeadTube(vct_Bottom)    [ list $pt_03 $pt_04 ]

            set SeatTube(Diameter)      $bikeGeometry::SeatTube(DiameterTT)
            set SeatTube(polygon)       [ bikeGeometry::get_Object SeatTube polygon $BB_Position  ]
                set pt_01                   [ bikeGeometry::coords_get_xy $SeatTube(polygon) 3 ]
                set pt_02                   [ bikeGeometry::coords_get_xy $SeatTube(polygon) 2 ]
            set SeatTube(vct_Top)       [ list $pt_01 $pt_02 ]

            set Steerer(Diameter)       30.0
                  # set   dir_01            [ split [ project::getValue Result(Tubes/Steerer/Direction)    direction ] ,]
				  # puts "   -> \$dir_01  $dir_01   [llength $dir_01]"
				set   dir_01                [ split [rattleCAD::control::getValue  Result/Tubes/Steerer/Direction/polar ] ,]
				set   dir_02                [ vectormath::VRotate $dir_01 -90 grad ]
                set   pt_01                 [ vectormath::addVector        $Steerer(Fork)  $dir_02 [expr -0.5 * $Steerer(Diameter)] ]
                set   pt_02                 [ vectormath::addVector        $Steerer(Fork)  $dir_02 [expr  0.5 * $Steerer(Diameter)] ]
            set Steerer(vct_Bottom)     [ list $pt_01 $pt_02 ]
            set Steerer(Start)          [ bikeGeometry::get_Object            Steerer/Start    position    $BB_Position  ]
            set Steerer(End)            [ bikeGeometry::get_Object            Steerer/End      position    $BB_Position  ]

            set HeadSet(Diameter)       $bikeGeometry::HeadSet(Diameter)
            set HeadSet(polygon)            [ bikeGeometry::get_Object HeadSet/Top polygon $BB_Position ]
                set   pt_01             [ vectormath::addVector        $Steerer(Fork)  $dir_02 [expr -0.5 * $HeadSet(Diameter)] ]
                set   pt_02             [ vectormath::addVector        $Steerer(Fork)  $dir_02 [expr  0.5 * $HeadSet(Diameter)] ]
            set HeadSet(vct_Bottom)     [ list $pt_01 $pt_02 ]
                set   pt_01                 [ bikeGeometry::coords_get_xy $HeadSet(polygon) 0 ]
                set   pt_02                 [ bikeGeometry::coords_get_xy $HeadSet(polygon) 7 ]
            set HeadSet(vct_Top)        [ list $pt_01 $pt_02 ]

            set TopTube(polygon)        [ bikeGeometry::get_Object TopTube  polygon $BB_Position ]
            set DownTube(polygon)       [ bikeGeometry::get_Object DownTube polygon $BB_Position ]

                # --- help points for virtual horizontal TopTube -----
                # set TopTube(SeatVirtual)    [ vectormath::intersectPoint [list -500 [lindex $TopTube(Steerer) 1]] $TopTube(Steerer)  $SeatTube(BBracket) $SeatPost(SeatTube) ]
            set TopTube(SeatVirtual)   [ bikeGeometry::get_Object             SeatTubeVirtualTopTube    position $BB_Position ]
                # puts "\n \$TopTube(SeatVirtual)  $TopTube(SeatVirtual)"


                # --- set values -------------------------
            set RearWheel(Radius)       [ expr [lindex $RearWheel(Position)  1] - [lindex $Position(BaseCenter) 1] ]
            set FrontWheel(Radius)      [ expr [lindex $FrontWheel(Position) 1] - [lindex $Position(BaseCenter) 1] ]
            set Length(Height_HB_Seat)  [ expr [lindex $Saddle(Position)     1] - [lindex $HandleBar(Position)  1] ]
            set Length(Height_HT_Seat)  [ expr [lindex $Saddle(Position)     1] - [lindex $HeadTube(Stem)       1] ]
            set Length(Length_BB_Seat)  [ expr [lindex $Saddle(Position)     0] - [lindex $Position(BaseCenter) 0] ]
    }


     #-------------------------------------------------------------------------
	     #  return BottomBracket coords
    proc get_BottomBracket_Position {cv_Name bottomCanvasBorder {updatePosition {recenter}} {option {bicycle}} {stageScale {}}} {
	    
	    variable  Position
	    
	    array set Stage          {}
	    array set FrontWheel     {}
	    array set RearWheel      {}
	    array set BottomBracket  {}
	    
          # set FrontWheel(Position)      [project::getValue Result(Position/FrontWheel)         position]
          # puts "  -> \$FrontWheel(Position)  $FrontWheel(Position)"
		set FrontWheel(Position)      [rattleCAD::control::getValue Result/Position/FrontWheel        position]	
		set FrontWheel(RimDiameter)   [rattleCAD::control::getValue Component/Wheel/Front/RimDiameter ]
        set FrontWheel(TyreHeight)    [rattleCAD::control::getValue Component/Wheel/Front/TyreHeight ]
        set FrontWheel(Radius)        [expr 0.5 * $FrontWheel(RimDiameter) + $FrontWheel(TyreHeight)] 
                    
        set RearWheel(Position)       [rattleCAD::control::getValue Result/Position/RearWheel    position]
        set RearWheel(RimDiameter)    [rattleCAD::control::getValue Component/Wheel/Rear/RimDiameter ]
        set RearWheel(TyreHeight)     [rattleCAD::control::getValue Component/Wheel/Front/TyreHeight ]
        set RearWheel(Radius)         [expr 0.5 * $RearWheel(RimDiameter) + $RearWheel(TyreHeight)] 
        set RearWheel(Distance_X)     [rattleCAD::control::getValue Result/Length/RearWheel/horizontal ]
        
        set BottomBracketDepth        [rattleCAD::control::getValue  Custom/BottomBracket/Depth ]
        set BottomBracketHeight       [expr $RearWheel(Radius) - $BottomBracketDepth]
        set FrameSize          [split [rattleCAD::control::getValue Result/Position/SummarySize  position] ,]
        set SummaryLength             [lindex $FrameSize 0]
        
        
          # puts "  -> \$updatePosition $updatePosition"
        if {![info exists Position($cv_Name)]} {
           set updatePosition {recenter}
        }
          # puts "  -> \$updatePosition $updatePosition"
        if {$updatePosition != {recenter}} {
                # puts "       <I> ... "
                # puts "       <I> ...    $bottomCanvasBorder"
                # puts "       <I> ... last value:$Position($cv_Name)"
            set Stage(scale_curr)   [ eval $cv_Name getNodeAttr Stage  scale ]
            set lastPos_x              [lindex $Position($cv_Name) 0]
            set lastPos_y              [lindex $Position($cv_Name) 1]
            set lastPosition  [list $lastPos_x $lastPos_y ]
            
            set lastHeight             [lindex $Position($cv_Name) 2]
                # puts "       <I> .......... lastHeight: $lastHeight"
            set newHeight              [expr $RearWheel(Radius) - $BottomBracketDepth ]
                # puts "       <I> ........... newHeight:  $newHeight"
            set diffHeight             [expr $lastHeight - $newHeight] 
                # puts "       <I> .......... diffHeight: $diffHeight"
                     
            set newPosition [list $lastPos_x [expr $lastPos_y - $diffHeight] ]
                # puts "       <I> ........ newPosition:  $newPosition"
            return $newPosition
        }	    

	      
          # puts "     ... \$FrontWheel(Position)     $FrontWheel(Position)"
	      # puts "     ... \$FrontWheel(RimDiameter)  $FrontWheel(RimDiameter)"
	      # puts "     ... \$FrontWheel(TyreHeight)   $FrontWheel(TyreHeight)"
	      # puts "     ... \$FrontWheel(Radius)       $FrontWheel(Radius)"
	      # puts ""
	      # puts "     ... \$RearWheel(Position)      $RearWheel(Position)"
	      # puts "     ... \$RearWheel(RimDiameter)   $RearWheel(RimDiameter)"
	      # puts "     ... \$RearWheel(TyreHeight)    $RearWheel(TyreHeight)"
	      # puts "     ... \$RearWheel(Radius)        $RearWheel(Radius)"
	      # puts "     ... \$RearWheel(Distance_X)    $RearWheel(Distance_X)"
	      # puts ""
	      # puts "     ... \$BottomBracketDepth       $BottomBracketDepth"
	      # puts "     ... \$FrameSize                $FrameSize"

	    set SummaryLength        [ lindex $FrameSize 0 ]
	    if {$option == {bicycle}} {
            set SummaryLength    [ expr $SummaryLength + 2 * $RearWheel(Radius) ]
    	}

        #
        # --- debug
        # puts "----------------------------------------"
        # puts "   get_BottomBracket_Position:"
        # puts "        \$cv_Name               $cv_Name "
        # puts "        \$bottomCanvasBorder    $bottomCanvasBorder "
        # puts "        \$option                $option"
        # puts "        \$stageScale            $stageScale"


        #
        # --- get canvasCAD-Stage information
	    set Stage(width)        [ eval $cv_Name getNodeAttr Stage  width  ]
	    set Stage(scale_curr)   [ eval $cv_Name getNodeAttr Stage  scale ]
	    if {$stageScale != {}} {
		    set Stage(scale)        $stageScale
	    } else {
		    set Stage(scale)        [ expr 0.75 * $Stage(width) / $SummaryLength ]
	    }
	    set Stage(scale_fmt)    [ format "%.4f" $Stage(scale) ]
            # puts ""
            # puts "        \$SummaryLength         $SummaryLength"
            # puts "        \$Stage(scale_fmt)      $Stage(scale_fmt)"


        #
        # --- reset canvasCAD - scale to fit the content
	    $cv_Name    setNodeAttr Stage   scale   $Stage(scale_fmt)

        #
        # ---  get unscaled width of Stage
	    set Stage(unscaled)     [ expr ($Stage(width))/$Stage(scale_fmt) ]
            # puts "        \$Stage(unscaled)       $Stage(unscaled)"

        #
        # ---  get border outside content to Stage
	    set border              [ expr  0.5 *( $Stage(unscaled) - $SummaryLength ) ]
            # puts "        \$border                $border"

        #
        # ---  get left/right/bottom border outside content to Stage
	    set cvBorder            [ expr $bottomCanvasBorder/$Stage(scale_fmt) ]
            # puts "        \$cvBorder              $cvBorder"

        #
        # ---  get baseLine Coordinates
	    if {$option == {bicycle}} {
            set BtmBracket_x        [ expr $border + $RearWheel(Radius) + $RearWheel(Distance_X) ]
            set BtmBracket_y        [ expr $cvBorder + $BottomBracketHeight ]
                # puts "\n -> get_BottomBracket_Position:  $cvBorder + $RearWheel(Radius) - [rattleCAD::control::getValue Custom/BottomBracket/Depth] "
                # puts "\n -> get_BottomBracket_Position:  $BtmBracket_x $BtmBracket_y \n"
	    } else {
            # puts "        \$option                $option"
            set BtmBracket_x        [ expr $border + $RearWheel(Distance_X) ]
            set BtmBracket_y        $cvBorder
                # set BtmBracket_y      [ expr $bottomCanvasBorder + 50 ]
                # puts "\n -> get_BottomBracket_Position:  $cvBorder "
                # puts "\n -> get_BottomBracket_Position:  $BtmBracket_x $BtmBracket_y \n"
	    }

            # puts "       $BtmBracket_x $BtmBracket_y"
        set Position($cv_Name) [list $BtmBracket_x $BtmBracket_y $BottomBracketHeight]
	    return [lrange $Position($cv_Name) 0 1]
    }


    proc createCenterline {cv_Name BB_Position {extend_Saddle {}}} {

                # --- get stageScale
            set stageScale        [ $cv_Name  getNodeAttr  Stage    scale ]

                # --- get defining Point coords ----------
            set BottomBracket(Position)     $BB_Position
            set FrontWheel(Position)        [ bikeGeometry::get_Object     FrontWheel          position    $BB_Position ]
            set Saddle(Position)            [ bikeGeometry::get_Object     Saddle              position    $BB_Position ]
            set SeatStay(SeatTube)          [ bikeGeometry::get_Object     SeatStay/End        position    $BB_Position ]
            set SeatTube(Saddle)            [ bikeGeometry::get_Object     SeatTubeSaddle      position    $BB_Position ]
            set SeatTube(TopTube)           [ bikeGeometry::get_Object     SeatTube/End        position    $BB_Position ]
            set SeatStay(RearWheel)         [ bikeGeometry::get_Object     SeatStay/Start      position    $BB_Position ]
            set TopTube(SeatTube)           [ bikeGeometry::get_Object     TopTube/Start       position    $BB_Position ]
            set TopTube(Steerer)            [ bikeGeometry::get_Object     TopTube/End         position    $BB_Position ]
            set Steerer(Stem)               [ bikeGeometry::get_Object     Steerer/End         position    $BB_Position ]
            set Steerer(Fork)               [ bikeGeometry::get_Object     Steerer/Start       position    $BB_Position ]
            set DownTube(Steerer)           [ bikeGeometry::get_Object     DownTube/End        position    $BB_Position ]
            set DownTube(BBracket)          [ bikeGeometry::get_Object     DownTube/Start      position    $BB_Position ]
            set SeatTube(BBracket)          [ bikeGeometry::get_Object     SeatTube/Start      position    $BB_Position ]
            set HandleBar(Position)         [ bikeGeometry::get_Object     HandleBar           position    $BB_Position ]
            set Position(IS_ChainSt_SeatSt) [ bikeGeometry::get_Object     ChainStay/SeatStay_IS   position   $BB_Position ]

            set help_01                     [ vectormath::intersectPerp         $Steerer(Stem) $Steerer(Fork) $FrontWheel(Position) ]


            $cv_Name create centerline [ appUtil::flatten_nestedList  $Steerer(Stem)        $HandleBar(Position)    ] -fill gray60 -tags __CenterLine__
            $cv_Name create centerline [ appUtil::flatten_nestedList  $Steerer(Stem)        $help_01                ] -fill gray60 -tags __CenterLine__
            $cv_Name create centerline [ appUtil::flatten_nestedList  $FrontWheel(Position) $help_01                ] -fill gray60 -tags __CenterLine__
            $cv_Name create centerline [ appUtil::flatten_nestedList  $DownTube(BBracket)   $DownTube(Steerer)      ] -fill gray60 -tags __CenterLine__
            $cv_Name create centerline [ appUtil::flatten_nestedList  $TopTube(SeatTube)    $TopTube(Steerer)       ] -fill gray60 -tags __CenterLine__
            $cv_Name create centerline [ appUtil::flatten_nestedList  $SeatStay(SeatTube)   $Position(IS_ChainSt_SeatSt)    ] -fill gray60 -tags __CenterLine__
            $cv_Name create centerline [ appUtil::flatten_nestedList  $Position(IS_ChainSt_SeatSt)    $BottomBracket(Position)] -fill gray60 -tags __CenterLine__
            if {$extend_Saddle == {}} {
                $cv_Name create centerline [ appUtil::flatten_nestedList  $SeatTube(BBracket)    $SeatTube(TopTube) ] -fill gray60 -tags __CenterLine__
            } else {
                $cv_Name create centerline [ appUtil::flatten_nestedList  $SeatTube(BBracket)    $SeatTube(Saddle)  ] -fill gray60 -tags __CenterLine__
            }

                # puts "\n =================\n"
                # puts "    $SeatStay(SeatTube)    $SeatStay(RearWheel) "
                # puts "\n =================\n"
    }


    proc createLugRep {cv_Name BB_Position {type {all}}} {

        puts ""
        puts "   -------------------------------"
        puts "     createLugRep"
        puts "       cv_Name:         $cv_Name"
        puts "       BB_Position:     $BB_Position"
        puts "       checkAngles:     $rattleCAD::view::gui::checkAngles"

        if {$rattleCAD::view::gui::checkAngles != {on}} {
            puts "       ... currently switched off"
            return
        }

            proc createAngleRep {cv_Name position point_1 point_2 radius lugPath} {
                        # puts "          cv_Name       $cv_Name"
                        # puts "          position      $position"
                        # puts "          radius        $radius "
                        # puts "          lugPath       $lugPath"
                        # puts "          canvasDOMNode $canvasDOMNode"
                    set stagesScale [$cv_Name  getNodeAttr        Stage   scale]
                    set tagListName [format "checkAngle_%s" [llength [$cv_Name find withtag all]] ]

                        # puts "          stagesScale $stagesScale"

                    set angle_p1    [ vectormath::dirAngle $position $point_1 ]
                    set angle_p2    [ vectormath::dirAngle $position $point_2 ]
                    set angle_ext   [expr $angle_p2 - $angle_p1]
                        # puts "     angle_p1  -> $angle_p1"
                        # puts "     angle_p2  -> $angle_p2"
                        # puts "     angle_ext -> $angle_ext"
                    if {$angle_ext < 0 } {set angle_ext [expr $angle_ext +360]}

                      # set lugAngle        [project::getValue [format "%s/Angle/value)"        [string range $lugPath 0 end-1]] value]
                      # set lugTolerance    [project::getValue [format "%s/Angle/plus_minus)"   [string range $lugPath 0 end-1]] value]
                    set lugAngle        [rattleCAD::control::getValue  [format "%sAngle/value"        [string map {( /  ) /} $lugPath]]] 
                    set lugTolerance    [rattleCAD::control::getValue  [format "%sAngle/plus_minus"   [string map {( /  ) /} $lugPath]]] 
                      # puts "   -> \$lugAngle      $lugAngle                  [string map {( /  ) /} $lugPath]"
                      # puts "   -> \$lugTolerance  $lugTolerance"
					
                    set colour          [getColour   $angle_ext $lugAngle $lugTolerance]
                    set item            [$cv_Name  create   arc  $position    -radius $radius  -start $angle_p1  -extent $angle_ext -tags {ArcRep_01}  -fill $colour  -outline $colour  -style pieslice]
                    $cv_Name    addtag $tagListName withtag  $item

                    set textPosition    [vectormath::addVector $position [vectormath::rotatePoint {0 0} [list [expr $radius -20] 0] [expr $angle_p1 + 0.5*$angle_ext]]]
                    set item            [$cv_Name create text $textPosition -text [format "%.1f" $lugAngle] -anchor center -size [expr 2.5/$stagesScale]]
                    $cv_Name    addtag $tagListName withtag  $item

                    return $tagListName
            }
            proc getColour {currentAngle lugAngle lugTolerance} {
                        # puts "    --------"
                        # puts "          currentAngle  $currentAngle"
                        # puts "          lugAngle      $lugAngle"
                        # puts "          lugTolerance  $lugTolerance"
                    set difference [format "%.1f" [expr abs($currentAngle - $lugAngle)]]
                        # puts "          difference    $difference"
                        # puts "          lugTolerance  $lugTolerance"
                        # puts "          lugTolerance  [expr 0.5*$lugTolerance]"

                    if {$difference <= [expr 0.5*$lugTolerance] } {
                            set configColour {lightgrey}
                                # puts "          configColour  $configColour"
                            return $configColour
                    }
                    if {$difference <= $lugTolerance } {
                            set range [ expr 0.5 * $lugTolerance ]
                            set value [ expr $difference -$range ]
                            if {$range > 0 } {
                                set quote [ expr 100 * (1 - ($value / $range)) ]
                            } else {
                                set quote 100
                            }

                                # puts "      ----->  100 * (1 - ($value / $range)) = $quote"
                            set quote [expr round($quote)]

                                # puts "      ----->  100 * (1 - ($value / $range)) = $quote"
                                # set yellow [format %x [expr 90 + $quote]]
                                # puts "      ----->  $yellow"
                            set configColour [format "#ff%x00" [expr 120 + $quote]]

                                # puts "          configColour  $configColour"
                            return $configColour
                    }

                    set configColour {darkred}
                        # set configColour {orange}
                        puts "          configColour  $configColour"
                    return $configColour
            }


            # --- get defining Point coords ----------
        set BottomBracket(Position) $BB_Position
        set SeatStay(SeatTube)      [ bikeGeometry::get_Object     SeatStay/End        position    $BB_Position ]
        set TopTube(SeatTube)       [ bikeGeometry::get_Object     TopTube/Start       position    $BB_Position ]
        set TopTube(Steerer)        [ bikeGeometry::get_Object     TopTube/End         position    $BB_Position ]
        set Steerer(Stem)           [ bikeGeometry::get_Object     Steerer/End         position    $BB_Position ]
        set Steerer(Fork)           [ bikeGeometry::get_Object     Steerer/Start       position    $BB_Position ]
        set DownTube(Steerer)       [ bikeGeometry::get_Object     DownTube/End        position    $BB_Position ]
        set DownTube(BBracket)      [ bikeGeometry::get_Object     DownTube/Start      position    $BB_Position ]
        set ChainSt_SeatSt_IS       [ bikeGeometry::get_Object     ChainStay/SeatStay_IS   position    $BB_Position ]

        set represent_DO       [ createAngleRep $cv_Name $ChainSt_SeatSt_IS        $BottomBracket(Position)    $SeatStay(SeatTube)          70   Lugs(RearDropOut)  ]
        set represent_BB_01    [ createAngleRep $cv_Name $BottomBracket(Position)  $DownTube(Steerer)          $TopTube(SeatTube)           90   Lugs(BottomBracket/DownTube)  ]
        set represent_BB_02    [ createAngleRep $cv_Name $BottomBracket(Position)  $TopTube(SeatTube)          $ChainSt_SeatSt_IS           90   Lugs(BottomBracket/ChainStay) ]
        set represent_SL_01    [ createAngleRep $cv_Name $TopTube(SeatTube)        $BottomBracket(Position)    $TopTube(Steerer)            80   Lugs(SeatTube/TopTube)  ]
        set represent_SL_02    [ createAngleRep $cv_Name $SeatStay(SeatTube)       $ChainSt_SeatSt_IS          $BottomBracket(Position)     90   Lugs(SeatTube/SeatStay) ]
        set represent_HL_TT    [ createAngleRep $cv_Name $TopTube(Steerer)         $Steerer(Stem)              $TopTube(SeatTube)           80   Lugs(HeadTube/TopTube)  ]
        set represent_HL_DT    [ createAngleRep $cv_Name $DownTube(Steerer)        $BottomBracket(Position)    $Steerer(Fork)               90   Lugs(HeadTube/DownTube) ]



        $cv_Name bind   $represent_DO       <Double-ButtonPress-1> \
                            [list rattleCAD::view::createEdit  %x %y  $cv_Name  \
                                        {   Lugs(RearDropOut/Angle/value) \
                                            Lugs(RearDropOut/Angle/plus_minus) }                {Lug Specification:  RearDropout}]
        $cv_Name bind   $represent_BB_01    <Double-ButtonPress-1> \
                            [list rattleCAD::view::createEdit  %x %y  $cv_Name  \
                                        {   Lugs(BottomBracket/DownTube/Angle/value) \
                                            Lugs(BottomBracket/DownTube/Angle/plus_minus)  }    {Lug Specification:  Seat-/DownTube}]
        $cv_Name bind   $represent_BB_02    <Double-ButtonPress-1> \
                            [list rattleCAD::view::createEdit  %x %y  $cv_Name  \
                                        {   Lugs(BottomBracket/ChainStay/Angle/value) \
                                            Lugs(BottomBracket/ChainStay/Angle/plus_minus) }    {Lug Specification:  SeatTube/ChainStay}]
        $cv_Name bind   $represent_SL_01    <Double-ButtonPress-1> \
                            [list rattleCAD::view::createEdit  %x %y  $cv_Name  \
                                        {   Lugs(SeatTube/TopTube/Angle/value) \
                                            Lugs(SeatTube/TopTube/Angle/plus_minus) }           {Lug Specification:  Seat-/TopTube}]
        $cv_Name bind   $represent_SL_02    <Double-ButtonPress-1> \
                            [list rattleCAD::view::createEdit  %x %y  $cv_Name  \
                                        {   Lugs(SeatTube/SeatStay/Angle/value) \
                                            Lugs(SeatTube/SeatStay/Angle/plus_minus)
                                            Lugs(SeatTube/SeatStay/MiterDiameter)}             {Lug Specification:  SeatTube/SeatStay}]
        $cv_Name bind   $represent_HL_TT    <Double-ButtonPress-1> \
                            [list rattleCAD::view::createEdit  %x %y  $cv_Name  \
                                        {   Lugs(HeadTube/TopTube/Angle/value) \
                                            Lugs(HeadTube/TopTube/Angle/plus_minus) }            {Lug Specification:  Top-/HeadTube}]
        $cv_Name bind   $represent_HL_DT    <Double-ButtonPress-1> \
                            [list rattleCAD::view::createEdit  %x %y  $cv_Name  \
                                        {   Lugs(HeadTube/DownTube/Angle/value) \
                                            Lugs(HeadTube/DownTube/Angle/plus_minus) }            {Lug Specification:  Head-/DownTube}]

        $cv_Name bind   $represent_DO       <Enter>  \
                            [list tk_messageBox -message "Angle in range of \[Angle - Tolerance\] and \[Angle + Tolerance\]"]


        rattleCAD::view::gui::object_CursorBinding        $cv_Name    $represent_DO
        rattleCAD::view::gui::object_CursorBinding        $cv_Name    $represent_BB_01
        rattleCAD::view::gui::object_CursorBinding        $cv_Name    $represent_BB_02
        rattleCAD::view::gui::object_CursorBinding        $cv_Name    $represent_SL_01
        rattleCAD::view::gui::object_CursorBinding        $cv_Name    $represent_SL_02
        rattleCAD::view::gui::object_CursorBinding        $cv_Name    $represent_HL_TT
        rattleCAD::view::gui::object_CursorBinding        $cv_Name    $represent_HL_DT


    }


    proc createDraftingFrame {cv_Name DIN_Format scale projectFile date} {

            puts ""
            puts "   -------------------------------"
            puts "    rattleCAD::cv_custom::createDraftingFrame"
            puts "       cv_Name:         $cv_Name"
            puts "       DIN_Format:      $DIN_Format"
            puts "       projectFile:     $projectFile"

                # --- get stageScale
            set stageWidth  [ $cv_Name    getNodeAttr  Stage  width  ]
            set stageHeight [ $cv_Name    getNodeAttr  Stage  height ]
            set stageScale  [ $cv_Name    getNodeAttr  Stage  scale  ]

            set scaleFactor        [ expr 1 / $stageScale ]
                if {[expr round($scaleFactor)] == $scaleFactor} {
                    set formatScaleFactor        [ expr round($scaleFactor) ]
                } else {
                    set formatScaleFactor        [ format "%.1f" $scaleFactor ]
                }

            proc scale_toStage    {ptList factor} {
                return [ vectormath::scalePointList {0 0} $ptList $factor ]
            }

                # --- outer border
            set df_Border         5
            set df_Width        [ expr $stageWidth  - 2 * $df_Border ]
            set df_Height       [ expr $stageHeight - 2 * $df_Border ]
            set x_00              $df_Border
            set x_01            [ expr $df_Border + $df_Width ]
            set y_00              $df_Border
            set y_01            [ expr $df_Border + $df_Height]
            set border_Coords   [ list  $x_00 $y_00     $x_00 $y_01     $x_01 $y_01     $x_01 $y_00     $x_00 $y_00 ]
            set border_Coords   [ scale_toStage  $border_Coords $scaleFactor ]
            $cv_Name create draftLine $border_Coords        -fill black -width 0.7

                # --- title block
            set tb_Width          170
            set tb_Height           20
            set tb_BottomLeft   [ expr $stageWidth  - $df_Border  - $tb_Width ]
            set x_02            [ expr $df_Border + $tb_BottomLeft ]
            set y_02            [ expr $df_Border + $tb_Height     ]
            set border_Coords   [ list        $x_02 $y_00        $x_02 $y_02        $x_01 $y_02        $x_01 $y_00        $x_02 $y_00    ]
            set border_Coords   [ scale_toStage  $border_Coords $scaleFactor ]
            $cv_Name create draftLine $border_Coords        -fill black -width 0.7        ;# title block - border

            set y_03            [ expr $df_Border + 11     ]
            set line_Coords        [ list        $x_02 $y_03        $x_01 $y_03    ]
            set line_Coords        [ scale_toStage  $line_Coords $scaleFactor ]
            $cv_Name create draftLine $line_Coords            -fill black -width 0.7        ;# title block - horizontal line separator

            set x_03            [ expr $df_Border + $tb_BottomLeft + 18     ]
            set line_Coords        [ list        $x_03 $y_00        $x_03 $y_02    ]
            set line_Coords        [ scale_toStage  $line_Coords $scaleFactor ]
            $cv_Name create draftLine $line_Coords            -fill black -width 0.7        ;# title block - first left column separator

            set x_04            [ expr $df_Border + $tb_BottomLeft + 130     ]
            set y_04            [ expr $df_Border + 11     ]
            set line_Coords        [ list        $x_04 $y_04        $x_04 $y_02    ]
            set line_Coords        [ scale_toStage  $line_Coords $scaleFactor ]
            $cv_Name create draftLine $line_Coords            -fill black -width 0.7        ;# title block - second left column separator


                # --- create Text:
            set textSize            5
            set textHeight            [expr $textSize * $scaleFactor ]

                # --- create Text: DIN Format
            set textPos                [scale_toStage [list [expr $df_Border + $tb_BottomLeft +  5 ] [ expr $df_Border + 13.5 ] ]    $scaleFactor]
            set textText            "$DIN_Format"
            $cv_Name create draftText $textPos  -text $textText -size $textSize

                # --- create Text: Software & Version
            set textPos                [scale_toStage [list [expr $df_Border + $tb_BottomLeft + 128 ] [ expr $df_Border + 13.5 ] ]    $scaleFactor]
            set textText            [format "rattleCAD  V%s.%s" $::APPL_Config(RELEASE_Version) $::APPL_Config(RELEASE_Revision)]
            $cv_Name create draftText $textPos  -text $textText -size $textSize -anchor se

                # --- create Text: Scale
            set textPos                [scale_toStage [list [expr $df_Border + $tb_BottomLeft +   5 ] [ expr $df_Border +  3.0 ] ]    $scaleFactor]
            set textText            "1:$formatScaleFactor"
            $cv_Name create draftText $textPos  -text $textText -size $textSize

                # --- create Text: Project-File
            set textPos                [scale_toStage [list [expr $df_Border + $df_Width      -   2 ] [ expr $df_Border +  3.0 ] ]    $scaleFactor]
            set textText            [file tail $projectFile]
            $cv_Name create draftText $textPos  -text $textText -size $textSize -anchor se

                # --- create Text: Date
            set textPos                [scale_toStage [list [expr $df_Border + $df_Width      -   2 ] [ expr $df_Border + 14.0 ] ]    $scaleFactor]
            set textText            $date
            $cv_Name create draftText $textPos  -text $textText -size 2.5       -anchor se


            # puts "       stageWidth:      $stageWidth"
            # puts "       stageHeight:     $stageHeight"
            # puts "       stageScale:      $stageScale"
    }




    proc createWaterMark {cv_Name projectFile date} {

                # --- get stageScale
            set stageWidth          [ $cv_Name    getNodeAttr  Stage  width  ]
            set stageHeight         [ $cv_Name    getNodeAttr  Stage  height ]
            set stageScale          [ $cv_Name  getNodeAttr  Stage    scale  ]
            set stageFormat         [ $cv_Name  getNodeAttr  Stage  format ]

            set scaleFactor         [ expr 1 / $stageScale ]
                if {[expr round($scaleFactor)] == $scaleFactor} {
                    set formatScaleFactor   [ expr round($scaleFactor) ]
                } else {
                    set formatScaleFactor   [ format "%.1f" $scaleFactor ]
                }

            proc scale_toStage    {ptList factor} {
                return [ vectormath::scalePointList {0 0} $ptList $factor ]
            }
                        # --- create Text: Software & Version
                # set textPos                [scale_toStage [list [expr $df_Border + $df_Width      -   2 ] [ expr $df_Border +  3.0 ] ]    $scaleFactor]
            set textPos             [scale_toStage {7 4}    $scaleFactor]
            set textText            [format "%s  /  %s  / \[DIN %s\] /  rattleCAD  V%s.%s " $projectFile $date $stageFormat $::APPL_Config(RELEASE_Version) $::APPL_Config(RELEASE_Revision) ]
            $cv_Name create draftText $textPos  -text $textText -size 2.5 -anchor sw -fill gray20
                # $cv_Name create draftText $textPos  -text $textText -size 2.5 -anchor sw -fill gray30
                # $cv_Name create draftText $textPos  -text $textText -size 2.5 -anchor sw -fill gray80

    }


    proc update_renderCanvas {cv_Name {tubeColour {gray95}} {decoColour {gray98}} {decoColour2 {gray90}} {decoColour3 {gray95}} } {
                           # {cv_Name {tubeColour {gray95}} {decoColour {gray98}} {decoColour2 {gray90}}}
                #
            foreach cv_Item [$cv_Name find withtag __Frame__] {
                set cv_Type     [$cv_Name type $cv_Item]
                if {$cv_Type == {polygon}} {
                    $cv_Name itemconfigure  $cv_Item -fill $tubeColour
                }
            }
                #
            foreach cv_Item [$cv_Name find withtag __Decoration__] {
                set cv_Type     [$cv_Name type $cv_Item]
                if {$cv_Type == {polygon}} {
                    $cv_Name itemconfigure  $cv_Item -fill $decoColour
                }
            }
                #
            foreach cv_Item [$cv_Name find withtag {__Decoration__ && __Tyre__}] {
                $cv_Name itemconfigure  $cv_Item -fill $decoColour3
            }
            foreach cv_Item [$cv_Name find withtag {__Decoration__ && __Rim_02__}] {
                $cv_Name itemconfigure  $cv_Item -fill $decoColour
            }
            
            if { 0 == 1} {
                # dont know anymore, why there was an exception for saddle and handlebar ... 2013-05-10
                foreach cv_Item [$cv_Name find withtag {__Decoration__ && __HandleBar__}] {
                    puts "   .. debug Handlebar: [$cv_Name gettags $cv_Item]   ... $tubeColour"
                    if {$cv_Type == {polygon}} {
                        # $cv_Name itemconfigure  $cv_Item -fill $tubeColour
                    }
                }
                foreach cv_Item [$cv_Name find withtag {__Decoration__ && __Saddle__}] {
                    if {$cv_Type == {polygon}} {
                        $cv_Name itemconfigure  $cv_Item -fill $tubeColour
                    }
                }
            }
    }

    proc update_renderCenterline {cv_Name {lineWidth_00 {3.0}} {lineWidth_01 {3.0}}} {
                #
            #foreach tag {chainstay seattube steerer fork saddle rearWheel frontWheel baseLine} {}

            foreach cv_Item [$cv_Name find withtag "__CenterLine__ && baseLine"] {
                        # puts "        ->   [$cv_Name itemconfigure  $cv_Item -width]"
                    $cv_Name itemconfigure  $cv_Item -width $lineWidth_00
                        # puts "          -> [$cv_Name itemconfigure  $cv_Item -width]"
            }
            foreach cv_Item [$cv_Name find withtag "__CenterLine__  && baseLine"]       { $cv_Name itemconfigure  $cv_Item -width $lineWidth_00}
                # foreach cv_Item [$cv_Name find withtag "__CenterPoint__ && steererFork"]    { $cv_Name itemconfigure  $cv_Item -outline red -radius 15}
                # foreach cv_Item [$cv_Name find withtag "__CenterPoint__ && headtubeStem"]   { $cv_Name itemconfigure  $cv_Item -outline red -radius 15}
            foreach cv_Item [$cv_Name find withtag "__CenterPoint__ && personalBB"]     { $cv_Name delete  $cv_Item }
            foreach cv_Item [$cv_Name find withtag "__CenterPoint__ && personalHB"]     { $cv_Name delete  $cv_Item }
            foreach cv_Item [$cv_Name find withtag "__CenterPoint__ && personalSaddle"] { $cv_Name delete  $cv_Item }
    }


}