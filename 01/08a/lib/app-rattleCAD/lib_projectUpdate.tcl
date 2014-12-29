 ##+##########################################################################
 #
 # package: rattleCAD    ->    lib_projectUpdate.tcl
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
 #    namespace:  rattleCAD::projectUpdate
 # ---------------------------------------------------------------------------
 #
 #

 
 namespace eval rattleCAD::update {
 
    package require appUtil 0.9

    
    #-------------------------------------------------------------------------
        #  store createEdit-widgets position
    variable _drag             ; array set _drag        {}
    variable _updateValue      ; array set _updateValue {}
    variable _editList         ; array set _editList    {}
    variable _editList_Index  0;
      
     

  

    #-------------------------------------------------------------------------
        #  create ProjectEdit Widget
        # proc createEdit { x y cv_Name updateCommand _arrayNameList {title {Edit:}}}
    proc createEdit { x y cv_Name _arrayNameList {title {Edit:}}} {

              # appUtil::get_procHierarchy
            
            variable _update
            variable _updateValue
            
                # appUtil::get_procHierarchy
                # appUtil::appDebug p
                # appUtil::appDebug f
            
            puts ""
            puts "   -------------------------------"
            puts "    createEdit"
            puts "       x / y:           $x / $y"
            puts "       cv_Name:         $cv_Name"
            puts "       title:           $title"
            if {[llength $_arrayNameList] > 1} {
                puts "       _arrayNameList:"
                foreach entry $_arrayNameList {
                    puts "                        $entry"
                }
            } else {
                puts "       _arrayNameList:  $_arrayNameList"
            }
            puts ""

            # project::remove_tracing


            set x_offset 20
            set domProject $::APPL_Config(root_ProjectDOM)
            set cv      [ $cv_Name getNodeAttr Canvas path]
            if { [catch { set cvEdit [frame $cv.f_edit -bd 2 -relief raised] } errorID ] } {
                    closeEdit $cv $cv.f_edit
                    set cvEdit [frame $cv.f_edit -bd 2 -relief raised]
            }
            # --- create Window ---
            $cv_Name addtag __cvEdit__ withtag $cvEdit
            $cv create window [expr $x + $x_offset] $y  -window $cvEdit  -anchor w -tags $cvEdit
            $cv_Name addtag __cvEdit__ withtag $cvEdit

            # $cv create window [expr $x + $x_offset] $y  -window $cvEdit  -anchor w -tags __cvEdit__

            # --- create WindowFrames ---
            set cvTitleFrame    [frame $cvEdit.f_title -bg gray60  ]
                # set cvTitleFrame       [frame $cvEdit.f_title   -bd 1 -relief flat -bg gray60]
            set cvContentFrame       [frame $cvEdit.f_content -bd 1 -relief sunken]
                    pack $cvTitleFrame $cvContentFrame -side top
                    pack configure $cvTitleFrame      -fill x -padx 2 -pady 2
                    pack configure $cvContentFrame    -fill both

            # --- cvContentFrame ---
            if {[llength $_arrayNameList] == 1 } {
                    pack forget $cvTitleFrame
                    set updateMode  value
                    set index       oneLine                    
                   
                    set key  [lindex $_arrayNameList 0]
                    
                    create_Config $cv $cv_Name $cvEdit $cvContentFrame $index $key
                    
            } else {
                    #
                # --- title definition ---
                    set cvTitle            [label  $cvTitleFrame.label -text "${title}"  -bg gray60  -fg white -font "Helvetica 8 bold" -justify left]
                        pack $cvTitle -side left
                    set    cvClose         [button $cvTitleFrame.close -image $rattleCAD::gui::iconArray(iconClose) -command "[namespace current]::closeEdit $cv $cvEdit"]
                        pack $cvClose -side right -pady 2
                    #
                # --- parameter to edit ---
                    set updateMode value
                    set index 0
                    foreach key  $_arrayNameList {
                        set index       [expr $index +1]
                        create_Config $cv $cv_Name $cvEdit $cvContentFrame $index $key
                    }
                    bind $cvTitleFrame     <ButtonPress-1>     [list [namespace current]::dragStart     %X %Y]
                    bind $cvTitleFrame     <B1-Motion>         [list [namespace current]::drag          %X %Y $cv $cvEdit]
                    bind $cvTitle          <ButtonPress-1>     [list [namespace current]::dragStart     %X %Y]
                    bind $cvTitle          <B1-Motion>         [list [namespace current]::drag          %X %Y $cv $cvEdit]
            }

            # --- reposition if out of canvas border ---
            set cv_width  [ winfo width  $cv ]
            set cv_height [ winfo height $cv ]
            update
            set id_bbox   [ $cv bbox $cvEdit ]
                # puts "   -> bbox $id_bbox"
            foreach {dx dy} {0 0} break
            if {[lindex $id_bbox 2] > [expr $cv_width  -4]} { set dx [expr $cv_width  - [lindex $id_bbox 2] -4] }
            if {[lindex $id_bbox 3] > [expr $cv_height -4]} { set dy [expr $cv_height - [lindex $id_bbox 3] -4] }
            $cv move $cvEdit $dx $dy
              # puts "  -> reposition $dx $dy"
    }
    
     
    #-------------------------------------------------------------------------
        #  createEdit - sub procedures 
    proc debug_compare {a b} {
        if {$a != $b} {
            appUtil::get_procHierarchy
            tk_messageBox -messager "   ... pleas check this:\n      $a $b"
        } else {
            puts "\n ... debug_compare:"
            puts   "       $a"
            puts   "       $b\n"
        }
    }    
          
    #-------------------------------------------------------------------------
        # create different kind of config lines
        # 
    proc create_Config {cv cv_Name cvEdit cvContentFrame index key} {
        variable _updateValue
            # appUtil::get_procHierarchy
        
            # puts "\n   ---------------------------------"
            # puts "    <01>    \$key $key"
        set listName "-"
        switch -glob $key {
            {list://*} {
                    set type      [string range $key 0 3] 
                    set keyValue  [string range $key 7 end]
                    foreach {_key _listName} [split $keyValue {@}] break
                    set key       [format "%s)" $_key]
                    set listName  [string range $_listName 0 end-1]                    
                 }       
            {file://*} -
            {text://*} { # file://Lugs(RearDropOut/File) -> Lugs(RearDropOut/File) 
                    set type      [string range $key 0 3] 
                    set key       [string range $key 7 end]
                }
            default    {
                    set type      {}
                }
        }
            # puts "    <02>    \$type   $type"
            # puts "    <02>    \$key    $key"
        foreach {_array _name path} [project::unifyKey $key] break
            # puts "    <03>    \$type   $type"
            # puts "    <03>    \$key    $key"
            # puts "    <03>    \$listName  $listName\n"

        
        foreach {_array _name path} [project::unifyKey $key] break
        set value       [project::getValue $key value]
        set _updateValue($path) $value
        
        set labelText   [format "%s ( %s )" $_array \
                                            [string trim [ string map {{/} { / }} $_name] " "] ]
                                                                                       
        switch -exact $type {
            {file} {
                    create_ListEdit SELECT_File \
                        $cv $cv_Name $cvEdit $cvContentFrame \
                        $index $labelText $path
            }
            {list} { 
                    create_ListEdit $listName \
                        $cv $cv_Name $cvEdit $cvContentFrame \
                        $index $labelText $path
            }
            {text} { 
                    create_TextEdit \
                        $cv $cv_Name $cvEdit $cvContentFrame \
                        $index $labelText $path
                }
            default    {
                    create_ValueEdit \
                        $cv $cv_Name $cvEdit $cvContentFrame \
                        $index $labelText $path            
            }
        }                                     
        
    }

         
    proc create_ValueEdit {cv cv_Name cvEdit cvContentFrame index labelText key} {

               # appUtil::get_procHierarchy

             eval set currentValue $[namespace current]::_updateValue($key)
               #
               # --- create cvLabel, cvEntry ---
             set    cvLabel [label  $cvContentFrame.label_${index} -text "${labelText} : "]
             set cvEntry [spinbox $cvContentFrame.value_${index} -textvariable [namespace current]::_updateValue($key) -justify right -relief sunken -width 10 -bd 1]
             $cvEntry configure -command \
                          "[namespace current]::change_ValueEdit [namespace current]::_updateValue($key) %d"
             if {$index == {oneLine}} {
                 set    cvClose [button $cvContentFrame.close -image $rattleCAD::gui::iconArray(iconClose) -command "[namespace current]::closeEdit $cv $cvEdit"]
                 grid    $cvLabel $cvEntry $cvClose -sticky news
             } else {
                 grid    $cvLabel $cvEntry -sticky news
             }
             grid configure $cvLabel  -padx 3 -sticky nws
             grid configure $cvEntry  -padx 2
               #
               # --- select entries content ---
                 if {$index == {oneLine}} {
                         focus $cvEntry
                         $cvEntry selection range 0 end
                 }
               #
               # --- define bindings ---
             bind $cvLabel   <ButtonPress-1>         [list [namespace current]::dragStart        %X %Y]
             bind $cvLabel   <B1-Motion>             [list [namespace current]::drag             %X %Y $cv $cvEdit]
             bind $cvEntry   <MouseWheel>            [list [namespace current]::bind_MouseWheel  [namespace current]::_updateValue($key)  %D]
             bind $cvEntry   <Return>                [list [namespace current]::updateConfig     $cv_Name $key $cvEntry]
             bind $cvEntry   <Leave>                 [list [namespace current]::updateConfig     $cv_Name $key $cvEntry]
             bind $cvEntry   <Double-ButtonPress-1>  [list [namespace current]::updateConfig     $cv_Name $key $cvEntry]
    }

    proc create_TextEdit {cv cv_Name cvEdit cvContentFrame index labelText key} {

             eval set currentValue $[namespace current]::_updateValue($key)
                 #
                 # --- create cvLabel, cvEntry ---
             set    cvLabel [label  $cvContentFrame.label_${index} -text "${labelText} : "]
             set cvEntry [entry  $cvContentFrame.value_${index} -textvariable [namespace current]::_updateValue($key)  -justify right  -relief sunken -bd 1  -width 10]
                 # set cvEntry [spinbox $cvContentFrame.value_${index} -textvariable [namespace current]::_updateValue($key) -justify right -relief sunken -width 10 -bd 1]
                 # $cvEntry configure -command \
                     "[namespace current]::change_ValueEdit [namespace current]::_updateValue($key) %d"
             if {$index == {oneLine}} {
                 set    cvClose [button $cvContentFrame.close -image $rattleCAD::gui::iconArray(iconClose) -command "[namespace current]::closeEdit $cv $cvEdit"]
                 grid    $cvLabel $cvEntry $cvClose -sticky news
                     # grid  $cvLabel $cvEntry $cvUpdate $cvClose -sticky news
             } else {
                 grid    $cvLabel $cvEntry -sticky news
                     # grid    $cvLabel $cvEntry $cvUpdate -sticky news
             }
             grid configure $cvLabel  -padx 3 -sticky nws
             grid configure $cvEntry  -padx 2
                 #
                 # --- select entries content ---
             if {$index == {oneLine}} {
                     focus $cvEntry
                     $cvEntry selection range 0 end
             }
                 #
                 # --- define bindings ---
             bind $cvLabel   <ButtonPress-1>         [list [namespace current]::dragStart       %X %Y]
             bind $cvLabel   <B1-Motion>             [list [namespace current]::drag            %X %Y $cv $cvEdit]
             #bind $cvEntry  <MouseWheel>            [list [namespace current]::bind_MouseWheel  [namespace current]::_updateValue($key)  %D]
             bind $cvEntry   <Return>                [list [namespace current]::updateConfig    $cv_Name $key $cvEntry]
             bind $cvEntry   <Leave>                 [list [namespace current]::updateConfig    $cv_Name $key $cvEntry]
             bind $cvEntry   <Double-ButtonPress-1>  [list [namespace current]::updateConfig    $cv_Name $key $cvEntry]
    }

    proc create_ListEdit {type cv cv_Name cvEdit cvContentFrame index labelText key} {


             eval set currentValue $[namespace current]::_updateValue($key)
                 #
                 # --- create listBox content ---
             switch -exact $type {
                     {SELECT_File} { puts "     createEdit::create_ListEdit::SELECT_File:"}
                     default       { puts "     currentValue: $currentValue" }
             }
             set listBoxContent [ get_listBoxContent $type $key]
             foreach entry $listBoxContent {
                 puts "         ... $entry"
             }
                 #
                 # --- create cvLabel, cvEntry, Select ---
             set cvFrame        [ frame      $cvContentFrame.frame_${index} ]
             set     cvLabel    [ label      $cvFrame.label   -text "${labelText} : "]
             set      cvCBox    [ ttk::combobox $cvFrame.cb \
                                     -textvariable [namespace current]::_updateValue($key) \
                                     -values $listBoxContent    \
                                     -width  25 \
                                     -height 10 \
                                     -justify right ]

             set postCommand [list set [namespace current]::oldValue [namespace current]::_updateValue($key)]
             $cvCBox configure -postcommand [list eval set [namespace current]::oldValue \$[namespace current]::_updateValue($key)]

             if {$index == {oneLine}} {
                     set    cvClose [ button         $cvFrame.close   -image $rattleCAD::gui::iconArray(iconClose) -command [list [namespace current]::closeEdit $cv $cvEdit]]
                     grid    $cvLabel $cvCBox $cvClose   -sticky news
                     grid    $cvFrame                    -sticky news    -padx 1
             } else {
                     grid    $cvLabel $cvCBox            -sticky news
                     grid    configure $cvLabel          -sticky nws     -padx 2
                     grid    columnconfigure     $cvFrame 1      -weight 1
                     grid    $cvFrame                    -sticky news    -padx 1     -columnspan 3
             }
                 #
                 # --- define bindings ---
             bind $cvCBox    <<ComboboxSelected>>        [list [namespace current]::check_listBoxValue   %W $cv_Name $key]
             bind $cvLabel   <ButtonPress-1>             [list [namespace current]::dragStart    %X %Y]
             bind $cvLabel   <B1-Motion>                 [list [namespace current]::drag         %X %Y $cv $cvEdit]
             #bind $cvLabel  <B1-Motion>                 [list [namespace current]::drag         %X %Y $cv __cvEdit__]
    }

    proc change_ValueEdit {textVar direction} {
                 #
                 # --- dynamic update value ---
             set currentValue [set ::$textVar]
             set updateValue 1.0
             if {$currentValue < 20} { set updateValue 0.1 }
                     # puts "\n  -> $currentValue   -> $updateValue\n"
                 #
                 # --- update value of spinbox ---
             if {$direction eq "up"} {\
                 set newValue [expr {$currentValue + $updateValue}]\
             } else {\
                 set newValue [expr {$currentValue - $updateValue}]\
             }
             set ::$textVar [format "%.3f" $newValue]
    }

    proc bind_MouseWheel {textVar value} {
            set currentValue [set ::$textVar]
            set updateValue 1.0
            if {$currentValue < 20} { set updateValue 0.1 }
            if {$value > 0} {
                set scale 1.0
            } else {
                set scale -1.0
            }
            set newValue [expr {$currentValue + $scale * $updateValue}]
            set ::$textVar [format "%.3f" $newValue]
    }

    proc get_listBoxContent {type {key {}}} {      
            set listBoxContent {}
            switch -exact $type {
                    {SELECT_File} {             set listBoxContent [rattleCAD::file::get_componentAlternatives  $key] }
                    {SELECT_Rim} {              set listBoxContent $::APPL_Config(list_Rims) }
                    {SELECT_ForkType} {         set listBoxContent $::APPL_Config(list_ForkTypes) }
                    {SELECT_ForkBladeType} {    set listBoxContent $::APPL_Config(list_ForkBladeTypes) }
                    {SELECT_DropOutDirection} { set listBoxContent $::APPL_Config(list_DropOutDirections) }
                    {SELECT_DropOutPosition} {  set listBoxContent $::APPL_Config(list_DropOutPositions) }
                    {SELECT_ChainStay} {        set listBoxContent $::APPL_Config(list_ChainStay) }
                    {SELECT_BrakeType} {        set listBoxContent $::APPL_Config(list_BrakeTypes) }
                    {SELECT_BottleCage} {       set listBoxContent $::APPL_Config(list_BottleCage) }
                    {SELECT_Binary_OnOff} {     set listBoxContent $::APPL_Config(list_Binary_OnOff) }
            }
            return $listBoxContent
    } 
       #  createEdit - sub procedures
    #-------------------------------------------------------------------------
           
    #-------------------------------------------------------------------------
        #  update Project               
    proc updateConfig {cv_Name xpath {cvEntry {}}} {
    
          variable _updateValue
        
            # set _array  [lindex [split $xpath /] 0]
            # set _name   [string range $xpath [string length $_array/] end]
            # puts " updateConfig ->  $_array $_name $xpath"
            # 
            # foreach {_array _name path} [project::unifyKey $xpath] break
            # puts " updateConfig ->  $_array $_name $path"
        
          # --- handele xpath values ---
          switch -glob $xpath {
              {_update_} {}
              default {
                      set oldValue [project::getValue $xpath value]
                         # set oldValue [project::getValue [format "%s(%s)" $_array $_name] value]
                      if {$_updateValue($xpath) == $oldValue} {
                          return
                      }
                          # puts "003  -> update"
                          # puts "001  ->$oldValue"
                          # puts "001  ->$_updateValue($xpath)"
            
                      puts ""
                      puts "   -------------------------------"
                      puts "    updateConfig"
                      puts "       updateConfig:    $oldValue / $_updateValue($xpath)"
                      project::add_tracing
                          
                          # set Value
                      set newValue [bikeGeometry::set_Value $xpath $_updateValue($xpath)]
                          # puts "   -> \$newValue $newValue"
                      
                          # append _editList
                      append_editList                       $xpath $oldValue $newValue
                          #
                      
                          # set timestamp
                      set ::APPL_Config(canvasCAD_Update) [clock milliseconds]
                          #
                      
                          # set_Value xpath $_updateValue($xpath)
                          # project::remove_tracing
                      rattleCAD::cv_custom::update [rattleCAD::gui::current_canvasCAD]
                  }
          }
        
          #
          # --- finaly update
          # bikeGeometry::set_base_Parameters ;#$domProject
          update
          catch {focus $cvEntry}
          catch {$cvEntry selection range 0 end}
    }

    #-------------------------------------------------------------------------
        #  check comments in listbox   
    proc check_listBoxValue { w cv_Name xPath args} {
    
          variable _updateValue
          variable oldValue
        
          puts "  .. check_listBoxValue $xPath $args"
        
          switch $xPath {
              {Component/Wheel/Rear/RimDiameter} -
              {Component/Wheel/Front/RimDiameter} {
                          # -- exception for selection of Combobox
                              # list is splitted by: "----"
                      if {[string range $_updateValue($xPath) 0 3] == "----"} {
                              puts "   ... reset value .. $oldValue"
                          set _updateValue($xPath) $oldValue
                      } else {
                              # puts "   ... $_updateValue($xPath)"
                              # puts "      >[split $_updateValue($xPath) ;]<"
                              # puts "      >[lindex [split $_updateValue($xPath) ;] 0]<"
                          set value [string trim [lindex [split $_updateValue($xPath) ;] 0]]
                          set value [format "%.3f" $value]
                          set _updateValue($xPath) $value
                              # puts "   ... $_updateValue($xPath)"
        
                          [namespace current]::updateConfig $cv_Name $xPath
                      }
                  }
              default {
                          [namespace current]::updateConfig $cv_Name $xPath
                  }
          }
    } 

    #-------------------------------------------------------------------------
        #  close ProjectEdit Widget
    proc closeEdit {cv cvEdit} {
          $cv delete $cvEdit
          destroy $cvEdit
          catch [ destroy .__select_box ]
    }
    
    #-------------------------------------------------------------------------
        #  close all ProjectEdit Widgets
    proc close_allEdit {} {
          # puts "  -- closeEdit: $cv $cvEdit"
          set cv_Name {}
          set cv_Path {}
          catch {set cv_Name [rattleCAD::gui::current_canvasCAD]}
            # puts "   -> $cv_Name"
          catch {set cv_Path [ $cv_Name getNodeAttr Canvas path]}
            # puts "   -> $cv_Path"
          set items [$cv_Path find withtag __cvEdit__]
            # puts "   -> $items"
          
          foreach cvEdit $items {
              $cv_Path delete $cvEdit
              destroy $cvEdit
              catch [ destroy .__select_box ]
          }
    }   
    


    #-------------------------------------------------------------------------
        #  append undoList
    proc append_editList {parameter oldValue newValue} {
          variable _editList
          variable _editList_Index         ;# current index in _editList

            # -- clear _editList ---------------------------
            #
          puts "\n   --- append_editList -------- $_editList_Index --------------------"
          incr _editList_Index
          set i    [array size _editList]; # index of the last entry in _editList
          while {$i > $_editList_Index} {
              puts "       <I> $i / $_editList_Index"
              unset _editList($i)
              incr i -1
          }
          
            # -- append _editList ---------------------------
            #
          puts "           entry:  [format " (%3s) ...  %40s  %-25s / %25s"  $_editList_Index $parameter $oldValue $newValue]"
          set _editList($_editList_Index) [list $parameter $oldValue $newValue]
          #set _editList_Index             [expr [array size _editList] -1]
          
          return $_editList($_editList_Index)
    }

    #-------------------------------------------------------------------------
        #  exec_editList_prev 
    proc exec_editList_prev {} {
            variable _editList
            variable _editList_Index
            puts "\n"
            puts "   --- exec_editList_prev ----- $_editList_Index --------------------"
            close_allEdit
            print_editList
            if  {$_editList_Index > 0} {
                foreach {parameter oldValue newValue} $_editList($_editList_Index) break
                puts "           entry:  [format " (%3s) ...  %40s  %-25s"  $_editList_Index $parameter $oldValue]"
                  # set oldValue
                bikeGeometry::set_Value $parameter $oldValue
                  # update canvas
                rattleCAD::cv_custom::update [rattleCAD::gui::current_canvasCAD] 
                  #
                incr _editList_Index -1
                  #
            } else {
                puts "          exec_editList_prev - $_editList_Index - exception"
            }
            puts "   --- exec_editList_prev ----- $_editList_Index --------------------\n"
            
    }

    #-------------------------------------------------------------------------
        #  exec_editList_next 
    proc exec_editList_next {} {
            variable _editList
            variable _editList_Index
            puts "\n"
            puts "   --- exec_editList_next ----- $_editList_Index --------------------"
            close_allEdit
            print_editList
            incr _editList_Index
            if  {$_editList_Index <= [array size _editList] } {
                foreach {parameter oldValue newValue} $_editList($_editList_Index) break
                puts "           entry:  [format " (%3s) ...  %40s  %-25s"  $_editList_Index $parameter $newValue]"
                  # set newValue
                bikeGeometry::set_Value $parameter $newValue
                  # update canvas
                rattleCAD::cv_custom::update [rattleCAD::gui::current_canvasCAD] 
                  #
                # set _editList_Index [expr $_editList_Index + 1]
                  #
            } else {
                puts "          exec_editList_next - $_editList_Index - exception"
            }
            puts  "   --- exec_editList_next ----- $_editList_Index --------------------\n"

    }

    #-------------------------------------------------------------------------
        #  reset undoList
    proc reset_editList {} {
            variable _editList
            variable _editList_Index         ;# current index in _editList
            puts "\n   --- reset_editList -----------------------------"
            array unset         _editList
            set _editList_Index 0
    }

    #-------------------------------------------------------------------------
        #  print undoList 
    proc print_editList {} {
            variable _editList
            variable _editList_Index         ;# current index in _editList
            puts "\n     --- print_editList ------------------------ $_editList_Index ---"
            foreach entry [lsort [array names _editList]] {
                foreach {parameter oldValue newValue} $_editList($entry) break
                puts "           entry:  [format " (%3s) ...  %40s  %-25s / %25s"  $entry $parameter $oldValue $newValue]"
            }
            puts "     --- print_editList ---------------------------\n"
        
    }

    
    #-------------------------------------------------------------------------
        #  binding: drag
    proc drag {x y cv id} {
              # appUtil::get_procHierarchy
            variable _drag
            set dx [expr {$x - $_drag(lastx)}]
            set dy [expr {$y - $_drag(lasty)}]
            set cv_width  [ winfo width  $cv ]
            set cv_height [ winfo height $cv ]
            set id_bbox   [ $cv bbox $id ]
            if {[lindex $id_bbox 0] < 4} {set dx  1}
            if {[lindex $id_bbox 1] < 4} {set dy  1}
            if {[lindex $id_bbox 2] > [expr $cv_width  -4]} {set dx -1}
            if {[lindex $id_bbox 3] > [expr $cv_height -4]} {set dy -1}
        
            $cv move $id $dx $dy
            set _drag(lastx) $x
            set _drag(lasty) $y
    }

    #-------------------------------------------------------------------------
        #  binding: dragStart
    proc dragStart {x y} {
              # appUtil::get_procHierarchy
            variable _drag
            set [namespace current]::_drag(lastx) $x
            set [namespace current]::_drag(lasty) $y
            puts "      ... dragStart: $x $y"
    }

    #-------------------------------------------------------------------------
        #  create createSelectBox
    proc bind_parent_move {toplevel_widget parent} {
              # appUtil::get_procHierarchy
            if {![winfo exists $toplevel_widget]} {return}
            set toplevel_x    [winfo rootx $parent]
            set toplevel_y    [expr [winfo rooty $parent]+ [winfo reqheight $parent]]
            wm  geometry      $toplevel_widget +$toplevel_x+$toplevel_y
            wm  deiconify     $toplevel_widget
    }    
     
 } 
