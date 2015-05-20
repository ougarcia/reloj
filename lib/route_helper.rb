module RouteHelper

  def RouteHelper.included(klass)
    klass.extend ClassMethods
  end

  #maybe add link_to and button_to here

  module ClassMethods
    def build_attributes_from_route(route)
    end


    def build_attributes_from_parameters(parameters)
    end
  end

end
