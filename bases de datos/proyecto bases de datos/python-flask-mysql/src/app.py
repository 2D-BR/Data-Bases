from flask import Flask, render_template, request, redirect, url_for
from datetime import datetime
import os
import database as db

template_dir = os.path.dirname(os.path.abspath(os.path.dirname(__file__)))
template_dir = os.path.join(template_dir, 'src', 'templates')

fecha_actual = datetime.now().date()

usuario_en_inicio = True  # Inicialmente el usuario está en la página de inicio
usuario_en_inicioAdmin = False  # El usuario no está en inicioAdmin
usuario_en_inicioVen = False  # El usuario no está en inicioVen


app = Flask(__name__, template_folder = template_dir)

#Rutas de la aplicacion




@app.route('/', methods=['GET', 'POST'])
def login():
    global usuario_en_inicio, usuario_en_inicioAdmin, usuario_en_inicioVen  # Asegúrate de usar las variables globales
    
    if request.method == 'POST':
        email = request.form["nombre_usuario"]
        password = request.form["contrasena"]
        cur = db.database.cursor()
        script = "Select * from usuario where Nombre_usuario = %s and Contraseña = %s;"
        values = (email, password)

        cur.execute(script, values)
        data = cur.fetchall()
        cur.close()
        
        if data:
            if data[0][1] == 'usuarioAdmin' and data[0][2] == 'contraseña1':
                usuario_en_inicio = False
                usuario_en_inicioAdmin = True
                usuario_en_inicioVen = False
                return redirect(url_for('inicioAdmin'))
            if data[0][1] == 'usuarioVendedor' and data[0][2] == 'contraseña2':
                usuario_en_inicio = False
                usuario_en_inicioAdmin = False
                usuario_en_inicioVen = True
                return redirect(url_for('inicioVen'))
        else:
            return redirect(url_for('inicio'))

    usuario_en_inicio = True
    usuario_en_inicioAdmin = False
    usuario_en_inicioVen = False
    return render_template("login.html")

# <--------------------------------------INICIO------------------------------------------>
# Página inicio admin
@app.route('/inicioAdmin')
def inicioAdmin():
    if usuario_en_inicioAdmin:
        return render_template('inicio_Admin.html')
    else:
        return redirect(url_for('inicio'))

# Página inicio vendedor
@app.route('/inicioVen')
def inicioVen():
    if usuario_en_inicioVen:
        return render_template('inicio_vendedor.html')
    else:
        return redirect(url_for('inicio'))

# Página inicio
@app.route('/inicio')
def inicio():
    global usuario_en_inicio, usuario_en_inicioAdmin, usuario_en_inicioVen
    usuario_en_inicio = True
    usuario_en_inicioAdmin = False
    usuario_en_inicioVen = False
    return render_template('inicio.html')

#<--------------------------------------CLIENTES------------------------------------------>

#Ruta para mostrar lista  clientes en bd
@app.route('/clientes')
def clientes():
    cursor = db.database.cursor()
    cursor.execute("SELECT * FROM cliente")
    myresult = cursor.fetchall()
    #Convertir los datos a diccionario
    insertObject = []
    columnNames = [column[0] for column in cursor.description]
    for record in myresult:
        insertObject.append(dict(zip(columnNames, record)))
    cursor.close()

    return render_template('index.html', data=insertObject)

#Ruta para agregar un cliente en la bd
@app.route('/cliente', methods=['POST'])
def addUser():
    COD_CLIENTE = request.form['Codigo cliente']
    NOMBRE_CLI = request.form['Nombre del cliente']
    SEGUNDO_NOM_CLI = request.form['Segundo nombre del cliente']
    APELLIDO_CLI = request.form['apellido del cliente']
    DEPARTAMENTO = request.form['Departamento']
    CIUDAD = request.form['Ciudad']
    DIRRECCION = request.form['Direccion']
    TELEFONO = request.form['Telefono']

    if COD_CLIENTE and NOMBRE_CLI and APELLIDO_CLI and DEPARTAMENTO and CIUDAD and DIRRECCION and TELEFONO:
        cursor = db.database.cursor()
        sql = "INSERT INTO CLIENTE (COD_CLIENTE, NOMBRE_CLI, SEGUNDO_NOM_CLI, APELLIDO_CLI, DEPARTAMENTO, CIUDAD, DIRRECCION, TELEFONO) VALUES (%s, %s, %s, %s, %s, %s, %s, %s)"
        data = (COD_CLIENTE, NOMBRE_CLI, SEGUNDO_NOM_CLI, APELLIDO_CLI, DEPARTAMENTO, CIUDAD, DIRRECCION, TELEFONO)
        cursor.execute(sql, data)
        db.database.commit()
    return redirect(url_for('clientes'))

