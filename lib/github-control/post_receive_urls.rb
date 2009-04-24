module GithubControl
  class PostReceiveUrls
    include Enumerable

    def initialize(repository)
      @repository = repository
    end
    attr_reader :repository

    def <<(url)
      update_with(set + [url])
    end

    def delete(url)
      update_with(set - [url])
    end

    def clear
      update_with([])
    end

    def update_with(urls)
      form_data = []
      urls.each do |url|
        value = URI.escape(url.to_s, Regexp.new("[^#{URI::PATTERN::UNRESERVED}]"))
        form_data << "urls[]=#{value}"
      end
      @repository.owner.cli.scrape_post("/#{@repository.owner.name}/#{@repository.name}/edit/postreceive_urls",
                                        form_data.join("&"), :accept => 'text/javascript')
    end

    def empty?
      set.empty?
    end

    def each(&block)
      set.each(&block)
    end

    def set
      set = []
      doc = Nokogiri::HTML(html_data)
      doc.search("fieldset#postreceive_urls.service-hook form p input[name='urls[]']").each do |input|
        set << input["value"] if input["value"]
      end
      set
    end

    def html_data
      @repository.owner.cli.scrape_get("/#{@repository.owner.name}/#{@repository.name}/edit/hooks")
    end
  end
end

