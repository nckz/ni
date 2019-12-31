# ni
My cursed vim setup wrapped in a docker image.  This package contains a
launcher script that makes it easy to use this vim config on any docker ready
host e.g.:

```bash
    $ ni
    $ ni .
    $ ni ~/.my_hidden_file
    $ ni ~/my_softlinked_file
    $ ni ../../my_dir
    $ ni ../../my_softlinked_dir
    $ ni my_new_file
```

The target file or directories will be appropriately volume mounted in the
container by the launch script 'ni'.
