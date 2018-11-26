# Suggested design

All objects would have a one property script to simulate member variables in a class.
Therefore, we can properly separate the implementation with different child scripts
and simply call the getters and setters.

**e.g.**
```
var properties = get_parent()
movementSpeed = properties.get("movementSpeed")
```

This approach might be a bit overkill with all the getters and settings
so I'm open for suggestions. (But it ensures that correct assumptions and restrictions
are made)


We'd also have to ensure constant tracking of those variables.
(Possibly on change events in specific cases)