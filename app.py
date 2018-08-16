from flask import Flask, render_template, request, redirect, url_for, flash, session, logging
from passlib.hash import sha256_crypt
from flask_mysqldb import MySQL
from forms import SignupForm, LoginForm, maintenaceForm, propertyForm, unitsForm, ManagerForm, BillForm, bookingForm
#import flask_excel as excel



app = Flask(__name__)
#Bootstrap(app)

app.secret_key ="Whatdoyouthink123"
#configure mysql
app.config['MYSQL_HOST'] = 'localhost'
app.config['MYSQL_USER'] = 'griffin'
app.config['MYSQL_PASSWORD'] = ''
app.config['MYSQL_DB'] = 'tenant_management'
app.config['MYSQL_CURSORCLASS'] = 'DictCursor'

#initializing mysql
mysql = MySQL(app)

# The intro routes are home, about, contact us, signup and login 

#home
@app.route('/')
def index():
	return render_template ("index.html")

#about 
@app.route ('/about')
def about():
	return render_template('about.html')

#contact us 
@app.route ('/contactus')
def contact():
	return render_template ('contact.html')

#sign up 
@app.route('/signup', methods=['GET','POST'])
def Signup():
	form = SignupForm(request.form)
	if request.method == 'POST' and form.validate():
		account = form.account.data
		first_name = form.first_name.data 
		last_name = form.last_name.data
		email = form.email.data
		phone_number = form.phone_number.data
		password = sha256_crypt.encrypt(str(form.password.data))


		try:
			#create cursor
			cur = mysql.connection.cursor()

			# Execute query
			cur.execute("INSERT INTO users (account, first_name, last_name, email, phone_number, password)VALUES (%s, %s, %s, %s, %s, %s)",(
				account, first_name, last_name, email, phone_number, password))
		

			#commit to the database
			mysql.connection.commit()
			
		except Exception as e:
			flash( 'Signup error!: {}', format(e))
			return render_template('Signup.html', form = form)
			
		finally:
			#close connection
			cur.close()


		flash("Signup successful!", "success")
		return redirect(url_for('Login'))
	return render_template('signup.html', form=form)

# login 
@app.route('/login', methods=['GET','POST'])
def Login():
	if session.get('logged_in'):
		flash("You are already logged in",'warning')
		return redirect(url_for('Dashboard'))
	form = LoginForm(request.form)
	if request.method == 'POST' and form.validate():
		email = form.email.data 
		password_candidate = form.password.data

		#create cursor 
		cur = mysql.connection.cursor()

		#get user by email 
		result = cur.execute("SELECT * FROM users WHERE email = %s", [email])

		if result > 0:

			#get first one with required credentials 
			data = cur.fetchone()
			password = data ['password']

			#compare passwords 
			if sha256_crypt.verify(password_candidate,password):
				#passed
					session['logged_in']= True
					name = cur.execute("SELECT * FROM users WHERE email = %s", [email])
					name = cur.fetchall()
					session['user_id']= name[0]['user_id']
					

					account_type = cur.execute("SELECT account FROM users WHERE email = %s", [email])
					if account_type > 0:
						data = cur.fetchall()
						account = data[0]['account']
						if account == "RM":
							session["RM"] = name[0]['first_name']
							flash('Welcome to your Tenant Manager account','success')
							return redirect(url_for('Dashboard'))

						elif account == "T":
							session["T"] = name[0]['first_name']
							flash('Welcome to your tenant account','success')
							return redirect(url_for('Dashboard'))
						else:
							session["Admin"] = name[0]['first_name']
							flash('Welcome to your Admin portal','success')
							return redirect(url_for('Dashboard'))
			

			else: 
				error = 'INVALID LOGIN CREDENTIALS'
				return render_template('Login.html', error=error, form=form)
	 				#app.logger.info("PASSWORD NOT MATCHED!")
				#close connection 
				cur.close()   

		#else: 
			#error = 'USER NOT FOUND!'
			#return render_template('login.html')

	return render_template ('Login.html', form=form)

# how to access account and log out 
# Dashboard route
@app.route('/Dashboard')
def Dashboard():
	if session.get('RM'):
		return render_template('RMdashboard.html')
	elif session.get('T'):
		return render_template('Tdashboard.html')
	elif session.get('Admin'):
		return render_template('admindashboard.html')
	else:
		flash('Sorry, you need to log in first', 'warning')
		return redirect(url_for('index'))
	flash("You are not logged in, Kindly log in first", 'danger')
	return redirect(url_for('index'))

