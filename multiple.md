# Modular Makefile

```
Makefile // main
Makefile.db // For database cli.
Makefile.dk // For docker cli.
```

In `Makefile`:

```
include Makefile.db Makefile.dk
```

The only problem is when you use a known extension, then the highlighting will be broken, e.g. `Makefile.js`.
