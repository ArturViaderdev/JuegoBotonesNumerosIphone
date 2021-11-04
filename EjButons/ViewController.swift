//
//  ViewController.swift
//  EjButons
//
//  Created by Arturv on 11/10/18.
//  Copyright © 2018 Artur Viader. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var lpuntos: UILabel!
    @IBOutlet weak var ltiempo: UILabel!
    
    
    @IBOutlet weak var bempezarout: UIButton!
    @IBAction func bempezarclick(_ sender: UIButton) {
        empezarpartida()
    }
    
    //Variables generales
    let maxbotones = 6 //Numero de botones por columna
    let maxcolumnas = 3 //Número de columnas
    let maxalea = 100 //Máximo número aleatorio
    let minalea = -100 //Mínimo número aleatorio
    
    var numeros:[Int] = []  //Lista de números
    //var pulsados = 0  //Recuerda cuantos botones se han acertado versión anterior
    var timer = Timer()
    var segundos = 30 //Tiempo
    var partida = false //Indica si la partida está en curso
    var puntos = 0 //Guarda los puntos
    
    var puntossumados = 0 //Cuenta puntos hasta que activa otra columna
    var columnascreadas = 0 //Cuenta columnas
    
    var botones:[UIButton] = [] //Lista de botones
    
    //Crea los botones
    func crearbotones()
    {
        var cont=0
        var posx=0
        //Crea tantos botones como maxbotones dice situados uno debajo del otro
        while cont<maxbotones
        {
            //Según la columna actual situa la coordenada x diferente.
            //Solo contempla 3 columnas
            switch(columnascreadas)
            {
                //La posición 
                case 0:
                    //Primera columna 50 separado de la izquierda
                    posx = 50
                case 1:
                    let tamanopantalla: CGRect = UIScreen.main.bounds
                    posx = (Int(tamanopantalla.width)/2) - 50
                    //Segunda columna 50 a la izquierda del centro
                case 2:
                    let tamanopantalla: CGRect = UIScreen.main.bounds
                    posx = Int(tamanopantalla.width) - 150
                    //Tercera columna 150 a la izquierda del margen derecho
                default:
                    print("fuera de sitio")
            }
            //Crea el boton
            let myButton = UIButton(type:.system)
          
            //myButton.frame = CGRect(x: 100*(columnascreadas+1), y: (cont + 1) * 100, width: 50, height: 50)
            //Define la posición del botón
            //La coordenada y se toma multiplicando por 100 el número de elemento
            myButton.frame = CGRect(x: posx, y: (cont + 1) * 100, width: 50, height: 50)
            //Pone el fondo del botón en verde
            myButton.backgroundColor = UIColor.green
            //Hace que el botón sea visible
            myButton.isHidden=false
            //Añade el botón a la pantalla
            self.view.addSubview(myButton)
            //Añade el evento click del botón que llama a la funcion botonclick
            myButton.addTarget(self, action: #selector(botonclick(_:)), for: UIControl.Event.touchUpInside)
            //Añade el botón a la lista de botones
            botones.append(myButton)
            cont+=1
        }
   
    }
    
    //Se ejecuta cuando se pulsa un botón
    @objc func botonclick(_ sender: UIButton!)
    {
        if (partida)  //si la partida está iniciada
        {
            if(numeros[0] == Int(sender.currentTitle!))
            {
                numeros.remove(at:0)
                //Si el numero pulsado es el siguiente de la lista ha pulsado ok
                //pulsados+=1 // Se incrementaba el contador version anterior
                puntos+=100 //Se incrementan los puntos
                puntossumados+=100 //Se incrementa el contador de puntos
                //Si se han añadido 300 puntos más y no hay todavía 3 columnas se añade una columna
                if(puntossumados==300 && columnascreadas<maxcolumnas-1)
                {
                    puntossumados=0
                    columnascreadas += 1
                    //Se crea otra columna de botones
                    crearbotones();
                    //Se ponen números nuevos en los botones y la lista y se reordena
                    ponnumeros();
                }
                
                //Se muestran los puntos
                muestrapuntos()
                //Se invisibiliza el boton que se ha pulsado
                sender.isHidden = true
                //Si se han pulsado todos los botones
                if numeros.count==0
                {
                    //se termina la partida ha ganado
                    terminapartida()
                }
            }
            else
            {
                //En caso de haber fallado el jugador
                //Se quitan dos segundos de tiempo si todavía queda suficiente tiempo
                if(segundos>=2)
                {
                    segundos -= 2
                }
                else
                {
                    //Si no quedan más de dos segundos se termina la partida
                    segundos = 0
                    terminapartida();
                }
            }
        }
    }
    
    //Termina la partida
    func terminapartida()
    {
        partida = false
        //Visibiliza el botón de empezar y para el tiempo
        bempezarout.isHidden = false
        //Se para el tiempo
        timer.invalidate()
    }
    
    //Arranca el tiempo
    func arrancatiempo()
    {
        //Se crea un temporizador que cada segundo llamará a la función cambiatiempo
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: (#selector(cambiatiempo)), userInfo: nil, repeats: true)
    }
    
    //se ejecuta cada segundo cuando el tiempo está activado
    @objc func cambiatiempo()
    {
        //Se comprueba que la partida esta iniciada aunque el tiempo tambien se para
        if(partida)
        {
            //Se muestran los segundos
            //Si los segundos son menos de 9 se añade un 0 mas
            if(segundos>9)
            {
                ltiempo.text = "00:\(segundos)"
            }
            else
            {
                ltiempo.text = "00:0\(segundos)"
            }
            
            //Si queda tiempo se resta un segundo
            if(segundos>0)
            {
                
                segundos -= 1
            }
            else
            {
                //Si no queda tiempo se termina la partida
                terminapartida()
            }
        }
    }
    
    //Pinta los botones recibe la lista por parámetro aunque podria cogerla del general
    func pintabotones(numeros:[Int],inicio:Int)
    {
        //Se recorre la lista de numeros desordenada
        var posboton = columnascreadas * 6
        
     
        for index in inicio..<numeros.count
        {
            botones[posboton].setTitle(String(numeros[index]),for: .normal)
            posboton += 1
        }
    }
    
    //Crea los números aleatorios
    func ponnumeros()
    {
        var cont = 0
        var cuantos = numeros.count
        while cont<maxbotones
        {
            numeros.append(Int.random(in: minalea ... maxalea))
            cont += 1
        }
        //Pinta los numeros en los botones
        pintabotones(numeros: numeros, inicio: cuantos)
        //ordena los numeros para tenerlos ordenados en memoria
        numeros.sort()
    }
    
    //muestra los puntos
    func muestrapuntos()
    {
        lpuntos.text = "Puntos:\(puntos)"
    }
    
    //Elimina los botones
    func eliminabotones()
    {
        for elboton in botones{
            elboton.self.removeFromSuperview()
        }
    }
    
    //empieza la partida
    func empezarpartida()
    {
        //se inicializan las variables
        columnascreadas = 0
        puntossumados = 0
        puntos = 0
        //se eliminan los botones si hay
        eliminabotones()
        //se elimina la lista de números
        numeros.removeAll()
        //se elimina la lista de botones
        botones.removeAll()
        //se crea una columna de botones
        crearbotones()
        //invisibiliza el botón de empezar
        bempezarout.isHidden = true
        //inicializa las variables
        //pulsados=0
        puntos=0
        //muestra que hay 0 puntos
        muestrapuntos()
        partida = true
        //Crea los números
        ponnumeros()
        //Visibiliza los botones
        visibilizabotones()
        //Pone el tiempo en 30 segundos
        segundos = 30
        //Arranca el tiempo
        arrancatiempo()
        
    }
    
    //Visibiliza los botones
    func visibilizabotones()
    {
        for boton in botones
        {
            boton.isHidden=false
        }
    }
    
    //Al arrancar la aplicación empieza la partida
    override func viewDidLoad() {
        super.viewDidLoad()
        let tamanopantalla: CGRect = UIScreen.main.bounds
        //se situa el botón de volver a empezar todavia invisible cerca del margen inferior
        bempezarout.frame.origin = CGPoint(x:tamanopantalla.width/2,y:tamanopantalla.height - 100)
        empezarpartida()
        // Do any additional setup after loading the view, typically from a nib.
    }


}

