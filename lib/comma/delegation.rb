module Comma
  module Delegation
    def delegate(*methods, to:)
      target = 
        case to
        when Symbol then -> { send(to) }
        when String then -> { eval(to) }
        when Proc   then to 
        else -> { to }
        end

      methods.each do |method|
        define_method(method) { instance_exec(&target).public_send(method) }
      end
    end
  end
end
