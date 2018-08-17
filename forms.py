from wtforms import Form, BooleanField, StringField, DateTimeField, TextAreaField, PasswordField, SelectField, IntegerField, FileField, validators
from wtforms.validators import InputRequired, Email, Length

#user sign up 
class SignupForm(Form):
	account = SelectField('Account Type', choices =[('T','Tenant'), ('RM', 'Rental Manager')])
	first_name = StringField('First Name',[validators.Length(min=1, max= 50),
		validators.DataRequired()])
	last_name = StringField('Last Name',[validators.Length(min=1, max= 50),
		validators.DataRequired()])
	email = StringField('Email',[validators.Email(), validators.DataRequired()])
	phone_number = StringField('Phone Number', [validators.Length(min=5, max= 15),]) 
	password = PasswordField('Password',[
		validators.DataRequired(),
		validators.EqualTo('confirm',message ='Passwords do not match')
		])
	confirm = PasswordField('Confirm Password')
#App throws an error that form requires a multidict type on passing request.method
class ReportForm(Form):
	report_type = SelectField(
		choices =[("users","View all users in the system"),
		("occupant","View all tenants"),
		("units","View all units"),
		("property",'View property report'),
		('is_available','View vacant units'),
		('occupied','View occupied units')])
	from_date = DateTimeField('start from')
	end_date = DateTimeField('End Date')
class LoginForm(Form):
	email = StringField('Email',[validators.Email(), validators.DataRequired()])
	password = PasswordField('Password', [validators.DataRequired()])

#maintenace form 
class maintenaceForm(Form):
	maintenance = SelectField('Maintenance Type', choices =[('P','Plumbing'), ('F', 'Flooring'),('R','Roofing'),('P','Painting'),('O','Other')])
	description = TextAreaField ('Description',[validators.Length(min=1, max= 200),
		validators.DataRequired()])
	
class propertyForm(Form):
	name = StringField('Property name', [validators.Length(min=1, max=200),
		validators.DataRequired()])
	# purpose = SelectField ('Property type', choices =[('residential','Residential'), ('commericial', 'Commercial')])
	address = TextAreaField('Address', [validators.Length(min=1, max= 200),
		validators.DataRequired()])
	units = StringField('Number of Units', [validators.Length(min=1, max=200),
		validators.DataRequired()])
	

class unitsForm(Form):
	unit_name = StringField('Unit Name', [validators.Length(min=1, max=200),
		validators.DataRequired()])
	features = TextAreaField('Unit Features',[validators.Length(min=1, max= 500),
		validators.DataRequired()])
	is_available = SelectField("Occupied",  choices =[('N','No'),('Y','Yes')])
	is_reserved = SelectField("Occupied",  choices =[('N','No'),('Y','Yes')])
class ManagerForm(Form):
	email = StringField('Work Email', [validators.Email(), validators.DataRequired()])
	phone = StringField('Work Telephone Number', [validators.Length(min=1, max=200),
		validators.DataRequired()])
	document_number = StringField('Identification Document Number')

	
# class TenantForm(Form):
# 	proof_document = SelectField('Identification Document:', choices=[('National ID', 'National ID Card'), ('Drivers License', 'Drivers License'),
# 		('Passport','Passport'), ('Company Registration', 'Company Registration')]) 
# 	document_number = StringField('Identification Document Number:', [validators.Length(min=5, max=20),
# 		validators.DataRequired()])

class bookingForm(Form):
	
	proof_document = SelectField('Identification Document', choices=[('National ID', 'National ID Card'), ('Drivers License', 'Drivers License'),
		('Passport','Passport'), ('Company Registration', 'Company Registration Certificate')]) 
	document_number = StringField('Identification Document Number', [validators.Length(min=5, max=20),
		validators.DataRequired()])
	

class BillForm(Form): 
	invoice_number = StringField ('Invoice Number', [validators.Length(min=1, max=50),
		validators.DataRequired()])
	invoice = FileField('Upload Invoice',[validators.DataRequired()])





