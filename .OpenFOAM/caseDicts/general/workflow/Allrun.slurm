#!/usr/bin/env bash
#SBATCH --nodes=2
#SBATCH --ntasks-per-node=128
#SBATCH --output=log.run
#SBATCH --open-mode=append

function getLatestTime()
{
    if ls -d processor*/*[0-9]* &>/dev/null
    then
        local timeSteps=$(ls -d $(ls -d processor* | head -1)/*[0-9]*)
    else
        local timeSteps=$(ls -d *[0-9]* | sort -g | tail -1)
    fi
  
    echo "${timeSteps}" | awk -F/ '{print $NF}' | sort -g | tail -1
}

[ ! -z ${SLURM_CPUS_PER_TASK+x} ] &&
    export OMP_NUM_THREADS="${SLURM_CPUS_PER_TASK}"
module --force purge

nTasks="${SLURM_NTASKS}"
nNodes="${SLURM_JOB_NUM_NODES}"
nTasksPerNode=$((${nTasks} / ${nNodes}))

export PAR_ARGS=( -fileHandler collated -ioRanks "( $(seq -s ' ' 0 ${nTasksPerNode} ${nTasks}) )" )

latestTime=$(getLatestTime)
printf "
/*------------------------------------------------------------*\\
 SLURM_CLUSTER_NAME=${SLURM_CLUSTER_NAME}
 SBATCH_ACCOUNT=project_462000885
 FOAM_CASE=${PWD}
 JOB_ID=${SLURM_JOB_ID}
\\*------------------------------------------------------------*/\n
Time = ${latestTime}\n\n"

# <lumi_easybuld.env>

# Source tutorial run functions
. $WM_PROJECT_DIR/bin/tools/RunFunctions
. $HOME/.OpenFOAM/caseDict/general/workflow/RunFunctions

# <Allrun>
