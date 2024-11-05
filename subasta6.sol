// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Subasta {
    struct Oferta {
        address ofertante;
        uint monto;
    }

    address public subastador;
    uint public tiempoFinalizacion;
    uint public plazoExtension = 30 seconds;
    uint public ofertaMinima;
    uint public comisionGas = 2; // 2%
    Oferta[] public historialOfertas;
    bool public subastaActiva;

    event NuevaOferta(address indexed ofertante, uint monto);
    event SubastaFinalizada(address ganador, uint montoGanador);

    constructor(uint _ofertaInicial) {
        subastador = msg.sender;
        ofertaMinima = _ofertaInicial;
        subastaActiva = true;
        tiempoFinalizacion = block.timestamp + plazoExtension;
        historialOfertas.push(Oferta(msg.sender, _ofertaInicial));
    }

    modifier soloSubastador() {
        require(msg.sender == subastador, "Solo el subastador puede ejecutar esta funcion");
        _;
    }

    modifier soloMientrasActiva() {
        require(subastaActiva, "La subasta no esta activa");
        _;
    }

    function ofertar() external payable soloMientrasActiva {
        require(msg.value >= (getOfertaMaxima() * 105) / 100, "La oferta debe ser al menos un 5% mayor que la oferta actual");
        require(block.timestamp < tiempoFinalizacion, "La subasta ha terminado");

        // Extender el tiempo de la subasta
        tiempoFinalizacion += plazoExtension;

        historialOfertas.push(Oferta(msg.sender, msg.value));
        emit NuevaOferta(msg.sender, msg.value);
    }

    function getOfertaMaxima() public view returns (uint) {
        return historialOfertas[historialOfertas.length - 1].monto;
    }

    function finalizarSubasta() external soloSubastador {
        require(block.timestamp >= tiempoFinalizacion, "La subasta no ha terminado");

        subastaActiva = false;
        address ganador = historialOfertas[historialOfertas.length - 1].ofertante;
        uint montoGanador = historialOfertas[historialOfertas.length - 1].monto;
        emit SubastaFinalizada(ganador, montoGanador);
    }

    function devolverDepositos() external soloSubastador {
    require(!subastaActiva, "La subasta esta activa");
    uint historialArray = historialOfertas.length;
    address ganador = historialOfertas[historialArray - 1].ofertante;

    for (uint i = 1; i < historialArray - 1; i++) { // Excluimos la última oferta (ganadora)
        address ofertante = historialOfertas[i].ofertante;
        uint monto = historialOfertas[i].monto;

        // Saltamos el reembolso si el ofertante es el ganador
        if (ofertante == ganador) {
            continue;
        }

        // Calculamos el monto después de descontar la comisión del 2%
        uint montoDevolver = (monto * (100 - comisionGas)) / 100;

        // Usamos 'call' para el reembolso, en lugar de 'transfer'
        (bool success, ) = ofertante.call{value: montoDevolver}("");
        require(success, "Fallo al reembolsar al ofertante");
    }
}



    function retirarParcial() external soloMientrasActiva {
        uint montoRetirar = 0;
        uint historialArray = historialOfertas.length;
        for (uint i = 0; i < historialArray - 1; i++) {
            if (historialOfertas[i].ofertante == msg.sender) {
                montoRetirar += historialOfertas[i].monto;
                delete historialOfertas[i]; // Remover oferta
            }
        }
        require(montoRetirar > 0, "No hay nada para retirar");
        payable(msg.sender).transfer(montoRetirar);
    }

    function mostrarOfertas() external view returns (Oferta[] memory) {
        return historialOfertas;
    }
}


