#!/usr/bin/env bash
 
# This file is part of The RetroPie Project
#
# The RetroPie Project is the legal property of its developers, whose names are
# too numerous to list here. Please refer to the COPYRIGHT.md file distributed with this source.
#
# See the LICENSE.md file at the top-level directory of this distribution and
# at https://raw.githubusercontent.com/RetroPie/RetroPie-Setup/master/LICENSE.md
#
 
rp_module_id="openxcom"
rp_module_desc="OpenXCOM - Open Source X-COM Engine"
rp_module_menus="4+"
rp_module_flags="!mali !x86"
 
function depends_openxcom() {
    getDepends cmake xorg libsdl1.2-dev libsdl-mixer1.2-dev libsdl-image1.2-dev libsdl-gfx1.2-dev libyaml-cpp-dev
}

function sources_openxcom() {
    if [ ! -f "/opt/retropie/supplementary/glshim/libGL.so.1" ]; then
        gitPullOrClone "$md_build/glshim" https://github.com/ptitseb/glshim.git
    fi
    gitPullOrClone "$md_build/$md_id" https://github.com/SupSuper/OpenXCOM.git
}
 
function build_openxcom() {
    if [ ! -f "/opt/retropie/supplementary/glshim/libGL.so.1" ]; then
        cd "$md_build/glshim"
        cmake . -DBCMHOST=1
        make GL
    fi
    cd "$md_build/$md_id"
    mkdir build
    cd build
    cmake -DCMAKE_INSTALL_PREFIX:PATH="$md_inst" ..
    make
    md_ret_require="$md_build/$md_id/build/bin/openxcom"
}

function install_openxcom() {
    if [ ! -f "/opt/retropie/supplementary/glshim/libGL.so.1" ]; then
       mkdir -p /opt/retropie/supplementary/glshim/
       cp "$md_build/glshim/lib/libGL.so.1" /opt/retropie/supplementary/glshim/
    fi
    cd "$md_build/$md_id/build/"
    make install
}
 
function configure_openxcom() {
    mkdir "ports"
    moveConfigDir "$home/.config/openxcom" "$md_conf_root/openxcom"
    addPort "$md_id" "openxcom" "OpenXCOM - Open Source X-COM Engine" "LD_LIBRARY_PATH=/opt/retropie/supplementary/glshim LIBGL_FB=1 xinit $md_inst/bin/openxcom"
    __INFMSGS+=("Be sure to install your original data files to the proper folders in $md_inst/share/openxcom.")

}
