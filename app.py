from flask import Flask, render_template, request, redirect, url_for, flash, session, logging
from passlib.hash import sha256_crypt
from flask_mysqldb import MySQL
from forms import managerSignupForm, tenantSignupForm, managerLoginForm, tenantloginForm, maintenaceForm, propertyForm, unitsForm
#import flask_excel as excel

#from flask_admin import Admin


app = Flask(__name__)
#Bootstrap(app)

app.secret_key ="Whatdoyouthink"
#configure mysql
app.config['MYSQL_HOST'] = 'localhost'
app.config['MYSQL_USER'] = 'root'
app.config['MYSQL_PASSWORD'] = ''
app.config['MYSQL_DB'] = 'finalproject'
app.config['MYSQL_CURSORCLASS'] = 'DictCursor'

#initializing mysql
mysql = MySQL(app)

#home page 

@app.route('/')
def home():
	return render_template ("index.html")

@app.route('/home')
def index():
	return render_template ("index.html")

@app.route ('/about')
def about():
	return render_template('about.html')

@app.route ('/contactus')
def contact():
	return render_template ('contact.html')

	

#manager signup page 
@app.route('/managersignup', methods=['GET','POST'])
def managerSignup():
	form = managerSignupForm(request.form)
	if request.method == 'POST' and form.validate():
		first_name = form.first_name.data 
		last_name = form.last_name.data
		email = form.email.data
		phone_number = form.phone_number.data
		company = form.company.data
		password = sha256_crypt.encrypt(str(form.password.data))


		try:
			#create cursor
			cur = mysql.connection.cursor()

			# Execute query
			cur.execute("INSERT INTO tenant_manager (first_name, last_name, email, phone_number, company, password)VALUES (%s, %s, %s, %s, %s, %s)",(
				first_name, last_name, email, phone_number, company, password))
		

			#commit to the database
			mysql.connection.commit()
			
		except Exception as e:
			flash( 'Seems there was an error: {}', format(e))
			return render_template('managerSignup.html', form = form)
			
		finally:
			#close connection
			cur.close()


		flash("Signup successful!", "success")
		return redirect(url_for('managerLogin'))
	return render_template('managersignup.html', form=form)

#tenant signup
@app.route('/tenantsignup', methods=['GET','POST'])
def tenantSignup():
	form = tenantSignupForm(request.form)
	if request.method == 'POST' and form.validate():
		unit = form.unit.data
		first_name = form.first_name.data 
		last_name = form.last_name.data
		email = form.email.data
		phone_number = form.phone_number.data
		password = sha256_crypt.encrypt(str(form.password.data))


		
		#create cursor
		cur = mysql.connection.cursor()

		# Execute query
		cur.execute("INSERT INTO tenant (unit_id, first_name, last_name, email, phone_number, password)VALUES (%s, %s, %s, %s, %s, %s)",(
			unit, first_name, last_name, email, phone_number, password))
	

		#commit to the database
		mysql.connection.commit()

		#close connection
		cur.close()


		flash("Sign successful!", "success")
		return redirect(url_for('tenantLogin'))
	return render_template('tenantsignup.html', form=form)




#manager login 
@app.route('/managerlogin', methods=['GET','POST'])
def managerLogin():
	if session.get('logged_in'):
		flash("You are already logged in",'warning')
		return redirect(url_for('index'))
	form = managerLoginForm(request.form)
	if session.get('logged_in'):
		redirect(url_for('index'))
	if request.method == 'POST' and form.validate():
		email = form.email.data 
		password_candidate = form.password.data

		#create cursor 
		cur = mysql.connection.cursor()

		#get user by email 
		result = cur.execute("SELECT * FROM tenant_manager WHERE email = %s", [email])

		if result > 0:

			#get first one with required credentials 
			data = cur.fetchone()
			password = data ['password']

			#compare passwords 
			if sha256_crypt.verify(password_candidate,password):
				#passed
					session['logged_in']= True
					#name = cur.execute("SELECT first_name FROM tenant_manager WHERE email = %s", [email])
					name = cur.execute("SELECT * FROM tenant_manager WHERE email = %s", [email])


					name = cur.fetchall()
					session['mgr_id']= name[0]['mgr_id']
					session['name'] = name[0]['first_name']

					flash('You are now logged in', 'success')
					return redirect(url_for('Dashboard'))

			else:

				error= 'Invalid Login credentials'
				return render_template('managerlogin.html', error=error, form=form)

			#close connection 
			cur.close()   

		else: 
			error = 'Email not found'
			return render_template('managerlogin.html', error=error, form=form)

			
	return render_template ('managerlogin.html', form=form)

#tenant login 
@app.route('/tenantlogin', methods=['GET','POST'])
def tenantLogin():
	if session.get('logged_in'):
		flash("You are already logged in",'warning')
		return redirect(url_for('index'))
	form = managerLoginForm(request.form)
	if session.get('logged_in'):
		redirect(url_for('index'))
	if request.method == 'POST' and form.validate():
		email = form.email.data 
		password_candidate = form.password.data

		#create cursor 
		cur = mysql.connection.cursor()

		#get user by email 
		result = cur.execute("SELECT * FROM tenant WHERE email = %s", [email])

		if result > 0:
			#get first one with required credentials 
			data = cur.fetchone()
			password = data ['password']

		#compare passwords 
			if sha256_crypt.verify(password_candidate, password):
				#passed
					session['logged_in']= True
					name = cur.execute("SELECT * FROM tenant WHERE email = %s", [email])
					name = cur.fetchall()
					session['ten_id']= name[0]['ten_id']
					session['name'] = name[0]['first_name']
					flash('You are now logged in', 'success')
					return redirect(url_for('Dashboard'))


			else: 
				flash("wrong credentials")
				error = 'INVALID LOGIN CREDENTIALS'
				return render_template('tenantlogin.html', error=error, form=form)
 				 
			cur.close()  

		else:
			error = 'Email not found'
			return render_template('tenantlogin.html', error=error, form=form)

	return render_template ('tenantlogin.html', form=form)


