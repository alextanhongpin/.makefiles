# Some standards for naming for Makefile

Add the extension `.mk` to benefit from syntax highlighting:
```
Makefile (the main file)
Makefile.db.mk (for database)
Makefile.dk.mk (for docker)
```

You can include multiple makefile into one main Makefile:
```
include Makefile.db.mk include Makefile.dk.mk
```
