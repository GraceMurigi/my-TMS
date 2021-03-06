from wtforms import Form, BooleanField, StringField, TextAreaField, PasswordField, validators, SelectField
from wtforms.validators import InputRequired, Email, Length

#user sign up 
class managerSignupForm(Form):
	#account = SelectField('Account Type:', choices =[('T','Tenant'), ('RM', 'Rental Manager')])
	first_name = StringField('First Name:',[validators.Length(min=1, max= 50),
		validators.DataRequired()])
	last_name = StringField('Last Name:',[validators.Length(min=1, max= 50),
		validators.DataRequired()])
	email = StringField('Email:',[validators.Email(), validators.DataRequired()])
	phone_number = StringField('Phone Number:', [validators.Length(min=5, max= 15),]) 
	company = StringField('Company/Agency:', [validators.Length(min=5, max= 50), validators.DataRequired()])
	password = PasswordField('Password:',[
		validators.DataRequired(),
		validators.EqualTo('confirm',message ='Passwords do not match')
		])
	confirm = PasswordField('Confirm Password:')

class tenantSignupForm(Form):
	first_name = StringField('First Name:',[validators.Length(min=1, max= 50),
		validators.DataRequired()])
	last_name = StringField('Last Name:',[validators.Length(min=1, max= 50),
		validators.DataRequired()])
	email = StringField('Email:',[validators.Email(), validators.DataRequired()])
	phone_number = StringField('Phone Number:', [validators.Length(min=5, max= 15),]) 
	password = PasswordField('Password:',[
		validators.DataRequired(),
		validators.EqualTo('confirm',message ='Passwords do not match')
		])
	confirm = PasswordField('Confirm Password:')

class managerLoginForm(Form):
	email = StringField('Email',[validators.Email(), validators.DataRequired()])
	password = PasswordField('Password', [validators.DataRequired()])

class tenantloginForm(Form):
	email = StringField('Email',[validators.Email(), validators.DataRequired()])
	password = PasswordField('Password', [validators.DataRequired()])

#maintenace form 
class maintenaceForm(Form):
	maintenance = SelectField('Maintenance Type:', choices =[('P','Plumbing'), ('F', 'Flooring'),('R','Roofing'),('P','Painting'),('O','Other')])
	description = TextAreaField ('Description:',[validators.Length(min=1, max= 200),
		validators.DataRequired()])
	
	




