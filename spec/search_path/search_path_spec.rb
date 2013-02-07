require 'spec_helper'

describe SearchPath do

  describe "#initialize" do

    context "given relative path" do
      it "raises exception" do
        FakeFS do
          create_dir("/absolute/path/to/")
          Dir.chdir("/absolute/path/to") do
            lambda {
              SearchPath.new(["a/not/existing/relative/path"])
            }.should raise_error(SearchPath::SearchPathNotAbsoluteError, "Search path(s) [\"a/not/existing/relative/path\"] is not absolute.")
          end
        end
      end
    end

    describe "verification existence of search paths" do

      context "given not existing search path" do
        context "as absolute path" do
          it "raises exception if path not exists" do
            lambda {
              SearchPath.new(["/not/existing/path"], :verify_paths => true)
            }.should raise_error(SearchPath::SearchPathNotExistError, "Search path(s) [\"/not/existing/path\"] does not exists.")
          end
        end

        it "raises exception if one path not exists" do
          FakeFS do
            create_dir("/existing/path")
            lambda {
              SearchPath.new(["/existing/path", "/not/existing/path"], :verify_paths => true)
            }.should raise_error(SearchPath::SearchPathNotExistError, "Search path(s) [\"/not/existing/path\"] does not exists.")
          end
        end

        it "raises exception if path is not a directory" do
          FakeFS do
            create_filename("/existing/path/to/file.txt")
            lambda {
              SearchPath.new(["/existing/path/to/file.txt"], :verify_paths => true)
            }.should raise_error(SearchPath::SearchPathNotExistError, "Search path(s) [\"/existing/path/to/file.txt\"] does not exists.")
          end
        end
      end
    end
  end

  describe "#search_paths" do
    context "given search paths is nil" do
      it "converts string to empty array" do
        search_path = SearchPath.new(nil)
        search_path.search_paths.should eq []
      end
    end

    context "given search paths is as string" do
      it "converts string to array with one element" do
        search_path = SearchPath.new("/path/to/files")
        search_path.search_paths.should eq ["/path/to/files"]
      end
    end

    context "given search paths is an array of strings" do
      it "returns array as given" do
        search_path = SearchPath.new(["/path1/to/files", "/path2/to/more/files"])
        search_path.search_paths.should eq ["/path1/to/files", "/path2/to/more/files"]
      end
    end
  end

  describe "#find" do
    context "empty search path given" do
      it "should return nil" do
        SearchPath.new(nil).find("searched_file.txt").should be_nil
        SearchPath.new([]).find("searched_file.txt").should be_nil
      end
    end

    context "search path given" do
      context "file not exists in search path" do
        it "should return nil" do
          FakeFS do
            search_path = SearchPath.new(["/not/existing/path"])
            search_path.find("searched_file.txt").should be_nil
          end
        end
      end

      context "file exists in search path" do
        it "should return full path to file" do
          FakeFS do
            create_filename("/path/to/files/searched_file.txt")
            search_path = SearchPath.new(["/path/to/files"])
            search_path.find("searched_file.txt").should eq "/path/to/files/searched_file.txt"
          end
        end
      end
    end
  end

  describe "#find!" do
    context "empty search path given" do
      it "should raise exception" do
        lambda { SearchPath.new(nil).find!("searched_file.txt") }.should(
            raise_error(SearchPath::FileNotFoundError, "File 'searched_file.txt' not found in search paths []."))
        lambda { SearchPath.new([]).find!("searched_file.txt") }.should raise_error(SearchPath::FileNotFoundError)
      end
    end

    context "search path given" do
      context "file not exists in search path" do
        it "should raise exception" do
          FakeFS do
            search_path = SearchPath.new(["/not/existing/path"])
            lambda { search_path.find!("searched_file.txt") }.should raise_error(SearchPath::FileNotFoundError)
          end
        end
      end

      context "file exists in search path" do
        it "should return full path to file" do
          FakeFS do
            create_filename("/path/to/files/searched_file.txt")
            search_path = SearchPath.new(["/path/to/files"])
            search_path.find!("searched_file.txt").should eq "/path/to/files/searched_file.txt"
          end
        end
      end
    end
  end

  private

  def create_filename(filename, content = "RESULT")
    create_dir(File.dirname(filename))
    File.open(filename, "w") { |file| file.write(content) }
  end

  def create_dir(dirname)
    FileUtils.mkdir_p(dirname)
  end

end
