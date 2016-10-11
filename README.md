# ExodusII

A wrapper around the ExodusII library. You'll need the ExodusII c library. It
can be obtained in debian with `sudo apt-get install libexodusII-dev`.

The wrapper doesn't just wrap the functions directly but does a bit of
convenience work as well. Instead of calling `ex_get_var_param` for names one
should call `ex_get_nodal_var_names` or `ex_get_elem_var_names`. The whole
library isn't wrapped, just what has been required so far, feel free to make a
request for functionality or to make a pull request.
