from flask import Flask, render_template
from flask import request
from flask import jsonify
from flask_sqlalchemy import SQLAlchemy
from flask_marshmallow import Marshmallow
app = Flask(__name__)


app.config['SQLALCHEMY_DATABASE_URI'] = 'mysql+pymysql://root:12345678@127.0.0.1/recetas'
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False

db = SQLAlchemy(app)
ma = Marshmallow(app)

class Platillos(db.Model):
    idplatillos = db.Column(db.Integer, primary_key=True)
    categoria = db.Column(db.String(45))
    label = db.Column(db.String(100))
    url = db.Column(db.String(1000))
    image = db.Column(db.String(100))
    source = db.Column(db.String(100))
    def __init__(self, categoria,label,url,image,source):
        self.categoria = categoria
        self.label = label
        self.url = url
        self.image = image
        self.source = source

class Favoritos(db.Model):
    idfavoritos = db.Column(db.Integer, primary_key=True)
    categoria = db.Column(db.String(45))
    label = db.Column(db.String(100))
    url = db.Column(db.String(1000))
    image = db.Column(db.String(100))
    source = db.Column(db.String(100))
    def __init__(self, categoria,label,url,image,source):
        self.categoria = categoria
        self.label = label
        self.url = url
        self.image = image
        self.source = source        

class Usuario(db.Model):
    idusuario = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String(100))
    peso = db.Column(db.String(5))

    def __init__(self, name,peso):
        self.name = name
        self.peso = peso

db.create_all()

class PlatillosSchema(ma.Schema):
    class Meta:
        fields = ("idplatillos","categoria", "label","url","image","source")

platillos_schema = PlatillosSchema()
platillos_schemas = PlatillosSchema(many=True)

class FavoritosSchema(ma.Schema):
    class Meta:
        fields = ("idfavoritos","categoria", "label","url","image","source")

favoritos_schema = FavoritosSchema()
favoritos_schemas = FavoritosSchema(many=True)

class UsuarioSchema(ma.Schema):
    class Meta:
        fields = ("idusuario","name","peso")

usuario_schema = UsuarioSchema()
usuario_schemas = UsuarioSchema(many=True)

@app.route("/")
def index():
    return "hello"

@app.route('/create_favorito', methods=['POST'])
def create_favorito():
    print(request.json)
    categoria=request.json["categoria"]
    label=request.json["label"]
    url=request.json["url"]
    image=request.json["image"]
    source=request.json["source"]


    new_favorito = Favoritos(categoria,label,url,image,source)
    db.session.add(new_favorito)
    db.session.commit()

    return platillos_schema.jsonify(new_favorito)

@app.route('/most_favoritos', methods=['GET'])
def most_favoritos():
    all_favoritos = Favoritos.query.all()
    result = favoritos_schemas.dump(all_favoritos)
    return jsonify(result)

@app.route('/delete_favoritos/<ide>', methods=['DELETE'])
def eliminar_elector(ide):
    deletefavorito=Favoritos.query.filter_by(idfavoritos=ide).one()
    db.session.delete(deletefavorito)
    db.session.commit()
    return "eliminado correctamente"

@app.route('/creat_usuario', methods=['POST'])
def create_usuario():
    print(request.json)
    name=request.json["name"]
    peso=request.json["peso"]
    new_usuario = Usuario(name,peso)
    db.session.add(new_usuario)
    db.session.commit()
    return usuario_schema.jsonify(new_usuario)

@app.route('/most_usuario', methods=['GET'])
def most_usuario():
    all_usario = Usuario.query.all()
    result = usuario_schemas.dump(all_usario)
    return jsonify(result)
    
#app.py
if __name__ == '__main__':
    app.run( host='192.168.0.8')
    #app.run( host='192.168.0.114')
    