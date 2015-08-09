require 'middleman-core'
require 'middleman-core/renderers/redcarpet'

module Middleman
  module Renderers
    # Monkey patching in; credits to: https://github.com/hashicorp/middleman-hashicorp
    class MiddlemanRedcarpetHTML

      #
      # Override block_html to support parsing nested markdown blocks.
      #
      # @param [String] raw
      #
      def block_html(raw)
        raw = unindent(raw)

        if md = raw.match(/\<(.+?)\>(.*)\<(\/.+?)\>/m)
          open_tag, content, close_tag = md.captures
          "<#{open_tag}>\n#{recursive_render(unindent(content))}<#{close_tag}>"
        else
          raw
        end
      end

      #
      # Override paragraph to support custom alerts.
      #
      # @param [String] text
      # @return [String]
      #
      def paragraph(text)
        add_alerts("<p>#{text.strip}</p>\n")
      end

      private

      #
      # Remove any special characters from the anchor name.
      #
      # @example
      #   anchor_for("this") #=> "this"
      #   anchor_for("this is cool") #=> "this_is_cool"
      #   anchor_for("this__is__cool!") #=> "this__is__cool_"
      #
      #
      # @param [String] text
      # @return [String]
      #
      def anchor_for(text)
        text.gsub(/[^[:word:]]/, '_').squeeze('_')
      end

      #
      # This is jank, but Redcarpet does not provide a way to access the
      # renderer from inside Redcarpet::Markdown. Since we know who we are, we
      # can cheat a bit.
      #
      # @param [String] markdown
      # @return [String]
      #
      def recursive_render(markdown)
        Redcarpet::Markdown.new(self.class).render(markdown)
      end

      #
      # Add alert text to the given markdown.
      #
      # @param [String] text
      # @return [String]
      #
      def add_alerts(text)
        map = {
          '=&gt;' => 'success',
          '-&gt;' => 'info',
          '~&gt;' => 'warning',
          '!&gt;' => 'danger',
        }

        regexp = map.map { |k, _| Regexp.escape(k) }.join('|')

        if md = text.match(/^<p>(#{regexp})/)
          key = md.captures[0]
          klass = map[key]
          text.gsub!(/#{Regexp.escape(key)}\s+?/, '')

          return <<-EOH.gsub(/^ {12}/, '')
            <div class="alert alert-#{klass}" role="alert">
            #{text}</div>
          EOH
        else
          return text
        end
      end

      def unindent(string)
        string.gsub(/^#{string.scan(/^[[:blank:]]+/).min_by { |l| l.length }}/, "")
      end

    end
  end
end
