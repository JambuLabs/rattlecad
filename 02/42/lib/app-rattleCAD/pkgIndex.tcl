# Tcl package index file, version 1.1
# This file is generated by the "pkg_mkIndex" command
# and sourced either when an application starts up or
# by a "package unknown" script.  It invokes the
# "package ifneeded" command to set up package-related
# information so that packages will be loaded automatically
# in response to "package require" commands.  When this
# script is sourced, the variable $dir must contain the
# full path name of this file's directory.

package ifneeded   rattleCAD  3.4.02 "\ 
        [list source  [file join $dir lib___model.tcl]]; \
        [list source  [file join $dir lib___control.tcl]]; \
        [list source  [file join $dir lib___control.changeList.tcl]]; \
        [list source  [file join $dir lib___view.tcl]]; \
        [list source  [file join $dir lib__model_file.tcl]]; \
        [list source  [file join $dir lib__view_gui.tcl]]; \
        [list source  [file join $dir lib__view_edit.tcl]]; \
        [list source  [file join $dir lib__control_tool.tcl]]; \
        [list source  [file join $dir lib_cv__custom.tcl]]; \
        [list source  [file join $dir lib_cv__update.tcl]]; \
        [list source  [file join $dir lib_cv_bikeRendering.tcl]]; \
        [list source  [file join $dir lib_cv_dimension.tcl]]; \
        [list source  [file join $dir lib_cv_dimension_BaseGeometry.tcl]]; \
        [list source  [file join $dir lib_cv_rearMockup.tcl]]; \
        [list source  [file join $dir lib_cv_tubeMiter.tcl]]; \
        [list source  [file join $dir lib_cv_frameJig.tcl]]; \
        [list source  [file join $dir lib_cv_compLibrary.tcl]]; \
        [list source  [file join $dir lib_infoPanel.tcl]]; \
        [list source  [file join $dir lib_cfgReport.tcl]]; \
        [list source  [file join $dir lib_configPanel.tcl]]; \
        [list source  [file join $dir lib_test.tcl]]; \
        [list source  [file join $dir lib_debug.tcl]]; \
        [list source  [file join $dir rattleCAD.tcl]]; \ 
   "

 # .. unused since 3.1.00
 # [list source  [file join $dir lib_control.tcl]]; 
 # [list source  [file join $dir lib_frame_ref_geometry.tcl]]; \ 
 # [list source  [file join $dir lib_projectUpdate.tcl]]; \
         
