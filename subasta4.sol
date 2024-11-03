// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Subasta {
    address public subastador;
    uint public tiempoFinal;
    uint public duracionSubasta = 3 minutes;
    uint public porcentajeIncremento = 5; // 5% de incremento mínimo
    bool public activa = true;
    uint public ofertaInicial = 1 ether;

    struct Oferta {
        address ofertante;
        uint cantidad;
    }

    Oferta public mejorOferta;
    mapping(address => uint) public depositos;
    Oferta[] public historialOfertas; // Array para almacenar todas las ofertas

    event NuevaOferta(address ofertante, uint cantidad);
    event SubastaFinalizada(address ganador, uint cantidadGanadora);

    constructor() {
        subastador = msg.sender;
        tiempoFinal = block.timestamp + duracionSubasta;
        
        // La oferta inicial es realizada por el subastador con un valor mínimo
        mejorOferta = Oferta(subastador, ofertaInicial);
        depositos[subastador] = ofertaInicial;
        
        // Registrar la oferta inicial en el historial
        historialOfertas.push(mejorOferta);
    }

    modifier soloDuranteSubastaActiva() {
        require(activa && block.timestamp < tiempoFinal, "La subasta ya ha finalizado");
        _;
    }

    function ofertar() external payable soloDuranteSubastaActiva {
        uint montoMinimo = mejorOferta.cantidad + (mejorOferta.cantidad * porcentajeIncremento / 100);
        
        // Validar que la nueva oferta sea superior en al menos un 5%
        require(msg.value >= montoMinimo, "La oferta debe superar en al menos un 5% la oferta actual");

        // Reembolsar la oferta anterior descontando un 2%
        if (mejorOferta.ofertante != subastador) {
            uint reembolso = depositos[mejorOferta.ofertante] - (depositos[mejorOferta.ofertante] * 2 / 100); // 2% de comisión
            payable(mejorOferta.ofertante).transfer(reembolso);
            depositos[mejorOferta.ofertante] = 0;
        }

        // Actualizar la nueva mejor oferta
        mejorOferta = Oferta(msg.sender, msg.value);
        depositos[msg.sender] += msg.value;

        // Extender el tiempo final de la subasta a 10 minutos desde esta nueva oferta
        tiempoFinal = block.timestamp + duracionSubasta;

        // Guardar la oferta en el historial
        historialOfertas.push(mejorOferta);

        emit NuevaOferta(msg.sender, msg.value);
    }

    function verificarFinalizacionSubasta() external {
        // Verifica si han pasado los 10 minutos sin nuevas ofertas y termina la subasta automáticamente
        if (block.timestamp >= tiempoFinal && activa) {
            finalizarSubasta();
        }
    }

    function finalizarSubasta() internal {
        activa = false;
        
        address ganador = mejorOferta.ofertante;
        uint cantidadGanadora = mejorOferta.cantidad;

        emit SubastaFinalizada(ganador, cantidadGanadora);
    }

    function mostrarGanador() external view returns (address ganador, uint cantidadGanadora) {
        require(!activa, "La subasta aun esta activa");
        ganador = mejorOferta.ofertante;
        cantidadGanadora = mejorOferta.cantidad;
    }

    // Nueva función para mostrar todas las ofertas y sus ofertantes
    function mostrarOfertas() external view returns (Oferta[] memory) {
        return historialOfertas;
    }
}
