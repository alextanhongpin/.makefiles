Using with `peru.yaml`:

```yaml
# uvx peru sync
# uvx peru reup
imports:
    # The makefile just goes at the root of our project.
    makefile-jupyter: ./


git module makefile-jupyter:
    url: https://github.com/alextanhongpin/.makefiles.git
    rev: 4ef5ee69439674a70b324f4f4dede437cf537a2f # Choose a specific revision
    pick: Makefile.jupyter.mk # Pick this file
```
