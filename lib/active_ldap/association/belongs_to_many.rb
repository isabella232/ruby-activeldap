require 'active_ldap/association/collection'

module ActiveLdap
  module Association
    class BelongsToMany < Collection
      private
      def insert_entry(entry)
        new_value = entry[@options[:many], true]
        new_value += @owner[@options[:foreign_key_name], true]
        entry[@options[:many]] = new_value.uniq
        entry.save
      end

      def find_target
        key = @options[:many]
        filter = @owner[@options[:foreign_key_name], true].reject do |value|
          value.nil?
        end.collect do |value|
          "(#{key}=#{value})"
        end.join
        foreign_class.find(:all, :filter => "(|#{filter})")
      end
    end
  end
end
