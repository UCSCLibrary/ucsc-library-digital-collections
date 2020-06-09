class WorksMailer < ActionMailer::Base
	default from: Hyrax.config.contact_email

	def work_link_email(message)
		@message = message
		mail(to: message[:to], subject: message[:subject])
  end
end
