#  This makefile generates the eBooks from the HTML files using Pandoc

#  Constants
DIR = _build
OUTPUT = book
KINDLEGEN = /Applications/KindleGen_Mac_i386_v2_7/kindlegen
PDFOPTS = --chapters --smart --standalone --table-of-contents
EPUBOPTS = --smart --standalone --table-of-contents
HTML_FILES = index.html blurbs.html letter-to-reader.html introduction-why-lisp.html lather-rinse-repeat-a-tour-of-the-repl.html practical-a-simple-database.html syntax-and-semantics.html functions.html variables.html macros-standard-control-constructs.html macros-defining-your-own.html practical-building-a-unit-test-framework.html numbers-characters-and-strings.html collections.html they-called-it-lisp-for-a-reason-list-processing.html beyond-lists-other-uses-for-cons-cells.html files-and-file-io.html practical-a-portable-pathname-library.html object-reorientation-generic-functions.html object-reorientation-classes.html a-few-format-recipes.html beyond-exception-handling-conditions-and-restarts.html the-special-operators.html programming-in-the-large-packages-and-symbols.html loop-for-black-belts.html practical-a-spam-filter.html practical-parsing-binary-files.html practical-an-id3-parser.html practical-web-programming-with-allegroserve.html practical-an-mp3-database.html practical-a-shoutcast-server.html practical-an-mp3-browser.html practical-an-html-generation-library-the-interpreter.html practical-an-html-generation-library-the-compiler.html conclusion-whats-next.html



#  ---------------------------------
#  Public targets
all: clean create_pdf create_epub create_kindle remove_files

pdf: clean create_pdf remove_files

epub: clean create_epub remove_files

kindle: clean create_kindle remove_files

clean:
	if [ -d "${DIR}" ]; \
		then rm -r ${DIR}; \
	fi

#  ---------------------------------
#  Private targets
#  If the build directory does not exist, create it
create_folder:
	if [ ! -d "${DIR}" ]; then \
		mkdir ${DIR}; \
		mkdir ${DIR}/figures; \
		mkdir ${DIR}/screenshots; \
		cp html/* ${DIR}; \
		cp html/figures/* ${DIR}/figures; \
		cp html/screenshots/* ${DIR}/screenshots; \
	fi

#  Generate PDF
create_pdf: create_folder
	cd ${DIR}; \
	pandoc ${PDFOPTS} -o ${OUTPUT}.pdf ${HTML_FILES}

#  Generate EPUB
create_epub: create_folder
	cd ${DIR}; \
	pandoc ${EPUBOPTS} -o ${OUTPUT}.epub ${HTML_FILES}

#  Create Kindle version using calibre's ebook-convert
create_kindle: create_folder
	cd ${DIR}; \
	ebook-convert index.html ${OUTPUT}.mobi --cover cover.jpg --title "Practical Common Lisp" --authors "Peter Seibel" --tags "lisp"

#  Clean up, so that only the product files remain
remove_files: create_folder
	cd ${DIR}; \
	rm -f *.png; \
	rm -f *.jpg; \
	rm -f *.css; \
	rm -rf figures/; \
	rm -rf screenshots/; \
	rm -f *.html

