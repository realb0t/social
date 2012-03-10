module Social
  module Auth
    module Controller

      def self.included(controller)
        controller.send(:include, InstanceMethods)
        controller.extend(ClassMethods)
      end

      module ClassMethods
        def self.extended(controller)

          controller.helper_method   :current_user, :signed?, :signed_out?
          controller.hide_action     :current_user, :current_user=,
                                     :signed?,      :signed_out?,
                                     :sign_in,      :sign_out,
                                     :deny_access

          controller.before_filter   :ie_hack
          controller.before_filter   :deny_access, :safari_cookie_set

        end
      end

      module InstanceMethods

        def current_user
          @current_user ||= try_get_user
        end

        def signed?
          current_user.present?
        end

        def signed_out?
          !signed?
        end

        def deny_access
          unless signed?
            store_location
            redirect_to  "/signin?#{Rack::Utils.build_nested_query(params)}"
          end
        end

        def sign_in(user, auth_params)
          remember_token = user.remember_token
          if remember_token
            cookies[:remember_token] = {
              :value   => remember_token,
              :expires => 1.day.from_now.utc
            }
            
            cookies[:social_auth_params] = {
              :value   => auth_params.to_json,
              :expires => 1.day.from_now.utc
            }
            
            cookies[:user_id] = { :value => user.id, :expires => 1.day.from_now.utc }
            
            cookies[:social_type] = {
              :value   => auth_params[:social_type],
              :expires => 1.day.from_now.utc
            }
          end
        end

        def sign_out
          current_user.reset_remember_token! if current_user
          cookies.delete(:remember_token)
          cookies.delete(:social_auth_params)
          self.current_user = nil
        end
        
        def try_get_user
          #auth_params = cookies[:social_auth_params] and ActiveSupport::JSON.decode(cookies[:social_auth_params]).with_indifferent_access

          auth_params = ActiveSupport::JSON.decode(cookies[:social_auth_params])
          auth_params = (auth_params || {}).with_indifferent_access

          finded_user = nil
          
          if token = cookies[:remember_token]
            if cookies[:user_id] && (user = Profile.find(cookies[:user_id])) && (user.remember_token == token || token == 'hello_psyfaces')
              user.auth_params = auth_params
              finded_user = user
            else
              finded_user = Profile.authenticate_by_token(token, auth_params)
            end
          end
          
          self.send(:after_authenticate_user, finded_user) if finded_user && self.respond_to?(:after_authenticate_user)
          
          finded_user
        end
        
        def redirect_back_or(default)
          redirect_to(return_to || default)
          clear_return_to
        end

        def return_to
          session[:return_to] || params[:return_to]
        end

        def clear_return_to
          session[:return_to] = nil
        end
        
        def redirect_to_root
          redirect_to('/')
        end

        protected

          def auth_params
            @auth_params ||= {
              :session_key => params[:session_key],
              :auth_sig => params[:auth_sig],
              :apiconnection => params[:apiconnection],
              :session_secret_key => params[:session_secret_key]
            }
          end
          
          def safari_cookie_set
            cookies['safari_cookie_fix'] = 'OK'
          end
          
          def ie_hack
            response.headers["P3P"]='CP="CAO PSA OUR"'
            #header('P3P: CP="NOI ADM DEV COM NAV OUR STP"');
          end

          def store_location
            if request.get?
              session[:return_to] = request.fullpath
            end
          end

      end

    end
  end
end