function SpriteLoader() constructor {
	static loaded_files = {};
	// Helper recursive function defined outside the main method
	static __scan_directory = function (currentDir, files, settings, defaultOrigin) {
	    // Process all PNG files in the current directory
	    var pngFile = file_find_first(currentDir + "/*.png", fa_archive);
	    while (pngFile != "") {
	        var fileName = filename_name(pngFile);
			var _split = string_split(string_replace_all(fileName, ".png", ""), "_strip");
			var _frames = 1;
			if (array_length(_split) > 1) {
				var _digits = string_digits(_split[1]);
				if (string_length(_digits) > 0) {
					_frames = real(_digits);
				}
			}
	        var baseName = _split[0];
	        var origin = defaultOrigin;
	        if (struct_exists(settings, baseName) && struct_exists(settings[$ baseName], "origin")) {
	            origin = settings[$ baseName].origin;
	        } else {
				var _names = struct_get_names(settings);
				var _match = "";
				for (var _i = 0, _len = array_length(_names); _i < _len; _i++) {
					if (string_count(_names[_i], baseName) > 0) {
						if (string_length(_names[_i]) > string_length(_match)) {
							_match = _names[_i];
						}
					}
				}
				if (_match != "" && struct_exists(settings, _match) && struct_exists(settings[$ _match], "origin")) {
			        origin = settings[$ _match].origin;
			    }
			}
	        array_push(files, { path: currentDir + "/" + pngFile, name: baseName, origin, frames: _frames});
	        pngFile = file_find_next();
	    }
	    file_find_close();
	    // Process all subdirectories recursively
	    var subDir = file_find_first(currentDir + "/*", fa_directory);
	    while (subDir != "") {
	        var fullSubDirPath = currentDir + "/" + subDir;
	        if (directory_exists(fullSubDirPath)) {
	            __scan_directory(fullSubDirPath, files, settings, defaultOrigin);
	        }
	        subDir = file_find_next();
	    }
	    file_find_close();
	}

	static get_all_png_files = function (directory) {
	    var files = [];

	    // Load animation.json if it exists
	    var settingsPath = directory + "/animation.json";
	    var settings = {};
	    var defaultOrigin = { x: 0, y: 0 };

	    if (file_exists(settingsPath)) {
	        var _data = JSON.load(settingsPath);
	        if (struct_exists(_data, "sprites")) {
	            settings = _data[$ "sprites"];
	        }
	        settings[$ "default"] ??= {};
	        settings[$ "default"][$ "origin"] ??= { x: 0, y: 0 };
	        defaultOrigin = settings[$ "default"][$ "origin"];
	    }

	    // Start recursive scanning from the given directory using the helper function
	    self.__scan_directory(directory, files, settings, defaultOrigin);

	    //show_debug_message(files);
	    return files;
	}


	static load_png_files = function(_collage, _files) {
		_files = array_filter(_files, function(_file) {
			return !struct_exists(loaded_files, _file.path);
		});
		if (array_length(_files) == 0) return;
		_collage.StartBatch();
		for (var i = 0; i < array_length(_files); i++) {
			var _sprite = _files[i];
		    _collage.AddFile(_sprite.path, _sprite.name, _sprite.frames, false, false, _sprite.origin.x, _sprite.origin.y);
			loaded_files[$ _sprite.path] = true;
		}
		_collage.FinishBatch();
	}
	static reload_collage = function(_collage, _dir) {
		var _files = SpriteLoader.get_all_png_files(_dir);
		SpriteLoader.load_png_files(_collage, _files);
		return _files;
	}
}
SpriteLoader();