#logout 
@app.route('/logout')
def logout ():
	session.clear()
	flash('You are now logged out','danger')
	return redirect(url_for('index'))

# routes to navigate rental manager dashboard

#FAQS
@app.route('/learnmore')
def Learn():
	# if session.get('logged_in'):

	return render_template('FAQ.html')


# add new property 
@app.route('/propertyform', methods=['GET', 'POST'])
def addProperty():
	if session.get('user_id'):
		
		form =propertyForm(request.form)
		if request.method == 'POST' and form.validate():
			name = form.name.data
			address = form.address.data
			units = form.units.data
			
			try:
				#create cursor
				cur = mysql.connection.cursor()
				print("all is good")

				# Execute query
				cur.execute("INSERT INTO property (name, address, units_managed, manager)VALUES (%s, %s, %s, %s)",(
					name, address, units, session['user_id']))
	

				#commit to the database
				mysql.connection.commit()
				flash('Property added!', 'success')
				#close connection

			except Exception as e:
				flash("Sorry! property name already exists. Please create a unique name ", "warning")
				print(e)
			
			finally:
				cur.close()
			
			return redirect(url_for('myProperty'))
	return render_template('addproperty.html', form=form)

#view property
@app.route('/viewproperty', methods=['GET', 'POST'])
def myProperty():
	if session.get('user_id'):
		try:
			cur = mysql.connection.cursor()
			print('no error')
			#get properties by using his user_id in the property table
			
			cur.execute("SELECT * FROM property WHERE manager = %s", (session['user_id'], ))

			# if result > 0:
			# 	flash("Yeepy some data exists")
			data = cur.fetchall()
				# else:
				# 	flash("Sorry, tenant manager data doesn't exist")

		except Exception as e:
			flash('Kindly add a property first')
			print(e)
			print('error somewhere')
			
		finally:
			cur.close()
			return render_template('propertylist.html', data = data)
	return redirect(url_for('Login'))

#add unit 
@app.route('/unitsform/<ren_id>', methods=['GET', 'POST'])
def addUnits(ren_id):
		
	form =unitsForm(request.form)
	if request.method == 'POST' and form.validate():
		unit_name = form.unit_name.data
		is_available = form.is_available.data
		is_reserved = form.is_reserved.data
		features = form.features.data
		
		try:
			#create cursor
			cur = mysql.connection.cursor()
			
			# Execute query
			cur.execute("INSERT INTO units (property, unit_name, features, is_available, is_reserved)VALUES (%s, %s, %s, %s, %s)",
				(ren_id, unit_name, features, is_available, is_reserved))

			print("working")
			#commit to the database
			mysql.connection.commit()
			flash('Unit added successfully!', 'success')
			#close connection

		except Exception as e:
			flash("Sorry, please fill out all fields", "warning")
			print("error")
			print(e)
		
		finally:
			cur.close()
		
		return redirect(url_for('viewUnits', ren_id = ren_id))
	return render_template('addunit.html', form=form, ren_id = ren_id)

#view units 
@app.route('/viewunits/<ren_id>')
def viewUnits(ren_id):
	if session.get('user_id'):
		try:
			cur = mysql.connection.cursor()
			print('no error')
			result = cur.execute("SELECT * FROM units WHERE property = %s", (ren_id, ))

			if result > 0:
				flash("Yeepy some data exists")
				data = cur.fetchall()
			else:
				flash("Sorry no data for the manager")
		except Exception as e:
			flash('No units to display')
			print(e)
			print('error somewhere')
			
		finally:
			cur.close()
			return render_template('unitlist.html', data = data, ren_id = ren_id)
	return redirect(url_for('Login'))
#view property
@app.route('/viewapplicants', methods=['GET', 'POST'])
def unit_applicants():
	if session.get('user_id'):
		try:
			cur = mysql.connection.cursor()
			print('no error')
			#get properties by using his user_id in the property table
			
			
			cur.execute("SELECT unit_application.*, units.unit_id, units.unit_name, units.features, property.name, property.manager, users.email, users.phone_number, users.first_name, users.last_name FROM unit_application INNER JOIN units ON unit_application.unit_id=units.unit_id INNER JOIN property ON units.property=property.ren_id INNER JOIN users on unit_application.user_id=users.user_id")

			# if result > 0:
			# 	flash("Yeepy some data exists")
			data = cur.fetchall()
				# else:
				# 	flash("Sorry, tenant manager data doesn't exist")

		except Exception as e:
			flash('Kindly add a property first')
			print(e)
			print('error somewhere')
			
		finally:
			cur.close()
			return render_template('unit_applicants.html', data = data)
	return redirect(url_for('Login'))

