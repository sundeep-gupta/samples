def f = new File('/home/skgupta/emdi_4812_files')
def src = '/scratch/skgupta/git_storage/emdi_old_4812'
def dst = '/scratch/skgupta/git_storage/emdi'
f.eachLine { line ->
    def cmd = "cp ${src}/${line} ${dst}/${line}"
    println cmd
    cmd.execute()
}
