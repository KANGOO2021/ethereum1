// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Subasta {
    address public subastador;
    uint public tiempoFinalSubasta;
    address public mejorPostor;
    uint public mejorOferta;
    mapping(address => uint) public ofertasPendientes;
    mapping(address => uint) public depositosAcumulados;
    bool finalizada;
    uint public precioBase = 1 ether; // Precio base de 1 ETH

    struct Oferta {
        address postor;
        uint cantidad;
    }

    Oferta[] public historialOfertas;
    Oferta public ofertaGanadora; // Agregar esta línea

    event OfertaMejorada(address postor, uint oferta);
    event SubastaFinalizada(address ganador, uint oferta);
    event OfertaAceptada(address postor, uint oferta); // Evento para oferta aceptada

    constructor() {
        subastador = msg.sender;
        tiempoFinalSubasta = block.timestamp + 300; // 5 minutos en segundos
        mejorOferta = precioBase; // Establecer el precio base
    }

    function ofertar() public payable {
        require(block.timestamp < tiempoFinalSubasta, "La subasta ha finalizado");
        require(msg.value >= mejorOferta + (mejorOferta * 5 / 100), "La oferta debe ser al menos un 5% mayor");

        if (mejorOferta != 0 && mejorPostor != address(0)) {
            ofertasPendientes[mejorPostor] += mejorOferta;
        }

        mejorPostor = msg.sender;
        mejorOferta = msg.value;

        // Incrementar el tiempo final de la subasta si la oferta se realiza en los últimos 2 minutos
        if (block.timestamp >= tiempoFinalSubasta - 120) { // 120 segundos = 2 minutos
            tiempoFinalSubasta += 120; // Añadir 2 minutos
        }

        // Registrar la oferta en el historial
        historialOfertas.push(Oferta({
            postor: msg.sender,
            cantidad: msg.value
        }));

        // Registrar el depósito acumulado
        depositosAcumulados[msg.sender] += msg.value;

        emit OfertaMejorada(msg.sender, msg.value);
        emit OfertaAceptada(msg.sender, msg.value); // Emitir evento de oferta aceptada
    }

    function retirarOfertasPendientes() public {
        uint cantidad = ofertasPendientes[msg.sender];
        require(cantidad > 0, "No hay fondos pendientes");

        ofertasPendientes[msg.sender] = 0;

        payable(msg.sender).transfer(cantidad);
    }

    function finalizarSubasta() public {
        require(block.timestamp >= tiempoFinalSubasta, "La subasta no ha finalizado");
        require(!finalizada, "La subasta ya ha sido finalizada");

        finalizada = true;
        ofertaGanadora = Oferta({postor: mejorPostor, cantidad: mejorOferta}); // Registrar oferta ganadora
        emit SubastaFinalizada(mejorPostor, mejorOferta);

        payable(subastador).transfer(mejorOferta);
    }

    function devolverDepositos() public {
        require(finalizada, "La subasta no ha finalizado");
       
        for (uint i = 0; i < historialOfertas.length; i++) {
            Oferta memory oferta = historialOfertas[i];
            if (oferta.postor != mejorPostor) {
                uint cantidad = oferta.cantidad;
                uint comision = (cantidad * 2) / 100; // Calcular comisión del 2%
                uint devolver = cantidad - comision;

                // Transferir el monto menos la comisión
                payable(oferta.postor).transfer(devolver);

                // Transferir la comisión al subastador
                payable(subastador).transfer(comision);
        }
    }
}
}