#view maintenance requests 
@app.route('/viewrequests')
def viewRequests():

	cur = mysql.connection.cursor()
	# cur.execute("SELECT * FROM maintenance SELECT ten_id FROM maintenance m INNER JOIN tenant t ON " )
	data = cur.fetchall()
	cur.close()


	return render_template('request.html', data = data)

#view my tenants 
@app.route ('/occupant')
def Occupant():
	cur = mysql.connection.cursor()
	cur.execute("SELECT * FROM occupant " )
	data = cur.fetchall()
	cur.close()


	return render_template('occupant.html', data = data)

#my vacant units
@app.route ('/vacantunits')
def vacantunits():
	cur = mysql.connection.cursor()
	cur.execute("SELECT * FROM units WHERE is_available = 'Y' AND is_reserved ='N' " )
	data = cur.fetchall()
	cur.close()


	return render_template('vacants.html', data = data)

#my booked units
@app.route ('/bookedunits')
def bookedUnits():
	cur = mysql.connection.cursor()
	cur.execute("SELECT * FROM unit_application " )
	data = cur.fetchall()
	cur.close()


	return render_template('booked.html', data = data)

#send invoice 
@app.route ('/sendinvoice')
def UnitBill():
	# if session.get('RM'):
	form =BillForm(request.form)
	if request.method == 'POST' and form.validate():
		invoice_number = form.invoice_number.data
		invoice = form.invoice.data

		
		try:
			#create cursor
			cur = mysql.connection.cursor()
			

			# Execute query
			cur.execute("INSERT INTO invoice (invoice_number, invoice)VALUES (%s, %s)",
				(invoice_number, invoice))

			print("working")
			#commit to the database
			mysql.connection.commit()
			flash('invoice sent!', 'success')
			#close connection

		except Exception as e:
			flash("Sorry, please fill in all fields", "warning")
			print("error")
			print(e)
		
		finally:
			cur.close()
		
			return redirect(url_for('Dashboard'))
	return render_template('invoice.html', form=form)
 
#view payment history 
@app.route('/paymentlog/<id>')
def paymentLog(id):
	if session.get('user_id'):
		try:
			cur = mysql.connection.cursor()
			print('no error')
			#get user by email 
			result = cur.execute("SELECT * FROM payment_log WHERE tenant = %s", (id))

			if result > 0:
				flash("Yeepy some data exists")
				data = cur.fetchall()
			else:
				flash("No payment history")
		except Exception as e:
			flash('No units to show!')
			print(e)
			print('error somewhere')
			
		finally:
			cur.close()
		return render_template('paymentlog.html', data = data, ren_id = ren_id)
	return redirect(url_for('Dashboard'))

#routes to navigate the tenant dashboard 
#request for maintenance 
@app.route('/maintenance')
def maintenance():
	# if session.get('T')
	form = maintenaceForm(request.form)
	if request.method == 'POST' and form.validate():
		maintenance = form.maintenance.data 
		description = form.description.data
	
		try:
			#create cursor
			cur = mysql.connection.cursor()
			
			# Execute query
			cur.execute("INSERT INTO maintenance_requests (type, description) VALUES (%s, %s)",
				(maintenance, description))

			print("working")
			#commit to the database
			mysql.connection.commit()
			flash('Maintenace request sent!', 'success')
			#close connection

		except Exception as e:
			flash("Sorry, please fill in all fields", "warning")
			print("error")
			print(e)
		
		finally:
			cur.close()
		
		return redirect(url_for('Dashboard'))

	return render_template('maintenance.html', form=form)

#view pending bills 
@app.route('/pendingbills')
def myBill():
	if session.get('id'):
		cur = mysql.connection.cursor()
		cur.execute("SELECT * FROM invoice WHERE tenant = %s", (session['id'], ))
		data = cur.fetchall()
		cur.close()
		r
		try:
			cur = mysql.connection.cursor()
			print('no error')
			#get user by email 
			result = cur.execute("SELECT * FROM invoice WHERE tenant = %s", (session['id'], ))

			if result > 0:
				flash("Yeepy some data exists")
				data = cur.fetchall()
			else:
				flash("Your pending bills haven't been updated")
		except Exception as e:
			flash('No bills to show!')
			print(e)
			print('error somewhere')
			
		finally:
			cur.close()
		return render_template('pendingbill.html', data = data)
	return redirect(url_for('Dashboard'))