#Ruta para eliminar un cliente
@app.route('/delete/<int:id>')
def delete(id):
    cursor = db.database.cursor()
    sql = "DELETE FROM CLIENTE WHERE COD_CLIENTE = %s"
    data = (id,)
    cursor.execute(sql, data)
    db.database.commit()
    return redirect(url_for('clientes'))

#Ruta para editar un cliente
@app.route('/edit/<int:id>', methods=['POST'])
def edit(id):
    COD_CLIENTE = id
    NOMBRE_CLI = request.form['Nombre del cliente']
    SEGUNDO_NOM_CLI = request.form['Segundo nombre del cliente']
    APELLIDO_CLI = request.form['apellido del cliente']
    DEPARTAMENTO = request.form['Departamento']
    CIUDAD = request.form['Ciudad']
    DIRRECCION = request.form['Direccion']
    TELEFONO = request.form['Telefono']

    if NOMBRE_CLI and APELLIDO_CLI and DEPARTAMENTO and CIUDAD and DIRRECCION and TELEFONO:
        cursor = db.database.cursor()
        sql = "UPDATE CLIENTE SET NOMBRE_CLI = %s, SEGUNDO_NOM_CLI = %s, APELLIDO_CLI = %s, DEPARTAMENTO = %s, CIUDAD = %s, DIRRECCION = %s, TELEFONO = %s WHERE COD_CLIENTE = %s"
        data = (NOMBRE_CLI, SEGUNDO_NOM_CLI, APELLIDO_CLI, DEPARTAMENTO, CIUDAD, DIRRECCION, TELEFONO, COD_CLIENTE)
        cursor.execute(sql, data)
        db.database.commit()
    return redirect(url_for('clientes'))

#<------------------------------------PRODUCTOS--------------------------------------------->

#Ruta para mostrar lista de productos
@app.route('/productos')
def productos():
    cursor = db.database.cursor()
    cursor.execute("SELECT * FROM PRODUCTO")
    myresult = cursor.fetchall()
    #Convertir los datos a diccionario
    insertObject = []
    columnNames = [column[0] for column in cursor.description]
    for record in myresult:
        insertObject.append(dict(zip(columnNames, record)))
    cursor.close()

    return render_template('product.html', data=insertObject)


#Ruta para registrar producto
@app.route('/registrar_producto', methods=['POST'])
def registrar_producto():
    nombre_producto = request.form['nombre_producto']
    marca = request.form['marca']
    precio = request.form['precio']
    genero = request.form['genero']
    color = request.form['color']
    material = request.form['material']

    try:
        precio = float(request.form['precio'])
    except ValueError:
        return "El precio debe ser un número decimal válido."

    if nombre_producto and marca and  genero and color and material and precio>0:
        cursor = db.database.cursor()
        sql = "INSERT INTO PRODUCTO (NOMBRE_PROD, MARCA, PRECIO, GENERO, Color, Material) VALUES (%s, %s, %s, %s, %s, %s)"
        data = (nombre_producto, marca, precio, genero, color, material)
        cursor.execute(sql, data)
        db.database.commit()
    return redirect(url_for('productos'))


# Ruta para eliminar un producto
@app.route('/eliminar_producto/<int:id>')
def eliminar_producto(id):
    cursor = db.database.cursor()
    sql = "DELETE FROM PRODUCTO WHERE COD_PRODUCTO = %s"
    data = (id,)
    cursor.execute(sql, data)
    db.database.commit()
    return redirect(url_for('productos'))

# Ruta para editar un producto
@app.route('/editar_producto/<int:id>', methods=['POST'])
def editar_producto(id):
    COD_PRODUCTO = id
    NOMBRE_PROD = request.form['nombre_producto']
    MARCA = request.form['marca']
    PRECIO = request.form['precio']
    GENERO = request.form['genero']
    Color = request.form['color']
    Material = request.form['material']

    try:
        PRECIO = float(request.form['precio'])
    except ValueError:
        return "El precio debe ser un número decimal válido."

    if NOMBRE_PROD and MARCA  and GENERO and Color and Material and PRECIO>0:
        cursor = db.database.cursor()
        sql = "UPDATE PRODUCTO SET NOMBRE_PROD = %s, MARCA = %s, PRECIO = %s, GENERO = %s, Color = %s, Material = %s WHERE COD_PRODUCTO = %s"
        data = (NOMBRE_PROD, MARCA, PRECIO, GENERO, Color, Material, COD_PRODUCTO)
        cursor.execute(sql, data)
        db.database.commit()
    return redirect(url_for('productos'))


#<------------------------------------COMPRAS--------------------------------------------->



