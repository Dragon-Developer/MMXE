function SpriteLoader() constructor {
	static loaded_files = {};
	// Generates the nested directory structure first, then processes it
	static __generate_directory_structure = function (_current_dir) {
	    var result = {
	        path: _current_dir,
	        files: [],
	        subdirectories: []
	    };

	    // Collect PNG files in the current directory
	    var _png_files = [];
	    var _png_file = file_find_first(_current_dir + "/*.png", fa_archive);
	    while (_png_file != "") {
	        array_push(_png_files, _current_dir + "/" + _png_file);
	        _png_file = file_find_next();
	    }
	    file_find_close();
	    result.files = _png_files; // Save files in the structure

	    // Collect subdirectories in the current directory
	    var _sub_dirs = [];
	    var _sub_dir = file_find_first(_current_dir + "/*", fa_directory);
	    while (_sub_dir != "") {
	        var _full_sub_dir_path = _current_dir + "/" + _sub_dir;
	        if (directory_exists(_full_sub_dir_path)) {
	            array_push(_sub_dirs, _full_sub_dir_path);
	        }
	        _sub_dir = file_find_next();
	    }
	    file_find_close();

	    // Now process subdirectories recursively
	    for (var _i = 0; _i < array_length(_sub_dirs); _i++) {
	        array_push(result.subdirectories, self.__generate_directory_structure(_sub_dirs[_i]));
	    }

	    return result;
	};

	// Recursively scans the directory structure and loads files
	static __scan_directory = function (_directory_structure, _files, _settings, _default_origin) {
	    // Process files in the current directory first
	    for (var _i = 0; _i < array_length(_directory_structure.files); _i++) {
	        var _file_path = _directory_structure.files[_i];
	        var _file_name = filename_name(_file_path);
	        var _split = string_split(string_replace_all(_file_name, ".png", ""), "_strip");
	        var _frames = 1;

	        if (array_length(_split) > 1) {
	            var _digits = string_digits(_split[1]);
	            if (string_length(_digits) > 0) {
	                _frames = real(_digits);
	            }
	        }

	        var _base_name = _split[0];
	        var _origin = _default_origin;
	        if (struct_exists(_settings, _base_name) && struct_exists(_settings[$ _base_name], "origin")) {
	            _origin = _settings[$ _baseName].origin;
	        }

	        array_push(_files, { path: _file_path, name: _base_name, origin: _origin, frames: _frames });
	    }

	    // Now process subdirectories recursively
	    for (var _j = 0; _j < array_length(_directory_structure.subdirectories); _j++) {
	        self.__scan_directory(_directory_structure.subdirectories[_j], _files, _settings, _default_origin);
	    }
	};

	// Public function to start the process
	static get_all_png_files = function (_dir, _subdir) {
	    var _directory_structure = self.__generate_directory_structure(_dir + _subdir);
	    var _files = [];

	    // Load settings if available
	    var _settings_path = _dir + "/animation.json";
	    var _settings = {};
	    var _default_origin = { x: 0, y: 0 };

	    if (file_exists(_settings_path)) {
	        var _data = JSON.load(_settings_path);
	        if (struct_exists(_data, "sprites")) {
	            _settings = _data[$ "sprites"];
	        }
	        _settings[$ "default"] ??= {};
	        _settings[$ "default"][$ "origin"] ??= { x: 0, y: 0 };
	        _default_origin = _settings[$ "default"][$ "origin"];
	    }

	    // Now traverse the nested structure and collect files
	    self.__scan_directory(_directory_structure, _files, _settings, _default_origin);

	    return _files;
	};

	static load_png_files = function(_collage, _files) {
		_files = array_filter(_files, function(_file) {
			return !struct_exists(loaded_files, _file.path);
		});
		if (array_length(_files) == 0) return;
		_collage.StartBatch();
		for (var _i = 0; _i < array_length(_files); _i++) {
			var _sprite = _files[_i];
		    _collage.AddFile(_sprite.path, _sprite.name, _sprite.frames, false, false, _sprite.origin.x, _sprite.origin.y);
			loaded_files[$ _sprite.path] = true;
		}
		_collage.FinishBatch();
	}
	static reload_collage = function(_collage, _dir, _subdirs) {
		var _files = [];
		for (var _i = 0, _len = array_length; _i < array_length(_subdirs); _i++) {
			_files = array_concat(_files, SpriteLoader.get_all_png_files(_dir, _subdirs[_i]));
		}
		SpriteLoader.load_png_files(_collage, _files);
		return _files;
	}
}
SpriteLoader();