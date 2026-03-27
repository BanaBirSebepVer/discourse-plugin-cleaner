module PluginCleaner
  class Scanner

    def self.run
      {
        custom_fields: scan_custom_fields,
        site_settings: scan_site_settings
      }
    end

    def self.scan_custom_fields
      fields = UserCustomField.pluck(:name).uniq

      grouped = fields.map do |f|
        {
          field: f,
          count: UserCustomField.where(name: f).count
        }
      end

      grouped.sort_by { |x| -x[:count] }
    end

    def self.scan_site_settings
      SiteSetting.all_settings.select do |k, _|
        k.to_s.include?("plugin") || k.to_s.include?("custom")
      end
    end
  end
end