if lifetime < lifetime_max / 2 visible = lifetime mod 2
if lifetime-- < 0 instance_destroy(self);