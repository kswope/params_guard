



class ParamsGuardParameters < ActiveSupport::HashWithIndifferentAccess

  def [](key, klass = nil)

    puts "key: #{key}"
    puts "klass: #{klass}"

    if super(key).is_a?(Hash)
      # this is for chains, like hash[:a][:b][:c, Doc]
      return self.class[super(key)]
    else
      return super(key)
    end



  end

end




PARAMS = {:a => {:b => 1}, :c => 2}
pg = ParamsGuardParameters[PARAMS]


puts pg[:a][:b, Object]
