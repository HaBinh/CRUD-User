class User < ActiveRecord::Base

	def self.SendMailVerify(email, token)
		@user = User.find_by(:email => email)
		Pony.mail({
			to: email,
			via: 'smtp',
			subject: 'Verify your email address',
			body: "Hello " + @user.last_name + ", To activate your account you must first verify your email address by clicking this link:\n
							http://localhost:9393/verify?token=" + token,
			via_options: {
				address: 'smtp.gmail.com',
				port: '587',
				user_name: 'lethihabinh',
				password: 'lthbinh3996',
				authentication: :plain,
				domain: 'localhost:9393'
			}
		})
	end
end