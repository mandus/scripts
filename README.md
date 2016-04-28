# Scripts

Scripts that may or may not serve any purpose.

## TeX

I work quite a bit with LaTeX. When you split the sources into multiple files,
some tools out there requires the TEX root-statement to point to the
master-file. Since this is a trivial and boring task to maintain manually, 
I wrote the add_tex_root.sh script to perform the task:

```
add_tex_root.sh -c <master.tex>
```

Will add "%!TEX root master.tex" as first line in all tex-files from the
directory you are located in when running the command, and scanning recursively
down the tree for files. Without the "-c" option, a backup of each file that
has been changed, will be left in the folder.

