array_push(global.settings.shop_items, chip_to_give)
array_push(global.settings.shop_enabled, {index: chip_to_give, enabled: true})

instance_destroy(self);