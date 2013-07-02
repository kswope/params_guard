require 'action_controller'


class ParamsGuardException < RuntimeError
end



class ParamsGuardParameters < ActionController::Parameters


  def initialize(request_parameters, session)

    # session wont be available in ActionController::Parameters so we will
    # store it here.
    @session = session
    super(request_parameters)

  end


  def [](param, klass=nil)

    if klass
      value = super(param)
      process_guard(klass, value)
      return value
    else
      return super(param)
    end

  end


  private #~~*~~*~~*~~*~~*~~*~~*~~*~~*


  def process_guard(klass, param)

    model = Kernel.const_get(klass.to_s)
    model.send(:params_guard, param, @session) or
    raise "#{klass}.params_guard didn't return true"

  end


end



module ParamsGuard

  # Ripped off from StrongParameters source.
  # 
  # Returns a new ActionController::Parameters object that has been
  # instantiated with the <tt>request.parameters</tt>.
  def params
    @_params ||= ParamsGuardParameters.new(request.parameters, request.session)
  end

end


ActionController::Base.send :include, ParamsGuard

