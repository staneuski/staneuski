# vim:fileencoding=utf-8:foldmethod=marker
#$ ln -sfn env-lumi.sh $HOME/.config/zsh/.zprofile

export SBATCH_ACCOUNT='project_462000855'
export SBATCH_ALLOC="${SBATCH_ACCOUNT}"

export RIP_GRAVEYARD="/scratch/${SBATCH_ACCOUNT}/${USER}/.graveyard"

export EBU_USER_PREFIX="/projappl/${SBATCH_ACCOUNT}/EasyBuild"
export SPACK_USER_PREFIX="/projappl/${SBATCH_ACCOUNT}/spack"

export PIPX_HOME="/projappl/${SBATCH_ACCOUNT}/${USER}/pipx"
