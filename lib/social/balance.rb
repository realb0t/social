module Social
  module Balance

    # @deprecated
    def self.included(base)
      base.instance_eval do
        
        include ::Balance::Observer
        with_balance :charge_off_callback => :charge_off_callback

        # Списание средств если нужно извещать 3ю сторону
        # TODO: переделать на транзакции
        def charge_off_callback(money)
          soc_type = Social.type_by_id(current_social_type_id)
          network = Social::Network(soc_type)
          #if network && network.respond_to?(:rate) && network.rate != 1
          if soc_type.to_sym == :vk
            result = network.user.charge_off_balance(current_uid, money)
          end
        end

      end
    end

  end

end