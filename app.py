from flask import Flask, render_template, request, redirect, url_for, flash, session, logging
from passlib.hash import sha256_crypt
from flask_mysqldb import MySQL
from forms import SignupForm, LoginForm, maintenaceForm, propertyForm, unitsForm, ManagerForm, TenantForm
#import flask_excel as excel



app = Flask(__name__)
#Bootstrap(app)

app.secret_key ="Whatdoyouthink123"
#configure mysql
app.config['MYSQL_HOST'] = 'localhost'
app.config['MYSQL_USER'] = 'root'
app.config['MYSQL_PASSWORD'] = ''
app.config['MYSQL_DB'] = 'tenant_management'
app.config['MYSQL_CURSORCLASS'] = 'DictCursor'

#initializing mysql
mysql = MySQL(app)

#home page 


@app.route('/')
def index():
	return render_template ("index.html")

@app.route ('/about')
def about():
	return render_template('about.html')

@app.route ('/contactus')
def contact():
	return render_template ('contact.html')

	

#manager signup page 
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


@app.route('/logout')
def logout ():
	session.clear()
	flash('You are now logged out','danger')
	return redirect(url_for('index'))

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
		return redirect(url_for('home'))
	flash("You are not logged in, Kindly log in first", 'danger')
	return redirect(url_for('home'))

#manager profile 
@app.route('/managerprofile', methods=['GET', 'POST'])
def managerProfile():
	#how do we add session user?
	form = ManagerForm(request.form)
	if request.method == 'POST' and form.validate():
		email = form.email.data
		phone = form.phone.data


		try:
			#create cursor
			cur = mysql.connection.cursor()

			# Execute query
			cur.execute("INSERT INTO tenant_manager (work_email, work_phone, user_id)VALUES (%s, %s, %s)",(
				email, phone, session['user_id']))
		

			#commit to the database
			mysql.connection.commit()
			
		except Exception as e:
			flash( 'update error!: {}', format(e))
			return render_template('managerprofile.html', form = form)
			
		finally:
			#close connection
			cur.close()


		flash("profile update successful!", "success")
		return redirect(url_for('Dashboard'))
	return render_template('managerprofile.html', form=form)


# Manager to add new property 
@app.route('/propertyform', methods=['GET', 'POST'])
def addProperty():
	if session.get('user_id'):
		
		form =propertyForm(request.form)
		if request.method == 'POST' and form.validate():
			name = form.name.data
			address = form.address.data
			units = form.units.data
			print("hi")
			#manager = form.manager.data
			try:
				#create cursor
				cur = mysql.connection.cursor()
				

				# Execute query
				cur.execute("INSERT INTO property (name, address, units_managed, manager)VALUES (%s, %s, %s, %s)",(
					name, address, units, session['user_id']))
	

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
	return redirect(url_for('managerLogin'))


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
	cur.execute("SELECT * FROM units WHERE is_available = 'N' " )
	data = cur.fetchall()
	cur.close()


	return render_template('vacants.html', data = data)

@app.route('/tolet')
def Listed():


	return render_template('tolet.html')

#tenant profile 
@app.route('/renterprofile', methods=['GET', 'POST'])
def renterProfile():
	#how do we add session user?
	form = TenantForm(request.form)
	if request.method == 'POST' and form.validate():
		proof_document = form.proof_document.data
		document_number = form.document_number.data


		try:
			#create cursor
			cur = mysql.connection.cursor()

			# Execute query
			cur.execute("INSERT INTO renters (user_id, id_proof_document, id_proof_doc_no)VALUES (%s, %s, %s)",(
				session['user_id'], proof_document, document_number))
		

			#commit to the database
			mysql.connection.commit()
			
		except Exception as e:
			flash( 'update error!: {}', format(e))
			return render_template('managerprofile.html', form = form)
			
		finally:
			#close connection
			cur.close()


		flash("profile update successful!", "success")
		return redirect(url_for('Dashboard'))
	return render_template('managerprofile.html', form=form)


if __name__=="__main__":
	app.run(debug=True)