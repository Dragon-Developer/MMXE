function ComponentSoundLoader() : ComponentBase() constructor{
	self.sounds = [];
	self.file_extensions = [".ogg", ".wav"];
	self.source_folder = "sounds/";
	self.sounds_folder = "sounds/";
	self.music_folder = "music/"
	self.loops = false;
	self.volume = global.settings.Sound_Effect_Volume * 0.9;

	self.load_sound = function(_filename){
		var _final = noone;
		for(var g = 0; g < array_length(self.file_extensions); g++){
			var _snd = self.audio_create_stream(working_directory + self.source_folder + _filename + self.file_extensions[g]);
			if(_snd != undefined)
			{
				_final = _snd;
				break;
			}
		}
		return _final;
	}
	
	//from https://forum.gamemaker.io/index.php?threads/can-i-stream-wav-files.99231/
	//by FoxyOfJungle
	self.audio_create_stream = function(file_audio) {
	    if (file_exists(file_audio)) {
			if(filename_ext(file_audio) == ".ogg") {return audio_create_stream(file_audio);}
	        // headers offset
	        var _header_length = 44,
	        _ho_chunk_id = 0,
	        _ho_chunk_size = 4,
	        _ho_audio_format = 20,
	        _ho_channels_num = 22,
	        _ho_sample_rate = 24,
	        _ho_bps = 34,
	        _ho_subchunk_id2 = 36,
	        _ho_data = 44;
   
	        var audio_data = {
	            chunk_id : "", // < RIFF >
	            audio_format : 0, // 1 is PCM
	            channels_num : 0,
	            sample_rate : 0, // samples per second
	            bps : 0, // bits per sample (16 or 8)
	        };
   
	        // read file bytes
	        var file_buff = buffer_load(file_audio);
	        var file_size = buffer_get_size(file_buff);
	        var audio_file_buff = buffer_create(file_size, buffer_fixed, 1);
	        buffer_copy(file_buff, 0, file_size, audio_file_buff, 0);
	        buffer_delete(file_buff);
   
	        // read header
	        with(audio_data) {
	            var audio_buff_length = buffer_get_size(audio_file_buff);
	            for (var i = 0; i <= _header_length; i++) {
	                if (i >= _ho_chunk_id && i < _ho_chunk_size)
	                    chunk_id += chr(buffer_peek(audio_file_buff, i, buffer_u8));
	                if (i >= _ho_audio_format && i < _ho_channels_num)
	                    audio_format += buffer_peek(audio_file_buff, i, buffer_u8);
	                if (i >= _ho_channels_num && i < _ho_sample_rate)
	                    channels_num += buffer_peek(audio_file_buff, i, buffer_u8);
	                if (i == _ho_sample_rate)
	                    sample_rate += buffer_peek(audio_file_buff, i, buffer_u32);
	                if (i >= _ho_bps && i < _ho_subchunk_id2)
	                    bps += buffer_peek(audio_file_buff, i, buffer_u8);
	            }
	            if (string_lower(chunk_id) != "riff" || audio_format != 1) return undefined;
	            var _format = (bps == 8) ? buffer_u8 : buffer_s16;
	            var _channels = (channels_num == 2) ? audio_stereo : ((channels_num == 1) ? audio_mono : audio_3d);
	            return audio_create_buffer_sound(audio_file_buff, _format, sample_rate, _ho_data, audio_buff_length-_ho_data, _channels);;
	        }
	    } else {
	        return undefined;
	    }
	    return undefined;
	}

	self.play_sound = function(_filename, _start_frame = 0, _volume = volume){
		try {
			var _id = self.load_sound(_filename);
			var _snd = audio_play_sound(_id, 1, self.loops, _volume, _start_frame / 60)
		
			array_push(self.sounds, {sound_id: _snd, sound_asset: _id, volume: _volume, start_frame: _start_frame})
			log(_snd)
			return _snd;
		} catch (_exception){
			log(_exception)
		}
	}
	
	self.stop_sound = function(_snd = ""){
		for(var g = 0; g < array_length(self.sounds); g++){
			if(_snd = self.sounds[g].sound_id || _snd = ""){
				audio_destroy_stream(self.sounds[g].sound_asset);
				return;
			}
		}
		log("jack shit!")
		return;
	}
	
	self.clear_sound = function(){
		for(var g = 0; g < array_length(self.sounds); g++){
			log(self.sounds[g].sound_asset)
			audio_destroy_stream(self.sounds[g].sound_asset);
		}
	}
	
	self.draw = function(){
		//shut the fuck up i know im doing sound shit in draw
		var _snds = [];
		for(var g = 0; g < array_length(self.sounds); g++){
			if(audio_is_playing(self.sounds[g].sound_id))
				array_push(_snds, self.sounds[g])
		}
		self.sounds = _snds
	}
	
	self.draw_gui = function(){
		//draw_string(array_length(self.sounds), 2, 2);
	}
}