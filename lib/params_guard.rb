require 'action_controller'


class ParamsGuardException < RuntimeError
end



class ParamsGuardParameters < Hash


  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # subclassing a hash is weird, here's the 'initializer'
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  def self.[](parameters, session)

    @@session = session

    super(parameters)

  end


  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  #
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  def [](key, model = nil)

    key = key.to_s # very important, params values are always strings

    if super(key).is_a?(Hash) # recursion'ish

      # this is for chains, like hash[:a][:b][:c, Doc]
      return self.class[super(key), @@session]

    else

      unless model # then figure out the model we are supposed to use

        controller =  super('controller')

        klass = controller.singularize.capitalize

        begin
          model = Kernel.const_get(klass.to_s)
        rescue NameError
          message = "Couldn't figure out model from controller, "
          message <<  "tried #{klass} but it doesn't exist"
          log_and_raise(message)
        end

      end

      process_guard(model, key, super(key))

      return super(key)

    end

  end


  private #~~*~~*~~*~~*~~*~~*~~*~~*~~*


  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  #
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  def process_guard(model, key, value)


    unless model.send(:params_guard, key, value, @@session)

      message = "*** Error: #{model}.params_guard didn't return true\n"
      message << "key: #{key} (a string!)\n"
      message << "value: #{value}\n"
      # message << "session: #{@@session.inspect}"

      log_and_raise(message)

    end

  end


  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  #
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  def log_and_raise(message)

    Rails.logger.error message
    raise ParamsGuardException, message

  end



end



module ParamsGuard

  def pg
    @_pg_params ||=
      ParamsGuardParameters[request.parameters, request.session]
  end

end


ActionController::Base.send :include, ParamsGuard
ActionView::Base.send :include, ParamsGuard
