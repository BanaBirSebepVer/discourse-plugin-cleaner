module PluginCleaner
  class Report

    def self.generate(scan_result)
      {
        timestamp: Time.now,
        summary: {
          total_custom_fields: scan_result[:custom_fields].length,
          suspicious_fields: scan_result[:custom_fields].select { |f| f[:count] < 5 }
        },
        recommendation: build_recommendation(scan_result)
      }
    end

    def self.build_recommendation(data)
      data[:custom_fields].map do |f|
        if f[:count] < 3
          "POTENTIAL ORPHAN: #{f[:field]}"
        end
      end.compact
    end
  end
end