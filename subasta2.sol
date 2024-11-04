// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Subasta {
    address public subastador;
    uint public tiempoFinal;
    uint public duracionSubasta = 1 * 1 minutes;
    //uint public extensionTiempo = 10 minutes;
    uint public porcentajeIncremento = 5; // 5% de incremento mínimo
    uint public comision = 2; // Comisión del 2% para el gas en reembolsos
    bool public activa = true;
    uint public ofertaInicial = 1 ether;

    struct Oferta {
        address ofertante;
        uint cantidad;
    }

    Oferta[] public ofertas;
    mapping(address => uint) public depositos;

    event NuevaOferta(address ofertante, uint cantidad);
    event SubastaFinalizada(address ganador, uint cantidadGanadora);

    constructor(/* uint _duracionSubasta */) {
        subastador = msg.sender;
        tiempoFinal = block.timestamp + duracionSubasta;
        ofertas.push(Oferta(subastador, ofertaInicial));
        depositos[subastador] = ofertaInicial;
    }

    modifier soloDuranteSubastaActiva() {
        require(activa && block.timestamp < tiempoFinal, "La subasta ya ha finalizado");
        _;
    }

    modifier soloSubastador() {
        require(msg.sender == subastador, "Solo el subastador puede ejecutar esta accion");
        _;
    }

    function ofertar() external payable soloDuranteSubastaActiva {
        uint montoMinimo = ofertas[ofertas.length - 1].cantidad + (ofertas[ofertas.length - 1].cantidad * porcentajeIncremento / 100);
        require(msg.value > montoMinimo, "La oferta debe superar en al menos un 5% la oferta actual");

      
        tiempoFinal = block.timestamp + duracionSubasta;

        ofertas.push(Oferta(msg.sender, msg.value));
        depositos[msg.sender] += msg.value;
        emit NuevaOferta(msg.sender, msg.value);
    }

    function mostrarGanador() external view returns (address ganador, uint cantidadGanadora) {
        require(ofertas.length > 0, "No hay ofertas");
        ganador = ofertas[ofertas.length - 1].ofertante;
        cantidadGanadora = ofertas[ofertas.length - 1].cantidad;
    }

    function mostrarOfertas() external view returns (Oferta[] memory) {
        return ofertas;
    }

    function finalizarSubasta() external soloSubastador {
        require(block.timestamp >= tiempoFinal, "La subasta aun esta en curso");
        
        activa = false;
        
        /* if (ofertas.length > 0) {
            emit SubastaFinalizada(ofertas[ofertas.length - 1].ofertante, ofertas[ofertas.length - 1].cantidad);
        } */
    }


    function retirarDeposito() external {
        require(!activa, "La subasta aun esta activa");
        uint reembolso = depositos[msg.sender];
        require(reembolso > 0, "No hay deposito para devolver");

        address ganador = ofertas[ofertas.length - 1].ofertante;
        if (msg.sender != ganador) {
            uint descuento = reembolso * comision / 100;
            reembolso -= descuento;
        }

        depositos[msg.sender] = 0;
        payable(msg.sender).transfer(reembolso);
    }

    function retiroParcial() external soloDuranteSubastaActiva {
        uint depositoActual = depositos[msg.sender];
        uint ultimaOferta = 0;

        // Encuentra la última oferta del usuario
        for (uint i = ofertas.length; i > 0; i--) {
            if (ofertas[i - 1].ofertante == msg.sender) {
                ultimaOferta = ofertas[i - 1].cantidad;
                break;
            }
        }

        require(depositoActual > ultimaOferta, "No hay excedente para retirar");
        uint excedente = depositoActual - ultimaOferta;

        depositos[msg.sender] -= excedente;
        payable(msg.sender).transfer(excedente);
    }

    
}
