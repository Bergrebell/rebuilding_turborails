require "turbo_clone/test_assertions"

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
        include TurboClone::Streams::TurboStreamsTagBuilder
        helper TurboClone::Engine.helpers
      end
    end

    initializer "turbo.renderer" do
      ActiveSupport.on_load :action_controller do
        ActionController::Renderers.add :turbo_stream do |turbo_streams_html, options|
          turbo_streams_html
        end
      end
    end

    initializer "turbo.test_assertions" do
      ActiveSupport.on_load :active_support_test_case do
        include TurboClone::TestAssertions
      end
    end

    initializer "turbo.integration_test_request_encoding" do
      ActiveSupport.on_load :action_dispatch_integration_test do
        class ActionDispatch::RequestEncoder
          class TurboStreamEncoder < IdentityEncoder
            header = [Mime[:turbo_stream], Mime[:html]].join(",")
            define_method(:accept_header) { header }
          end

          @encoders[:turbo_stream] = TurboStreamEncoder.new
        end
      end
    end
  end
end
