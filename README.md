params_guard
============

Are you paranoid about nefarious data in your params?

In Gemfile:

    gem "params_guard"


when a URL like this is accessed

    http://somewhere.com/show_thing/123

instead of

    thing_id = params[:id]

use

    thing_id = params[:id, Thing]


Along with returning thing_id, a callback in the Thing model is run, and is
expected to return true.  If it doesn't return true, it raises a
ParamsGuardException. Put whatever you want in there.  Here's an example of
checking if the id belongs to the current sessions account, which is found in
session[:aid] 


    def self.params_guard(key, params, session)

      where(id: params[:key], account_id: session[:aid]).any?

    end


Now you can safely do simple ActiveRecord lookups,

Instead of this, in thing_controller.rb, where a bud guy can pass in a thing id that doesn't
belong to him

    def edit
      @thing = Thing.find(params[:id])
    end

Do this

    def edit
      @thing = Thing.find(params[:id, Thing])
    end

If the bad guy passes in an thing id that doesnt belong to account, instead of seeing
private information, he'll get a rails error screen.