#Ruta para ver productos disponibles
@app.route('/compras')
def comprar():
    cursor = db.database.cursor()
    cursor.execute("SELECT * FROM PRODUCTO")
    myresult = cursor.fetchall()
    #Convertir los datos a diccionario
    insertObject = []
    columnNames = [column[0] for column in cursor.description]
    for record in myresult:
        insertObject.append(dict(zip(columnNames, record)))
    cursor.close()



    return render_template('shopping.html', data=insertObject)

#Ruta para registrar una compra
@app.route('/registrar_compra/<int:id>')
def registrar_compra_producto(id):
    cursor = db.database.cursor()
    # Obtener los datos del producto para mostrar el nombre
    sql = "SELECT NOMBRE_PROD FROM PRODUCTO WHERE COD_PRODUCTO = %s"
    data = (id,)
    cursor.execute(sql, data)
    nombre_producto = cursor.fetchone()[0]
    cursor.close()

    return render_template('shopping.html', id=id, nombre_producto=nombre_producto)

#Ruta para registrar nuevo cliente
@app.route('/registrar_nuevo_cliente', methods=['POST'])
def registrar_nuevo_cliente():
    COD_CLIENTE = request.form['Codigo cliente']
    NOMBRE_CLI = request.form['Nombre del cliente']
    SEGUNDO_NOM_CLI = request.form['Segundo nombre del cliente']
    APELLIDO_CLI = request.form['apellido del cliente']
    DEPARTAMENTO = request.form['Departamento']
    CIUDAD = request.form['Ciudad']
    DIRRECCION = request.form['Direccion']
    TELEFONO = request.form['Telefono']

    if COD_CLIENTE and NOMBRE_CLI and APELLIDO_CLI and DEPARTAMENTO and CIUDAD and DIRRECCION and TELEFONO:
        cursor = db.database.cursor()
        sql = "INSERT INTO CLIENTE (COD_CLIENTE, NOMBRE_CLI, SEGUNDO_NOM_CLI, APELLIDO_CLI, DEPARTAMENTO, CIUDAD, DIRRECCION, TELEFONO) VALUES (%s, %s, %s, %s, %s, %s, %s, %s)"
        data = (COD_CLIENTE, NOMBRE_CLI, SEGUNDO_NOM_CLI, APELLIDO_CLI, DEPARTAMENTO, CIUDAD, DIRRECCION, TELEFONO)
        cursor.execute(sql, data)
        db.database.commit()
    return redirect('/compras')

#Ruta para ver clientes actuales
@app.route('/ver_clientes_actuales')
def clientes_actuales():
    cursor = db.database.cursor()
    cursor.execute("SELECT * FROM cliente")
    myresult = cursor.fetchall()
    #Convertir los datos a diccionario
    insertObject = []
    columnNames = [column[0] for column in cursor.description]
    for record in myresult:
        insertObject.append(dict(zip(columnNames, record)))
    cursor.close()

    return render_template('clientes_actuales.html', data=insertObject)


#<------------------------------------Facturas--------------------------------------------->


@app.route('/registrar_factura', methods=['POST'])
def registrar_factura():
    COD_CLIENTE = request.form['Codigo cliente']
    COD_PRODUCTO = request.form['Codigo producto']
    Cantidad = request.form['Cantidad']
    
    if COD_CLIENTE and COD_PRODUCTO and Cantidad:
        cursor = db.database.cursor()

        # Insertar factura
        sql = "INSERT INTO FACTURA (COD_CLIENTE, Fecha_de_Venta) VALUES (%s, NOW())"
        data = (COD_CLIENTE,)
        cursor.execute(sql, data)
        db.database.commit()

        # Obtener el ID de la factura recién insertada
        cursor.execute("SELECT * FROM FACTURA ORDER BY ID_FACTURA DESC LIMIT 1")
        data_factura = cursor.fetchall()
        id_factura = data_factura[0][0]

        # Obtener el precio del producto
        sql = "SELECT * FROM PRODUCTO WHERE COD_PRODUCTO = %s;"
        data = (COD_PRODUCTO,)
        cursor.execute(sql, data)
        data_producto = cursor.fetchall()
        precio_producto = data_producto[0][3]

        precio_producto = int(precio_producto)
        subtotal = precio_producto * int(Cantidad)

        # Insertar elemento de factura
        sql = "INSERT INTO items_factura (ID_FACTURA, COD_PRODUCTO, Cantidad, Subtotal) VALUES (%s, %s, %s, %s)"
        data = (id_factura, COD_PRODUCTO, Cantidad, subtotal)
        cursor.execute(sql, data)
        db.database.commit()

        cursor.close()
        return redirect('/facturas')
    return redirect('/compras')



