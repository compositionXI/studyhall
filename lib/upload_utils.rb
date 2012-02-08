require 'tmpdir'
require 'fileutils'
require 'shellwords'

module UploadUtils

	ROOT = File.expand_path(File.dirname(__FILE__) + '/..')
	CLASSPATH = "#{ROOT}/vendor/upload_utils/'*'"
	HEADLESS = "-Djava.awt.headless=true"
	ESCAPE = lambda {|x| Shellwords.shellescape(x)}
	LOGGING = "-Djava.util.logging.config.file=#{ROOT}/vendor/logging.properties"

	office ||= "/usr/lib/openoffice" if File.exists? '/usr/lib/openoffice'
	office ||= "/usr/lib/libreoffice" if File.exists? '/usr/lib/libreoffice'

	OFFICE = RUBY_PLATFORM.match(/darwin/i) ? '' : "-Doffice.home=#{office}"

	puts("#{CLASSPATH}")

	# Runs a Java command, with quieted logging, and the classpath set properly.
	def self.run(command, pdfs, opts, return_output=false)
		pdfs = [pdfs].flatten.map{|pdf| "\"#{pdf}\""}.join(' ')
		cmd = "java #{HEADLESS} #{LOGGING} #{OFFICE} -cp #{CLASSPATH} #{command} #{pdfs} 2>&1"
		puts "CMD: #{cmd}"
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

    def self.upload(doc_model, current_user)

      tmp = doc_model.tempfile

      dir = File.join("public", current_user.id.to_s)
      FileUtils.mkdir_p dir unless File.exists?(dir)

      filename_doc = File.join(dir, doc_model.original_filename)
      FileUtils.cp tmp.path, filename_doc
      extract_html(filename_doc, :output => dir)

      ext = File.extname(filename_doc)
      basename = File.basename(filename_doc, ext)

      filename_html = File.join(dir, "#{basename}.html")
      html = File.open(filename_html, "rb")

      FileUtils.rm(filename_doc)
      FileUtils.rm(filename_html)

      contents = html.read
      return current_user.notes.new(:content => contents, :name => "#{basename}")

    end

end
