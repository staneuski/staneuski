# vim:fileencoding=utf-8:foldmethod=marker
#$ ln -sfn .zprofile.triton.sh ~/.config/zsh/.zprofile

export CURL_CA_BUNDLE=/etc/ssl/certs/ca-bundle.crt
export SPACK_ROOT="/scratch/eng/t21206-cfd/.local/opt/spack"
source "${SPACK_ROOT}/share/spack/setup-env.sh"

export WM_PROJECT_SITE="/scratch/eng/t21206-cfd/.local/share/OpenFOAM/site"

opt-load "${HOME}/.local"
