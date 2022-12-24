# Variables

Both `$VARIABLE` and `${VARIABLE}` syntax are supported. Additionally when using the 2.1 file format, it is possible to provide inline default values using typical shell syntax:


- `${VARIABLE:-default}` evaluates to default if `VARIABLE` is unset or empty in the environment.
- `${VARIABLE-default}` evaluates to default only if `VARIABLE` is unset in the environment.

Similarly, the following syntax allows you to specify mandatory variables:

- `${VARIABLE:?err}` exits with an error message containing err if `VARIABLE` is unset or empty in the environment.
- `${VARIABLE?err}` exits with an error message containing err if `VARIABLE` is unset in the environment.

Other extended shell-style features, such as `${VARIABLE/foo/bar}`, are not supported. [^1]


[^1]: https://docs.docker.com/compose/environment-variables/
