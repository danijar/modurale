Type
====

Types are stored globally in the entity manager, so they are accessible from all
modules. Types should not provide much functionality. They are just naive
storages.

Inheritance
-----------

Types don't need to inherit from any abstract base class.

Distinction
-----------

Even though you can store any type in the entity manager, it is advisable to
wrap primitive types by a structure to give them an expressive name. Remember
that all types are shared between modules. Therefore, using primitive types in a
way that is not clear to every programmer will cause conflicts.
