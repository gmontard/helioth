module Helioth

  class ControllerResource

    def self.add_before_filter(controller_class, method, *args)
      feature = args.first
      options = args.extract_options!

      before_filter_method = options.delete(:prepend) ? :prepend_before_filter : :before_filter
      controller_class.send(:before_filter, options.slice(:only, :except, :if, :unless)) do |controller|
        ControllerResource.new(controller, feature, (options.slice(:action, :actions)).values).send(method)
      end
    end

    def initialize(controller, feature, *actions)
      @controller = controller
      @feature = feature
      @actions = actions.flatten
    end

    def load_and_authorize_for
      unless @controller.access_to?(@feature, @actions)
        ##TODO change the behavior based on rails env
        Rails.logger.info("Access to controller forbidden for feature :#{@feature}")
        @controller.render :text=>"Access forbidden", :status=>403
      else
        Rails.logger.debug("Access to controller granted for feature :#{@feature}")
        Rails.logger.debug("Access to controller granted for actions #{@actions.inspect}") if @actions.present?
      end
    end

  end

end
