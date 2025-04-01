function GuiTextInput() : GuiContainer() constructor {
	self.__cursor = {
		timer: 0,
		interval: 30,
	}
	self.__mouseCursor.hover = cr_beam;
	self.focused = false;
	setBorderSprite(spr_gui_panel_border);
	self.setFocused = function(_focused) {
		self.focused = _focused;
		self.setBorderColor(focused ? #40a0f0 : #c0c0c0);
		refresh();
		return self;
	}
	self.editable = true;
	
	self.setEditable = function(_editable) {
		self.editable = _editable;
		self.refresh();
		return self;
	}
	self.getEditable = function() {
		return self.editable;	
	}
	self.getValue = function() {
		return self.textComponent.text;	
	}
	self.setValue = function(_value) {
		self.textComponent.setText(_value);	
		self.refresh();
		return self;
	}
	self.textComponent = new GuiText("");
	self.setFlexDirection("row");
	self.setJustifyContent("start");
	self.setAlignItems("center");
	self.setPaddingSize(4);
	self.setColor(#202020);
	self.setBorderColor(#d0d0d0);
	self.setBorderIndex(15);
	self.addChild(textComponent);
	self.addEventListener("focus", function() {
		if (!self.editable) return;
		setFocused(true);
		textComponent.setCursorVisible(true);
		keyboard_string = textComponent.text;
		refresh();
	});
	self.addEventListener("unfocus", function() {
		if (!self.editable) return;
		setFocused(false);
		textComponent.setCursorVisible(false);
		refresh();
	})
	self.addEventListener("change", function(_data) {
		textComponent.setText(_data.text);
		textComponent.setCursorPosition(string_length(_data.text));
	});
	self.addEventListener("key_pressed", function() {
		self.emitEvent("unfocus");
	});
	step = function() {
		childrenStep();
		if (!self.editable) return;
		if (focused) {;
			if (keyboard_check(vk_control) && keyboard_check_pressed(ord("V"))) {
				keyboard_string += clipboard_get_text();
			}
			self.emitEvent("change", { text: keyboard_string });
			if (keyboard_check_pressed(vk_enter)) {
				var _key = vk_enter;
				self.emitEvent("key_pressed", { key: _key });
			}
			var _interval = self.__cursor.interval;
			self.__cursor.timer = (self.__cursor.timer + 1) mod (2*_interval);
			self.textComponent.setCursorVisible((self.__cursor.timer / _interval) < 1);
			
			refresh();
			layoutChildren();
		}
	}

}
