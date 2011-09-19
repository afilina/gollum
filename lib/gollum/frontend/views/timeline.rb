module Precious
  module Views
    class Timeline < Layout
      attr_reader :page, :page_num

      def title
        "Timeline"
      end

      def commits
        commits = []
        @entries.each do |v|
          file_name = v.show[0].b_path.split('/').pop()
          page_name = Gollum::Page.canonicalize_filename(file_name)
          page_link = Gollum::Page.cname(page_name)
          commits.push(
            { :id       => v.id,
              :id7      => v.id[0..6],
              :author   => v.author.name,
              :message  => v.message,
              :page_name=> page_name,
              :page_link=> page_link,
              :date     => v.committed_date.strftime("%B %d, %Y"),
              :gravatar => Digest::MD5.hexdigest(v.author.email) }
          )
        end
        
        return commits
      end

      def previous_link
        label = "&laquo; Previous"
        if @page_num == 1
          %(<span class="disabled">#{label}</span>)
        else
          %(<a href="/timeline?page=#{@page_num-1}" hotkey="h">#{label}</a>)
        end
      end

      def next_link
        label = "Next &raquo;"
        if @versions.size == Gollum::Page.per_page
          %(<a href="/timeline?page=#{@page_num+1}" hotkey="l">#{label}</a>)
        else
          %(<span class="disabled">#{label}</span>)
        end
      end
    end
  end
end
