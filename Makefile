.PHONY: clean

LIB_DIR=lib
NAME=TM

build.zip: $(LIB_DIR)/$(NAME).min.js
	zip build.zip index.html js/* css/* lib/*

$(LIB_DIR)/$(NAME).min.js: $(LIB_DIR)/$(NAME).js
	uglifyjs $< --compress 'pure_funcs="F2,F3,F4,F5,F6,F7,F8,F9,A2,A3,A4,A5,A6,A7,A8,A9",pure_getters,keep_fargs=false,unsafe_comps,unsafe' | uglifyjs --mangle --output=$@


$(LIB_DIR)/$(NAME).js: src/TM.elm
	elm make $< --optimize --output $@

clean:
	rm build.zip
	rm $(LIB_DIR)/*
