# Modular Makefile

```makefile
Makefile // main
Makefile.db.mk // For database cli.
Makefile.dk.mk // For docker cli.
```

In `Makefile`:

```makefile
include Makefile.db.mk Makefile.dk.mk
include Makefile.*.mk # You can also use the catch-all pattern glob
```

~~The only problem is when you use a known extension, then the highlighting will be broken, e.g. `Makefile.js`.~~
End the file with the extension `.mk` to represent Makefiles. Then the syntax highlighting will work.
