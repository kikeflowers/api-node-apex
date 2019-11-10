const express = require('express')
const app = express()
const http = require('http')
const cors = require('cors')
const port = 3002
const bodyParser = require('body-parser')

let server = http.createServer(app)
var io = require('socket.io')(server)
const Pool = require('pg').Pool
const pool = new Pool({
  user: 'postgres',
  host: 'localhost',
  database: 'apexapi',
  password: 'K!ke1.500$',
  port: 5432,
})

var allowedOrigins = ['http://localhost:8080'];

app.use(cors({
    origin: function(origin, callback){
    if(!origin) return callback(null, true);
    if(allowedOrigins.indexOf(origin) === -1){
      var msg = 'The CORS policy for this site does not ' +
                'allow access from the specified Origin.';
      return callback(new Error(msg), false);
    }
    return callback(null, true);
  }
}))

app.use(bodyParser.json())

app.use(
    bodyParser.urlencoded({
        extended:true
    })
)


io.on('connection', (client) =>{
    client.emit('enviarMensaje', 'Usuario conectado');
})

app.get('/', function(request, response){
    response.send('Bienvenido');
})

app.get('/user', function(request, response){
    pool.query('select * from usuarios2 order by id desc limit 1', (error, results) => {
        if(error) {
            throw error;
        }

        response.status(200).json(results.rows)
    })
})

app.post('/user', function(request, response){
    const { usuario, nombre, email, direccion } = request.body;

    pool.query('insert into usuarios2 (usuario,nombre,email,direccion) values ($1,$2,$3,$4)' ,
    [usuario,nombre,email,direccion]),
    (error , results) => {
        if(error) {
            throw error;
        }
    }

    io.emit('mensaje' , 'Nuevo usuario creado');

    response.status(201).send('Usuarios agregado');
})

server.listen(port, (err) => {
    if (err) throw new Error(err);

    console.log(`Servidor corriendo en el puerto ${ port }`)
})