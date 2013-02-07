## SearchPath

Allows to define search paths to find files in.

Useful for example to configure a few template directories to find a template in.

## Install via Bundler

Add to Gemfile:

    # Gemfile
    gem "search_path"

And run bundler:

    $ bundle install

## Install without Bundler

    $ gem install search_path

## Usage

### Example with find

    # Define the search paths. Search paths are considered in the order given, first given first searched.
    search_path = SearchPath.new(["/custom/path/to/files", "/standard/path/to/files"])

    # Case 1: File not in "/custom/path/to/files" but in "/standard/path/to/files":
    search_path.find("template.erb") # => "/standard/path/to/files/template.erb"

    # Case 2: File in "/custom/path/to/files" and in "/standard/path/to/files":
    search_path.find("template.erb") # => "/custom/path/to/files/template.erb"

    # Case 3: File not in "/custom/path/to/files" and not in "/standard/path/to/files":
    search_path.find("template.erb") # => nil

### Example with find!

Same as `find` but raises `SearchPath::FileNotFoundError` if file cannot be found:

    search_path.find!("template.erb")   # => "/custom/path/to/files/template.erb"
    search_path.find!("not_exists.erb") # => SearchPath::FileNotFoundError

### Verify that search paths exists

In case you wanna make sure the given search paths exists use option `verify_paths`:

    # Raises SearchPath::SearchPathNotExistError if "/path1/to/files" or "/path2/to/files" not exist.
    search_path = SearchPath.new(["/path1/to/files", "/path2/to/files"], :verify_paths => true)

### Search paths must be absolute

Note that each search path must be an absolute path. Using a relative path will raise an error:

    # This Raises SearchPath::SearchPathNotAbsoluteError:
    search_path = SearchPath.new("relative/path/to/files")

Because you want to avoid using hardcoded absolute paths in your code you define the paths
relative to search_path initialization code for example:

    search_dir  = File.expand("../../relative/path/to/files", __FILE__)
    search_path = SearchPath.new([search_dir])

## Contact

For comments and question feel free to contact me: business@thomasbaustert.de

Copyright © 2012 [Thomas Baustert](http://thomasbaustert.de), released under the MIT license


