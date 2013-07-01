require 'action_controller'


class ParamsGuardException < Exception
end



class ParamsGuardParameters < ActionController::Parameters

  def initialize(request_parameters, session)
    @session = session
    super(request_parameters)
  end



  def [](param, klass=nil)

    if klass
      process_guard(klass, param)
      return super(param)
    else
      return super(param)
    end
  end


  private #~~*~~*~~*~~*~~*~~*~~*~~*~~*


  def process_guard(klass, param)

    model = Kernel.const_get(klass.to_s)
    callback = "params_guard"
    model.send(callback, param, @session) or
    raise "#{klass}.#{callback} didn't return true"

  end


end



# class ParamsGuardParameters
module ParamsGuard

  # def initialize(old_params)
  #   @old_params = old_params
  # end


  # def [](param, klass=nil)

  #   return @old_params[param] unless klass # user wants original params

  # end

  # Returns a new ActionController::Parameters object that
  # has been instantiated with the <tt>request.parameters</tt>.
  def params
    @_params ||= ParamsGuardParameters.new(request.parameters, request.session)
  end

end


  ActionController::Base.send :include, ParamsGuard


# class ActionController::Base

#   # seems we need to use a before filters because params doesn't exist yet
#   # before_action :setup


#   alias old_params params

#   def params
#     ParamsGuardParameters.new(old_params)
#   end

#   # def setup
#   #   clog params.class
#   # end

# end





# ActiveSupport.on_load :action_controller do
#   $stderr.puts 'on load'
#   ActionController::Base.send :include, ParamsGuard
# end

# ActiveSupport.on_load :action_view do
#   ActionView::Base.send :include, ParamsGuard
# end



# class ActionController::Parameters

#   alias_method :original, :[]

#   def [](param, klass=nil)


#     if klass # user wants us to run klass.func(params, session)

#       clog klass

#       # session = ActionDispatch::Request.new
#       clog session.class


#       model = Kernel.const_get(klass.to_s)
#       callback = "params_guard"
#       model.send(callback, param, session) or
#         raise "#{klass}.#{callback} didn't return true"

#     end


#     original(param)

#   end




# end # module ParamsGuard


# class ActionController::Base
#   include ParamsGuard
# end


# class ActionView::Base
#   include ParamsGuard
# end



# module ParamsPlus

#   def p(key, klass=nil)

#     param = params[key].strip if params[key]

#     if klass # user wants us to run Klass.func(params, session)
#       model = Kernel.const_get(klass.to_s)
#       func = "params_guard"
#       model.send(func, param, session) or
#         raise "#{klass}.#{func} didn't return true"
#     end

#     return param

#   end

# end


# class ActionController::Base
#   include ParamsPlus
# end


# class ActionView::Base
#   include ParamsPlus
# end