@app.route('/facturas')
def facturas():
    cursor = db.database.cursor()
    # Consulta para obtener datos de factura
    cursor.execute("""
        SELECT factura.*, IFNULL(SUM(items_factura.Subtotal), 0) AS Total_ventas
        FROM factura
        LEFT JOIN items_factura ON factura.ID_FACTURA = items_factura.ID_FACTURA
        GROUP BY factura.ID_FACTURA ORDER BY factura.ID_FACTURA DESC LIMIT 1;
    """)
    factura_result = cursor.fetchall()

    # Convertir los datos de factura a diccionario
    factura_data = []
    factura_column_names = [column[0] for column in cursor.description]
    for record in factura_result:
        factura_data.append(dict(zip(factura_column_names, record)))

    # Consulta para obtener datos de items_factura
    cursor.execute("SELECT *FROM items_factura WHERE ID_FACTURA = (SELECT MAX(ID_FACTURA) FROM items_factura);")
    items_factura_result = cursor.fetchall()

    # Convertir los datos de items_factura a diccionario
    items_factura_data = []
    items_factura_column_names = [column[0] for column in cursor.description]
    for record in items_factura_result:
        items_factura_data.append(dict(zip(items_factura_column_names, record)))

    cursor.close()

    return render_template('facturas.html', factura_data=factura_data, items_factura_data=items_factura_data)

#Ruta para ver productos disponibles
@app.route('/ver_productos_disponibles')
def prodcutos_disponibles():
    cursor = db.database.cursor()
    cursor.execute("SELECT * FROM PRODUCTO")
    myresult = cursor.fetchall()
    #Convertir los datos a diccionario
    insertObject = []
    columnNames = [column[0] for column in cursor.description]
    for record in myresult:
        insertObject.append(dict(zip(columnNames, record)))
    cursor.close()

    return render_template('productos_disponibles.html', data=insertObject)


@app.route('/agregar_nuevo_producto', methods=['POST'])
def agregar_nuevo_():
    COD_PRODUCTO = request.form['Codigo producto']
    Cantidad = request.form['Cantidad']
    
    if COD_PRODUCTO and Cantidad:
        cursor = db.database.cursor()


        # Obtener el ID de la factura recién insertada
        cursor.execute("SELECT * FROM FACTURA ORDER BY ID_FACTURA DESC LIMIT 1")
        data_factura = cursor.fetchall()
        id_factura = data_factura[0][0]

        # Obtener el precio del producto
        sql = "SELECT * FROM PRODUCTO WHERE COD_PRODUCTO = %s;"
        data = (COD_PRODUCTO,)
        cursor.execute(sql, data)
        data_producto = cursor.fetchall()
        precio_producto = data_producto[0][3]

        precio_producto = int(precio_producto)
        subtotal = precio_producto * int(Cantidad)

        # Insertar elemento de factura
        sql = "INSERT INTO items_factura (ID_FACTURA, COD_PRODUCTO, Cantidad, Subtotal) VALUES (%s, %s, %s, %s)"
        data = (id_factura, COD_PRODUCTO, Cantidad, subtotal)
        cursor.execute(sql, data)
        db.database.commit()

        cursor.close()
    return redirect('/facturas')


@app.route('/registrar_venta', methods=['POST'])
def registrar_venta():
    COD_FACTURA = request.form['id_factura']  # Supongo que este campo es el ID de factura asociado a la venta
    Fecha_de_Venta = request.form['fecha_venta']

    if COD_FACTURA and Fecha_de_Venta:
        cursor = db.database.cursor()

        # Insertar venta
        sql = "INSERT INTO venta (ID_FACTURA, Fecha_de_Venta) VALUES (%s, %s)"
        data = (COD_FACTURA, Fecha_de_Venta)
        cursor.execute(sql, data)
        db.database.commit()

        cursor.close()
        return redirect('/inicioVen')  # Redirige a donde corresponda después de registrar la venta
    return redirect('/facturas') 

@app.route('/ver_ventas')
def ver_ventas():
    cursor = db.database.cursor()
    cursor.execute("""
    SELECT v.*, IFNULL(SUM(IFNULL(ifa.Subtotal, 0)), 0) AS TotalVentas
    FROM venta AS v
    LEFT JOIN factura AS f ON v.ID_FACTURA = f.ID_FACTURA
    LEFT JOIN items_factura AS ifa ON f.ID_FACTURA = ifa.ID_FACTURA
    GROUP BY v.ID_VENTA;
    """)
    myresult = cursor.fetchall()

    # Convertir los datos a un diccionario
    ventas_data = []
    columnNames = [column[0] for column in cursor.description]
    for record in myresult:
        ventas_data.append(dict(zip(columnNames, record)))
    
    cursor.close()
    
    return render_template('ventas.html', ventas_data=ventas_data)

if __name__ == '__main__':
    app.run(debug=True,port=4000)