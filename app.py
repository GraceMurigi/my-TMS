from flask import Flask, render_template, request, redirect, url_for, flash, session, logging
from passlib.hash import sha256_crypt
from flask_mysqldb import MySQL
from forms import managerSignupForm, tenantSignupForm, managerLoginForm, tenantloginForm, maintenaceForm
#import flask_excel as excel

#from flask_admin import Admin


app = Flask(__name__)
#Bootstrap(app)

app.secret_key ="Whatdoyouthink"
#configure mysql
app.config['MYSQL_HOST'] = 'localhost'
app.config['MYSQL_USER'] = 'root'
app.config['MYSQL_PASSWORD'] = ''
app.config['MYSQL_DB'] = 'mytms'
app.config['MYSQL_CURSORCLASS'] = 'DictCursor'

#initializing mysql
mysql = MySQL(app)

#home page 
@app.route('/')
def index():
	return render_template ("home.html")

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


		
		#create cursor
		cur = mysql.connection.cursor()

		# Execute query
		cur.execute("INSERT INTO tenant_manager (first_name, last_name, email, phone_number, company, password)VALUES (%s, %s, %s, %s, %s, %s)",(
			first_name, last_name, email, phone_number, company, password))
	

		#commit to the database
		mysql.connection.commit()

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
		first_name = form.first_name.data 
		last_name = form.last_name.data
		email = form.email.data
		phone_number = form.phone_number.data
		password = sha256_crypt.encrypt(str(form.password.data))


		
		#create cursor
		cur = mysql.connection.cursor()

		# Execute query
		cur.execute("INSERT INTO tenant (first_name, last_name, email, phone_number, password)VALUES (%s, %s, %s, %s, %s)",(
			first_name, last_name, email, phone_number, password))
	

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
					return redirect(url_for('RentalManager'))

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
					name = cur.execute("SELECT first_name FROM tenant WHERE email = %s", [email])
					name = cur.fetchall()
					#session['ten_id']= name[0]['ten_id']
					session['name'] = name[0]['first_name']
					flash('You are now logged in', 'success')
					return redirect(url_for('Tenant'))


			else: 
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

# Rental Manager dashboard
@app.route('/rentalmanager')
def RentalManager():
	#if session.get('RM'):
		return render_template('RMdashboard.html')
	#flash("You are not logged in as a RentalManager",'danger')
	#return redirect(url_for('login'))

#Tenant manager dashboard 
@app.route('/tenant')
def Tenant():
	#if session.get('T'):
		return render_template('Tdashboard.html')
	#flash("You should logged in as a Tenant to access this dashboard",'danger')
	#return redirect(url_for('login'))

#Admin dashboard 
@app.route('/admin')
def Admin():
	if session.get('Admin'):
		return render_template('admindashboard.html')
	flash("You are not logged in as a site Administrator", 'danger')
	return redirect(url_for('login'))

#@app.route('/tenant')
#def tenantPage():
	#if session.get('')

@app.route('/tolet')
def Listed():


	return render_template('tolet.html')
@app.route('/tolet')
def Rentals():


	return render_template('rentals.html')

@app.route('/maintenance')
def maintenance():
	form = maintenaceForm(request.form)
	if request.method == 'POST' and form.validate():
		maintenance = form.maintenance.data 
		description = form.description.data

	return render_template('maintenance.html', form=form)

#@app.route('/mybills')
#def myBills():
	
	
if __name__=="__main__":
	app.run(debug=True)