#to let 
#(this route can also be reached from the "to let" link on the navbar)
@app.route('/tolet')
def Listed():
	cur = mysql.connection.cursor()
	cur.execute("SELECT * FROM units WHERE is_available = 'Y' AND is_reserved = 'N' " )
	data = cur.fetchall()
	cur.close()
	return render_template('tolet.html', data = data)

#book a vacant unit 
@app.route('/bookunit/<unit_id>', methods=['GET', 'POST'])
def UnitBooking(unit_id):

	if session.get ('user_id'):
		form = bookingForm(request.form)
		if request.method == 'POST' and form.validate():
			# unit_id = form.unit_id.data
			proof_document = form.proof_document.data
			document_number = form.document_number.data

			try:
			#create cursor
				cur = mysql.connection.cursor()
			
			# Execute query
				cur.execute("INSERT INTO unit_application (user_id, unit_id, id_proof_document, id_proof_doc_no) VALUES (%s, %s, %s, %s)",
				(session.get('user_id'), unit_id, proof_document, document_number ))

				print("working")
			#commit to the database
				mysql.connection.commit()
				flash('Booking application sent!', 'success')
				#close connection

			except Exception as e:
				flash("Sorry, please fill in all fields", "warning")
				print("error")
				print(e)
		
			finally:
				cur.close()
			return(redirect(url_for('Dashboard')))
	return render_template('booking.html', form=form, unit_id = unit_id)

#approve a vacant unit application
@app.route('/approve/<int:id>')
def respond(id):

	if session.get ('RM'):
		cur = mysql.connection.cursor()
		try:
		# Execute query
			cur.execute("UPDATE unit_application SET status = 'accepted' WHERE id = %s", (id, ));
			cur.execute("INSERT INTO occupant (user_id, unit_id) VALUES (%s,%s)", (session.get('user_id'), id));
			print("working")
		#commit to the database
			mysql.connection.commit()
			flash('Successfully approved', 'success')
			#close connection

		except Exception as e:
			flash("Sorry, There seemed to be an error", "warning")
			print("error")
			print(e)

		finally:
			cur.close()
	
	return(redirect(url_for('unit_applicants')))


@app.route('/decline/<id>')
def decline(id):

	if session.get ('RM'):
		cur = mysql.connection.cursor()
		try:
		# Execute query
			cur.execute("UPDATE unit_application SET status = 'rejected' WHERE id = %s", (id, ))

			print("working")
		#commit to the database
			mysql.connection.commit()
			flash('Successfully Declined', 'warning')
			#close connection

		except Exception as e:
			flash("Sorry, There seemed to be an error", "warning")
			print("error")
			print(e)

		finally:
			cur.close()
	
	return(redirect(url_for('unit_applicants')))

#routes to admin dashboard	
#view all users 		
@app.route('/users', methods=['GET', 'POST'])
def Users():
	cur = mysql.connection.cursor()
	cur.execute("SELECT * FROM users ORDER BY signup_date DESC" )
	data = cur.fetchall()
	cur.close()
	return render_template('users.html')

#view users who are managers 
@app.route('/managers', methods=['GET', 'POST'])
def Managers():
	cur = mysql.connection.cursor()
	cur.execute("SELECT * FROM users WHERE account= 'RM' ORDER BY signup_date DESC" )
	data = cur.fetchall()
	cur.close()
	return render_template('users.html')

#view users who are tenants 
@app.route('/tenants', methods=['GET', 'POST'])
def Tenants():
	cur = mysql.connection.cursor()
	cur.execute("SELECT occupant.*, units.property, property.ren_id FROM occupant, property INNER JOIN units on units.property=property.ren_id WHERE property.manager = %s ", (session.get('user_id'), ) )
	data = cur.fetchall()
	cur.close()
	return render_template('users.html', data= data)

#delete a user
@app.route('/delete/<string:user_id>', methods = ['GET'])
def delete(user_id):
    flash("Record Has Been Deleted Successfully")
    cur = mysql.connection.cursor()
    cur.execute("DELETE FROM users WHERE id=%s", (user_id,))
    mysql.connection.commit()
    return redirect(url_for('Index'))

if __name__=="__main__":
	app.run(debug=True)