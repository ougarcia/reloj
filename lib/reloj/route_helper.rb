module RouteHelper

  def RouteHelper.included(klass)
    klass.extend ClassMethods
  end

  #maybe add link_to and button_to here

  module ClassMethods

    def create_helper_methods(paths)
      paths.each do |path|
        create_helper_method(path)
      end
    end

    def create_helper_method(path)
      nouns = path.split('/')
      nouns.delete("")
      if nouns.any? { |noun| noun[0] == ":" }
        build_nested_route_helper(nouns)
      else
        method_name = nouns.join("_") + "_path"
        define_method(method_name) { path }
      end
    end

    def build_nested_route_helper(nouns)
      just_names = nouns.select { |noun| noun[0] != ":" }
      method_name = nouns.select do |noun|
        noun[0] != ":"
      end.join("_") + "_path"

      define_method(method_name) do |*ids|
        result = []
        just_names.each do |noun|
          result << noun
          result << ids.shift unless ids.empty?
        end
        result.join('/')
      end
    end
  end

end
