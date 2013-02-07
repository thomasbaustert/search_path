require 'search_path/version'

module SearchPath

  # Raised if search path is not absolute.
  class SearchPathNotAbsoluteError < StandardError; end

  # Raised if one or more given search paths does not exist.
  class SearchPathNotExistError < StandardError; end

  # Raised if given file was not found in the given search paths.
  class FileNotFoundError < StandardError; end


  class SearchPath

    attr_reader :search_paths

    ##
    # Initialize a new +SearchPath+ instance with the given search paths.
    #
    # == Parameters
    #
    # * +search_paths+ - The search paths to find a filename in.
    #
    # == Options
    #
    # * +:verify_paths+ - If +true+ verify the existence of each search path and raise an +SearchPathNotExistError+ exception if path not exists.
    #
    # ==== Examples
    #
    #    search_path = SearchPath.new("/path1/to/files")
    #    search_path = SearchPath.new(["/path1/to/files", "/path2/to/files"])
    #
    #    # => raises SearchPathNotAbsoluteError
    #    search_path = SearchPath.new(["a/relative/path"])
    #
    #    # => raises SearchPathNotExistError for "/not/existing/path"
    #    search_path = SearchPath.new(["/existing/path", "/not/existing/path"], :verify_paths => true)
    #
    def initialize(search_paths, options = {})
      @search_paths = Array(search_paths)

      verify_search_paths_are_absolute!
      verify_search_paths_exists! if options[:verify_paths] == true
    end

    ##
    # Finds the given +filename+ in the search paths. Returns the full path to the file
    # or +nil+ if the file could not be found in one of the search paths.
    #
    # == Parameters
    #
    # * +filename+ - The filename to find.
    #
    # ==== Examples
    #
    #    search_path = SearchPath.new(["/path1/to/files", "/path2/to/files"])
    #
    #    # File "searched_file.txt" exists in "/path1/to/files"
    #    search_path.find("searched_file.txt") # => "/path1/to/files/searched_file.txt"
    #
    #    # File "searched_file.txt" exists in "/path2/to/files"
    #    search_path.find("searched_file.txt") # => "/path2/to/files/searched_file.txt"
    #
    #    # File "searched_file.txt" exists in none
    #    search_path.find("searched_file.txt") # => nil
    #
    def find(filename)
      search_paths.each do |path|
        if File.exists?("#{path}/#{filename}")
          return "#{path}/#{filename}"
        end
      end

      nil
    end

    ##
    # Same as #find but raises +FileNotFoundError+ exception if the file could not be found.
    #
    def find!(filename)
      find(filename) || raise_file_not_found!(filename)
    end

    private

    def verify_search_paths_are_absolute!
      not_absolute_paths = search_paths.inject([]) do |list, path|
        list << path unless Pathname.new(path).absolute?
        list
      end

      raise raise_search_path_not_absolute!(not_absolute_paths) unless not_absolute_paths.empty?
    end

    def verify_search_paths_exists!
      not_existing_paths = search_paths.inject([]) do |list, path|
        list << path unless existing_directory?(path)
        list
      end

      raise raise_search_path_not_exists!(not_existing_paths) unless not_existing_paths.empty?
    end

    def existing_directory?(path)
      File.exists?(path) && File.directory?(path)
    end

    def raise_search_path_not_absolute!(paths)
      raise SearchPathNotAbsoluteError.new("Search path(s) #{paths.inspect} is not absolute.")
    end

    def raise_search_path_not_exists!(paths)
      raise SearchPathNotExistError.new("Search path(s) #{paths.inspect} does not exists.")
    end

    def raise_file_not_found!(filename)
      raise FileNotFoundError.new("File '#{filename}' not found in search paths #{search_paths.inspect}.")
    end

  end

end