#logout  
@app.route('/logout')
def logout ():
	session.clear()
	flash('You are now logged out','danger')
	return redirect(url_for('index'))

# Dashboard route
@app.route('/Dashboard')
def Dashboard():
	if session.get('mgr_id'):
		return render_template('RMdashboard.html')
	elif session.get('ten_id'):
		return render_template('Tdashboard.html')
	elif session.get('Admin'):
		return render_template('admindashboard.html')
	else:
		flash('Sorry, you need to log in first', 'warning')
		return redirect(url_for('home'))
	flash("You are not logged in, Kindly log in first", 'danger')
	return redirect(url_for('home'))

# Manager to add new property 
@app.route('/propertyform', methods=['GET', 'POST'])
def addProperty():
	if session.get('mgr_id'):
		
		form =propertyForm(request.form)
		if request.method == 'POST' and form.validate():
			name = form.name.data
			address = form.address.data
			units = form.units.data
			description = form.description.data
			#manager = form.manager.data
			try:
				#create cursor
				cur = mysql.connection.cursor()
				

				# Execute query
				cur.execute("INSERT INTO rental_properties (name, address, units, description, mgr_id)VALUES (%s, %s, %s, %s, %s)",(
					name, address, units, description, session['mgr_id']))
	

				#commit to the database
				mysql.connection.commit()
				flash('You have successfully created your rental property', 'success')
				#close connection

			except Exception as e:
				flash("Sorry, property name already exists", "warning")

			
			finally:
				cur.close()
			
			return redirect(url_for('myProperty'))
	return render_template('addproperty.html', form=form)

@app.route('/viewproperty', methods=['GET', 'POST'])
def myProperty():
	if session.get('mgr_id'):
		try:
			cur = mysql.connection.cursor()
			print('no error')
			#get user by email 
			# result = cur.execute("SELECT * FROM rental_properties WHERE manager_id = %s", (session['mgr_id'], ))
			cur.execute("SELECT * FROM rental_properties WHERE mgr_id = %s", (session['mgr_id'], ))

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
	return redirect(url_for('managerLogin'))


@app.route('/unitsform/<ren_id>', methods=['GET', 'POST'])
def addUnits(ren_id):
	
		
	form =unitsForm(request.form)
	if request.method == 'POST' and form.validate():
		unit_id = form.unit_id.data
		features = form.features.data
		vacancy = form.vacancy.data
		try:
			#create cursor
			cur = mysql.connection.cursor()
			

			# Execute query
			cur.execute("INSERT INTO unit (unit_id, ren_id, features, status)VALUES (%s, %s, %s, %s)",(unit_id,ren_id, 
				features, vacancy))

			print("working")
			#commit to the database
			mysql.connection.commit()
			flash('Unit added successfully!', 'success')
			#close connection

		except Exception as e:
			flash("Sorry, please fill in all fields", "warning")
			print("error")
			print(e)
		
		finally:
			cur.close()
		
		return redirect(url_for('addUnits', ren_id = ren_id))
	return render_template('addunit.html', form=form, ren_id = ren_id)

@app.route('/viewunits/<ren_id>')
def viewUnits(ren_id):
	if session.get('mgr_id'):
		try:
			cur = mysql.connection.cursor()
			print('no error')
			#get user by email 
			result = cur.execute("SELECT * FROM unit WHERE ren_id = %s", (ren_id, ))

			if result > 0:
				flash("Yeepy some data exists")
				data = cur.fetchall()
			else:
				flash("Sorry no data for the manager")
		except Exception as e:
			flash('No units to show!')
			print(e)
			print('error aomewhee')
			
		finally:
			cur.close()
		return render_template('unitlist.html', data = data, ren_id = ren_id)
	return redirect(url_for('managerLogin'))



@app.route('/maintenance')
def maintenance():
	form = maintenaceForm(request.form)
	if request.method == 'POST' and form.validate():
		maintenance = form.maintenance.data 
		description = form.description.data

	return render_template('maintenance.html', form=form)


@app.route('/viewrequests')
def viewRequests():

	cur = mysql.connection.cursor()
	cur.execute("SELECT * FROM maintenance SELECT ten_id FROM maintenance m INNER JOIN tenant t ON " )
	data = cur.fetchall()
	cur.close()


	return render_template('request.html', data = data)

@app.route ('/mytenants')
def myTenants():
	cur = mysql.connection.cursor()
	cur.execute("" )
	data = cur.fetchall()
	cur.close()


	return render_template('request.html', data = data)


@app.route ('/vacantunits')
def vacantunits():
	cur = mysql.connection.cursor()
	cur.execute("SELECT * FROM unit WHERE status = 'vacant' " )
	data = cur.fetchall()
	cur.close()


	return render_template('vacants.html', data = data)

@app.route('/tolet')
def Listed():


	return render_template('tolet.html')

if __name__=="__main__":
	app.run(debug=True)