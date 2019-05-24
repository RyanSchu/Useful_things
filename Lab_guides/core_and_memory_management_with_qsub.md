Hi guys, lately we use a lot of cores for all of us to run things. We want to make sure we are always leaving at least one core open, but it can be a pain to wait for things to finish to qsub new things. This gist shows the basics of how to check on memory/cpu usage and create dependencies so you can submit all your jobs, but not take up all the cores at once. We can do this using the `-W` flag in qsub.

### Checking memory

If the CLI seems to be running slow check the system memory with the command `free -h`. This will display the following items
```
total        used        free      shared  buff/cache   available
```
We care about free memory. If the free memory drops too low (say less than 80GB) someone with sudo privelages (Ryan or Dr. Wheeler) can clear out the buff/cach memory with the following commands
```
sync
su
echo 3 > /proc/sys/vm/drop_caches
```

### Checking cores

There are a couple different commands you can use here all with slightly different uses. My preference is to use `pbstop` as I find this to be the clearest on resource allocation. You can find the total number of cores being used at the top of the screen as `N/72 Procs` where N is the total number of cores being used across all jobs. Before submitting always check this number to make sure you won't use up all the remaining cores. This also shows you how many cores a single job is using and how much time has passed since the job has been submitted.

I also find using `qstat -a` to be quite useful as it tells more concisely how many cores a job is using (written under TSK), how much memory has been allocated to that job, in addition to the elapsed time.

Another way to view core usage is with `htop` or with `qstat` 

### Creating dependencies in qsub
Say we have submitted a job already and it has the the job id 1.hewlab. We can schedule another job to happen after this job has ended like this
```
#generally
qsub -W depend=DEPENDENCY_TYPE:PBS_JOBID example_script.pbs
#specifically
qsub -W depend=afterany:1 example_script.pbs
#we only need to include the number from job id, not hewlab.
```
This will submit the contents of `example_script.pbs` to the queue but will place a hold on it so it won't run until job 1 has finished, regardless of status. We can also change the dependency type, so it can do things like wait until job 1 has completed without error. I haven't tested how reliable this is at catching errors, but feel free to try.  
```
Dependency - Definition
after	Execute current job after listed jobs have begun
afterok	Execute current job after listed jobs have terminated without error
afternotok	Execute current job after listed jobs have terminated with an error
afterany	Execute current job after listed jobs have terminated for any reason
before	Listed jobs can be run after current job begins execution
beforeok	Listed jobs can be run after current job terminates without error
beforenotok	Listed jobs can be run after current job terminates with an error
beforeany	Listed jobs can be run after current job terminates for any reason
```
### Looping
This is really convenient say if you want to submit all 22 chromosomes, but you don't want them all to run at once so that others have access to cores.
```
iter=$(qsub -v chr=1 example_script.pbs)
for j in {2..22}
do
        iter=$(qsub -W depend=afterany:$iter -v chr=${j} example_script.pbs)
        echo $iter
done
```
This submits a chr1 job and then has each subsequent chromosome depend on the preceding one. So chr2 waits for chr1 to finish, chr3 waits for chr2, and so on.

That's basically it
