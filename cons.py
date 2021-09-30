
import requests
import json
import MySQLdb

dato=['fried','soup',"salads","pasta","fruits","cereals","meat","desserts"]



miConexion = MySQLdb.connect( host='localhost', user= 'root', passwd='12345678', db='recetas' )
mycursor = miConexion.cursor()

for food in dato:
    r = requests.get('https://api.edamam.com/search?q=$'+food+'&app_id=0f21d949&app_key=8bcdd93683d1186ba0555cb95e64ab26')
    posts = r.json()
    for i in range(0,len(posts['hits'])):
        
        most = posts['hits'][i]['recipe']['label']
        most1 = posts['hits'][i]['recipe']['url']
        most2 = posts['hits'][i]['recipe']['image']
        most3 = posts['hits'][i]['recipe']['source']
        sql = "INSERT INTO platillos (categoria, label, url, image, source) VALUES (%s, %s, %s, %s, %s)"
        val = (food,most, most1,most2,most3)
        mycursor.execute(sql, val)
        miConexion.commit()