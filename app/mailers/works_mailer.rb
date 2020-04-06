class WorksMailer < ActionMailer::Base
	def sendwork(email_work)
		@email = email_work[:email]
		@title = email_work[:subject]
		@from = Hyrax.config.contact_email
    	mail(to: @email, from: @from, subject: @title)
  end
end


=begin

## This one is from app/mailers/hyrax/contact_mailer.rb
module Hyrax
  # Mailer for contacting the administrator
  class ContactMailer < ActionMailer::Base
    def contact(contact_form)
      @contact_form = contact_form
      # Check for spam
      return if @contact_form.spam?
      mail(@contact_form.headers)
    end
  end
end

=end
