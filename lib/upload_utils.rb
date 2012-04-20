require 'tmpdir'
require 'fileutils'
require 'shellwords'
require 'hpricot'
require 'logger'

module UploadUtils

	ROOT = File.expand_path(File.dirname(__FILE__) + '/..')
	CLASSPATH = "#{ROOT}/vendor/upload_utils/'*'"
	HEADLESS = "-Djava.awt.headless=true"
	ESCAPE = lambda {|x| Shellwords.shellescape(x)}
	LOGGING = "-Djava.util.logging.config.file=#{ROOT}/vendor/logging.properties"

	office ||= "/usr/lib/openoffice" if File.exists? '/usr/lib/openoffice'
	office ||= "/usr/lib/libreoffice" if File.exists? '/usr/lib/libreoffice'
  office ||= "/usr/lib64/openoffice.org" if File.exists? "/usr/lib64/openoffice.org"

	OFFICE = RUBY_PLATFORM.match(/darwin/i) ? '' : "-Doffice.home=#{office}"

	puts("#{CLASSPATH}")

	# Runs a Java command, with quieted logging, and the classpath set properly.
	def self.run(command, pdfs, opts, return_output=false)
		pdfs = [pdfs].flatten.map{|pdf| "\"#{pdf}\""}.join(' ')
		cmd = "java #{HEADLESS} #{LOGGING} #{OFFICE} -cp #{CLASSPATH} #{command} #{pdfs} 2>&1"
    log = Logger.new('uploads.txt')
    log.info("COMMM:#{cmd}")
		result = `#{cmd}`.chomp
		raise ExtractionFailed, result if $? != 0
		return return_output ? (result.empty? ? nil : result) : true
	end

	# Use JODCConverter to extract the documents as PDFs.
	# If the document is in an image format, use GraphicsMagick to extract the PDF.
	def self.extract_html(docs, opts={})
		out = opts[:output] || '.'
		FileUtils.mkdir_p out unless File.exists?(out)
		[docs].flatten.each do |doc|
			ext = File.extname(doc)
			basename = File.basename(doc, ext)
			escaped_doc, escaped_out, escaped_basename = [doc, out, basename].map(&ESCAPE)
			options = "-jar #{ROOT}/vendor/upload_utils/jodconverter/jodconverter-core-3.0-beta-4.jar -r #{ROOT}/vendor/upload_utils/conf/document-formats.js"
			run "#{options} #{escaped_doc} #{escaped_out}/#{escaped_basename}.html", [], {}
		end
	end

	def self.reduce_html(html)
		doc = Hpricot(html)
		doc.search("*").each do |e|
			if e.elem?
				e.search("b").wrap('<font style="font-weight: bold;">')
			end
		end
		doc.to_html.to_s
	end

    def self.upload(note)

      doc_model = note.doc.uploaded_file
      tmp = doc_model.tempfile

      dir = File.join("public/upload_tmp", note.user_id.to_s)
      FileUtils.mkdir_p dir unless File.exists?(dir)

      filename_doc = File.join(dir, doc_model.original_filename)
      ext = File.extname(filename_doc)
      basename = File.basename(filename_doc, ext)
      
      note.name = "#{basename}"
      note.doc_format = "#{ext[1, ext.length - 1]}"

      if !note.doc_preserved
        FileUtils.cp tmp.path, filename_doc
        extract_html(filename_doc, :output => dir)

        filename_html = File.join(dir, "#{basename}.html")
        html = File.open(filename_html, "rb")

        FileUtils.rm(filename_doc)
        FileUtils.rm(filename_html)

        note.content = reduce_html(html.read).sub("#0000ff", "#000000")
      end

      note

    end

end
