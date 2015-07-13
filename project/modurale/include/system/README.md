Sytem
=====

The system is the global control unit of the application. It holds both modules
and managers and updates the former.

Update
------

The `void update()` method is responsible of updating all attached active
modules. Note that the system must be initialized before updating it.

Inheritance
-----------

Modules have to be derived from the abstract `system::module` and implement the
`void update()` function.
