# vim:fileencoding=utf-8:foldmethod=marker
#$ ln -sfn .zprofile.debian.sh ~/.config/zsh/.zprofile

export SSL_CERT_DIR='/etc/ssl/certs'
export SSL_CERT_FILE="${SSL_CERT_DIR}/ca-certificates.crt"
export SPACK_ROOT=/l/spack
source "${SPACK_ROOT}/share/spack/setup-env.sh"

export WM_PROJECT_SITE="${HOME}/Developer/dev__foam_site"

opt-load "${HOME}/.local"
