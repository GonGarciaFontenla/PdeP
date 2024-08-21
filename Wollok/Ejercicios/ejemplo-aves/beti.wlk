object beti {
    var companiera = null

    method companiera(nuevaCompa) {
        companiera = nuevaCompa
    }
    method comer(gramos){
        companiera.comer(gramos/2)
    }
    method volar(kilometros){
        companiera.volar(kilometros)
    }
    method energia(){
        return companiera.energia()
    }
}