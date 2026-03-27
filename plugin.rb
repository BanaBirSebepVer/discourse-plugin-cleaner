# name: discourse-plugin-cleaner
# about: Scans orphan plugin data and custom fields safely
# version: 0.1
# authors: canbekcan

enabled_site_setting :plugin_cleaner_enabled

after_initialize do
  module ::PluginCleaner
    PLUGIN_NAME = "plugin-cleaner"
  end

  require_relative "lib/plugin_cleaner/scanner"
  require_relative "lib/plugin_cleaner/report"

  Discourse::Application.routes.append do
    get "/admin/plugin-cleaner" => "plugin_cleaner#index"
    get "/admin/plugin-cleaner/scan" => "plugin_cleaner#scan"
  end

  class ::PluginCleaner::AdminController < ::Admin::AdminController
    def index
      render json: { status: "ok", message: "Plugin Cleaner Active" }
    end

    def scan
      result = PluginCleaner::Scanner.run
      render json: result
    end
  end
end