Module
======

Modules implement individual features of the engine. They do not contain any
state, but only use managers to communicate with outer world indirectly. Modules
get updated once per frame. They often operate on batches of all outer objects
of one type.

Update
------

The `void update()` method provides a hook to perform actions that need to be
done continuously to get the desired functionality working.

Inheritance
-----------

Modules have to be derived from the abstract `system::module` and implement the
`void update()` function.
