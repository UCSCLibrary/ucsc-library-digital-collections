class WorksMailer < ActionMailer::Base
	default from: Hyrax.config.contact_email

	def work_link_email(message)
		@to = message[:to]
		@title = message[:subject]
		mail(to: @to, subject: @title)
  end
end
