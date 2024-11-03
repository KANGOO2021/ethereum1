// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Subasta {
    address public subastador;
    uint public tiempoFinal;
    uint public tiempoInicial;
    uint public extensionTiempo = 2 minutes;
    uint public porcentajeIncremento = 5;
    uint public comisionGas = 2;

    struct Oferta {
        address ofertante;
        uint cantidad;
    }

    Oferta public ofertaGanadora;
    mapping(address => uint) public depositos;
    Oferta[] public historialOfertas;

    bool public subastaActiva;
    uint public precioInicial = 1 ether;

    event NuevaOferta(address indexed ofertante, uint cantidad);
    event SubastaFinalizada(address ganador, uint cantidad);

    modifier soloSubastador() {
        require(msg.sender == subastador, "Solo el subastador puede ejecutar esta funcion");
        _;
    }

    modifier subastaEnCurso() {
        require(block.timestamp < tiempoFinal && subastaActiva, "La subasta ha finalizado");
        _;
    }

    constructor() {
        subastador = msg.sender;
        tiempoInicial = block.timestamp;
        tiempoFinal = tiempoInicial + 2 minutes;
        subastaActiva = true;
        
        // Inicializamos la oferta ganadora con el precio inicial
        ofertaGanadora = Oferta(address(0), precioInicial);
    }

    function ofertar() public payable subastaEnCurso {
        require(msg.value > 0, "La oferta debe ser mayor a cero");
        
        // Requiere que la oferta sea al menos un 5% mayor que la oferta ganadora actual
        uint incrementoMinimo = ofertaGanadora.cantidad + (ofertaGanadora.cantidad * porcentajeIncremento / 100);
        require(msg.value >= incrementoMinimo, "La oferta debe superar la oferta actual en al menos un 5%");

        // Actualizamos el historial de ofertas
        if (depositos[msg.sender] > 0) {
            uint reembolso = depositos[msg.sender];
            depositos[msg.sender] = msg.value;
            historialOfertas.push(Oferta(msg.sender, msg.value));
            (bool exito, ) = msg.sender.call{value: reembolso}("");
            require(exito, "Error al devolver el exceso de deposito");
        } else {
            depositos[msg.sender] = msg.value;
            historialOfertas.push(Oferta(msg.sender, msg.value));
        }
        
        // Actualizamos la oferta ganadora
        ofertaGanadora = Oferta(msg.sender, msg.value);
        emit NuevaOferta(msg.sender, msg.value);

        // Extiende la subasta si faltan 10 minutos o menos
        if (block.timestamp >= tiempoFinal - extensionTiempo) {
            tiempoFinal += extensionTiempo;
        }
    }

    function mostrarGanador() public view returns (address, uint) {
        require(!subastaActiva, "La subasta aun esta en curso");
        return (ofertaGanadora.ofertante, ofertaGanadora.cantidad);
    }

    function mostrarOfertas() public view returns (Oferta[] memory) {
        return historialOfertas;
    }

    function finalizarSubasta() public soloSubastador {
        require(subastaActiva, "La subasta ya ha finalizado");
        require(block.timestamp >= tiempoFinal, "La subasta aun no ha llegado a su fin");
        
        subastaActiva = false;
        emit SubastaFinalizada(ofertaGanadora.ofertante, ofertaGanadora.cantidad);
    }

    function devolverDepositos() public soloSubastador {
        require(!subastaActiva, "La subasta aun esta en curso");

        for (uint i = 0; i < historialOfertas.length; i++) {
            address ofertante = historialOfertas[i].ofertante;
            uint monto = depositos[ofertante];
            if (ofertante != ofertaGanadora.ofertante && monto > 0) {
                uint reembolso = monto - (monto * comisionGas / 100);
                depositos[ofertante] = 0;
                (bool exito, ) = ofertante.call{value: reembolso}("");
                require(exito, "Error al realizar el reembolso");
            }
        }
    }

    function retirarExceso() public {
        require(depositos[msg.sender] > 0, "No tienes depositos disponibles");
        require(subastaActiva, "La subasta ha finalizado");

        uint exceso = depositos[msg.sender] - ofertaGanadora.cantidad;
        require(exceso > 0, "No hay exceso para retirar");

        depositos[msg.sender] = ofertaGanadora.cantidad;
        (bool exito, ) = msg.sender.call{value: exceso}("");
        require(exito, "Error al retirar exceso");
    }
}
