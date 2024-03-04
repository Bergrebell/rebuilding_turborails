module TurboClone
  class Engine < ::Rails::Engine
    isolate_namespace TurboClone

    initializer "turbo.media_type" do
      Mime::Type.register "text/vnd.turbo-stream.html", :turbo_stream
    end

    initializer "turbo.helper" do
      # Runs when action controller base is included
      ActiveSupport.on_load :action_controller_base do
        # include all helpers
        helper TurboClone::Engine.helpers
      end
    end
  end
end
