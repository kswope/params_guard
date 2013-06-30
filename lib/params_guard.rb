require 'action_controller'


class ParamsGuardException < Exception
end



class ActionController::Parameters

  alias_method :original, :[]

  def [](param, klass=nil)


    if klass # user wants us to run klass.func(params, session)

      # session = ActionDispatch::Request.new(@env)
      clog self.class.superclass

      model = Kernel.const_get(klass.to_s)
      callback = "params_guard"
      model.send(callback, param, session) or
        raise "#{klass}.#{callback} didn't return true"
    end


    original(param)

  end




end # module ParamsGuard


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