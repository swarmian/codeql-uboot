import cpp

from MacroInvocation mi
where mi.getMacroName().regexpMatch("ntoh(l|ll|s)")
select mi