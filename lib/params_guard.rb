require 'action_controller'


class ParamsGuardException < RuntimeError
end



class ParamsGuardParameters < ActiveSupport::HashWithIndifferentAccess


  def initialize(parameters, session)

    @@session ||= session

    super(parameters) # self is a hash, this will load it up

  end


  def [](key, model = nil)

    if super(key).is_a?(Hash)

      # this is for chains, like hash[:a][:b][:c, Doc]
      return self.class.new(super(key), @@session)

    else

      if model
        clog "processing guard with #{model}"
        process_guard(model, key, super(key))
      end

      return super(key)

    end

  end


  private #~~*~~*~~*~~*~~*~~*~~*~~*~~*


  def process_guard(model, key, value)

    # model = Kernel.const_get(model.to_s)

    unless model.send(:params_guard, key, value, @@session)

      message = "*** Error: #{model}.params_guard didn't return true\n" +
        "key: #{key}\nvalue: #{value}\nsession: #{@@session.inspect}"

        Rails.logger.error message

      raise ParamsGuardException, message

    end

  end


end



module ParamsGuard

  def pg
    @_pg_params ||=
      ParamsGuardParameters.new(request.parameters, request.session)
  end

end


ActionController::Base.send :include, ParamsGuard
