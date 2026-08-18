# vim:fileencoding=utf-8:foldmethod=marker
#$ ln -sfn .zprofile.roihu.sh ~/.config/zsh/.zprofile

export ZPFX="${HOME}/.local/$(uname -m)"
export BASH_COMPLETION_USER_DIR="${HOME}/.local/share/$(uname -m)/bash-completion"

export SPACK_USER_CACHE_PATH="${TMPDIR}/spack"
export SPACK_DISABLE_LOCAL_CONFIG=true
export SPACK_ROOT='/appl/soft/spack/v2026_03/spack'

export SBATCH_ACCOUNT='project_2004997'
export SBATCH_ALLOC="${SBATCH_ACCOUNT}"

export WM_PROJECT_SITE="/projappl/${SBATCH_ACCOUNT}/.local/share/OpenFOAM/site"
