# vim:fileencoding=utf-8:foldmethod=marker
#$ ln -sfn env-mahti.sh $HOME/.config/zsh/.zprofile

export SBATCH_ACCOUNT='project_2004997'
export SBATCH_ALLOC="${SBATCH_ACCOUNT}"

export RIP_GRAVEYARD="/scratch/${SBATCH_ACCOUNT}/${USER}/.graveyard"

export USER_SPACK_ROOT="/projappl/${SBATCH_ACCOUNT}/spack"

export PYTHONUSERBASE="/projappl/${SBATCH_ACCOUNT}/${USER}/pyenv"
export PYTHONPATH=${PYTHONUSERBASE}/lib/python3.*/site-packages
export PATH="${PYTHONUSERBASE}/bin:${PATH}"

export PIPX_HOME="/projappl/${SBATCH_ACCOUNT}/${USER}/pipx"
export VENV_HOME="/projappl/${SBATCH_ACCOUNT}/${USER}/venv"
