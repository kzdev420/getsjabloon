# Add/remove as needed per your app
parameters = if Rails.env.development?
                %i(password)
             else
                %i(
                  password
                  password_confirmation
                  email
                  name
                  first_name
                  last_name
                  address
                  phone
                  hash_id
                  user_id
                  token
                  payload
                  current_sign_in_ip
                  last_sign_in_ip
                )
             end

Rails.application.config.filter_parameters += parameters
