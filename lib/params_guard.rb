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
      process_guard(klass, self, param)
      return super(param)
    else
      Rails.logger.debug '======================'
      Rails.logger.debug "param #{param}"
      Rails.logger.debug "klass #{klass}"
      Rails.logger.debug "before super(#{param})"
      Rails.logger.debug super(param)
      Rails.logger.debug 'after super(param)'
      return super(param)
    end

  end


  private #~~*~~*~~*~~*~~*~~*~~*~~*~~*


  def process_guard(klass, params, param)

    model = Kernel.const_get(klass.to_s)

    unless model.send(:params_guard, param, params, @session)

      message = "#{klass}.params_guard didn't return true\n" +
        "key: #{param}\nparams: #{params}\nsession: #{@session.inspect}"

        Rails.logger.error message

      raise ParamsGuardException, message

    end

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
