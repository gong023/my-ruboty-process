require 'everlog'

module Ruboty
  module Handlers
    class Everlog < Base
      on(
          /today/i,
          name: "post_today",
          description: "post online activity log"
      )

      def post_today(message)
        everlog = ::Everlog::Daily.new

        wunderground_option = tokens(:wunderground, :access_token)
        if ! wunderground_option.nil? && ! wunderground_option.empty?
          message.reply '(・8・)ﾃﾝｷ'
          everlog.push(:weather, wunderground_option)
        end

        twitter_option = tokens(:twitter, :consumer_key, :consumer_secret, :access_token, :access_secret)
        if ! twitter_option.nil? && ! twitter_option.empty?
          message.reply '(・8・)ﾂｲｯﾀ'
          everlog.push(:twitter, twitter_option)
        end

        hatena_option = tokens(:hatena, :consumer_key, :consumer_secret, :access_token, :access_secret)
        if ! hatena_option.nil? && ! hatena_option.empty?
          message.reply '(・8・)ﾊﾃﾅ'
          everlog.push(:hatena, hatena_option) 
        end

        github_option = tokens(:github, :consumer_key, :consumer_secret, :access_secret)
        if ! github_option.nil? && ! github_option.empty?
          message.reply '(・8・)ｷﾞｯﾊﾌﾞ'
          everlog.push(:github, github_option)
        end

        moves_option = tokens(:moves, :access_token)
        if ! moves_option.nil? && ! moves_option.empty?
          message.reply '(・8・)ﾑﾌﾞｽﾞ'
          message.reply ENV['EVERLOG_MOVES_ACCESS_TOKEN']
          everlog.push(:moves, moves_option) 
        end

        animetick_option = tokens(:animetick, :access_token, :access_secret)
        if ! animetick_option.nil? && ! animetick_option.empty?
          message.reply '(・8・)ｱﾆﾒﾁｸ'
          everlog.push(:animetick, animetick_option)
        end

        everlog.publish(title, ENV['EVERLOG_EVERNOTE_ACCESS_SECRET'], 'production')

        message.reply '(・8・)ｵﾜﾘ'
      rescue => e
        message.reply(e.message)
      end

      def tokens(service, *keys)
        keys.inject({}) do |option, key|
          env_key = "EVERLOG_#{service.upcase}_#{key.upcase}"
          ENV[env_key].nil? ? next : option[key] = ENV[env_key]
          option
        end
      end

      def title
        weekday = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat']
        yesterday = Date.today - 1
        "Lifelog #{yesterday.to_s.gsub(/-/, '/')}(#{weekday[yesterday.wday]})"
      end
    end
  end
end
