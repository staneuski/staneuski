# vim:fileencoding=utf-8:foldmethod=marker
#$ ln -sfn env-lumi.sh $HOME/.config/zsh/.zprofile

export SBATCH_ACCOUNT='project_462000885'
export SBATCH_ALLOC="${SBATCH_ACCOUNT}"

export RIP_GRAVEYARD="/scratch/${SBATCH_ACCOUNT}/${USER}/.graveyard"

export EBU_USER_PREFIX="/projappl/${SBATCH_ACCOUNT}/EasyBuild"
export SPACK_USER_PREFIX="/projappl/${SBATCH_ACCOUNT}/spack"

export PIPX_HOME="/flash/${SBATCH_ACCOUNT}/${USER}/pipx"

export WM_PROJECT_SITE="/projappl/${SBATCH_ACCOUNT}/site"
