#----------------------------------*-sh-*--------------------------------------
# =========                 |
# \\      /  F ield         | OpenFOAM: The Open Source CFD Toolbox
#  \\    /   O peration     | Website:  https://openfoam.org
#   \\  /    A nd           | Copyright (C) 2011-2018 OpenFOAM Foundation
#    \\/     M anipulation  |
#------------------------------------------------------------------------------
# File
#     ~/.OpenFOAM/prefs.sh
#
# Description
#     Preset variables for the OpenFOAM configuration - POSIX shell syntax.
#
#     The prefs.sh file will be sourced by the OpenFOAM etc/bashrc when it is
#     found by foamEtcFile.
#
# See also
#     'foamEtcFile -help' or 'foamEtcFile -list' for information about the
#     paths searched
#
#------------------------------------------------------------------------------


# OpenFOAM environment variables
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# macOS compilation settings
if [[ $(uname) == "Darwin" ]]; then
    export WM_COMPILER=Clang
    export WM_MPLIB=SYSTEMOPENMPI
    export WM_LABEL_SIZE=32
    export WM_NCOMPPROCS=$(sysctl -n hw.ncpu)
    export WM_PROJECT_SITE=$HOME/Developer/Projects/foamio/addons
else
    export WM_PROJECT_SITE=$HOME/.local/share/foamio/addons
fi

export WM_COMPILE_OPTION=Opt # Opt | Debug
export WM_PROJECT_USER_DIR=$HOME/.local/opt/$WM_PROJECT-$WM_PROJECT_VERSION

