# Make use of makefile capability to only run the command if the file does not exist

We can do this with bash to create a local copy of `.env` file if it does not exists:

```bash
$ cp -n .env.sample .env
```

This also works with makefile

```bash
.env:
  cp .env.sample .env
  
your_command_that_needs_that_env: .env
  @echo do work
```
