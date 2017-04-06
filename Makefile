build.zip: lib/TM.js
	zip build.zip index.html js/* css/* lib/*

lib/TM.js: src/TM.elm
	elm make src/TM.elm --output lib/TM.js
