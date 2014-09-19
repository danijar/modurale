Manager
=======

Managers hold common functionality that is needed by modules. They are allowed
to have state, which is often shared among modules to connect them indirectly.
However, in the simplest form, they are just wrappers around commonly needed
helper functions.

Thread safety
-------------

Managers may be accessed by multiple modules, which will run in dedicated
threads in future. Moreover, modules are free to spawn their own helper threads
that make use of managers. Therefore, managers must synchronize access to all
resources by providing thread safe interfaces.

Update
------

Managers don't get updated from outside on a regular basis. Instead, you can
launch a thread in the constructor to perform a recurring task, if needed.

Inheritance
-----------

Managers don't need to inherit from any abstract base class.
