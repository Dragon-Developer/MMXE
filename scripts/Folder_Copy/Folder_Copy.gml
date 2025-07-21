function Folder_Copy(_start_dir, _end_dir, _attributes){
	//log("finding files")
	var fname, i, file, files, from, to;
	// create directory if it doesn't exist yet:
	if (!directory_exists(_end_dir)) directory_create(_end_dir)
	// push matching files into array:
	// (has to be done separately due to possible recursion)
	files = 0
	for (fname = file_find_first(_start_dir + "/*.*", _attributes); fname != ""; fname = file_find_next()) {
	    // don't include current/parent directory "matches":
	    if (fname == ".") continue
	    if (fname == "..") continue
	    // push file into array
	    file[files] = fname
	    files += 1
		//log(fname + " ")
	}
	file_find_close()
	//log("files were found");
	// process found files:
	i = 0
	repeat (files) {
	    fname = file[i]
	    i += 1
	    from = _start_dir + "/" + fname
	    to = _end_dir + "/" + fname
	    if (file_attributes(from, fa_directory)) { // note: in GM:S+, prefer directory_exists(from)
	        Folder_Copy(from, to, _attributes) // recursively copy directories
	    } else {
	        file_copy(from, to) // copy files as normal
	    }
		//log(fname + " was transferred")
	}
	//log("files were transferred");
}