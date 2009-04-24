require File.dirname(__FILE__) + '/../spec_helper'

describe "Post-receive URLs" do
  describe "for a repository with a single URL" do
    before(:each) do
      @repo = @console.current_user.repo_for("with-one-post-receive-url")
    end

    it "can be fetched" do
      @repo.post_receive_urls.to_a.should == ["http://github-control.r.spork.in/post-receive"]
    end
  end

  describe "for a repository with no URLs" do
    before(:each) do
      @repo = @console.current_user.repo_for("with-no-post-receive-urls")
      @repo.post_receive_urls.clear
    end

    it "can be fetched" do
      @repo.post_receive_urls.should be_empty
    end

    it "adds a new URL" do
      @repo.post_receive_urls << "http://example.org"
      @repo.post_receive_urls.to_a.should == ["http://example.org"]
    end
  end

  describe "for a repository with 3 URLs" do
    before(:each) do
      @repo = @console.current_user.repo_for("with-three-post-receive-urls")
      urls = ["http://example.com/1", "http://example.com/2", "http://example.com/3"]
      @repo.post_receive_urls.update_with(urls)
    end

    it "can be fetched" do
      @repo.post_receive_urls.to_a.should == ["http://example.com/1", "http://example.com/2", "http://example.com/3"]
    end

    it "adds a new URL" do
      @repo.post_receive_urls.delete("http://example.com/1")
      @repo.post_receive_urls.to_a.should == ["http://example.com/2", "http://example.com/3"]
    end
  end
end
