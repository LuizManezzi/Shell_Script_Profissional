function abrirmenu() {

    const menuDiv = document.getElementById('menu-mobile')
    const btnAnimar = document.getElementById('btn-menu')
    
    menuDiv.addEventListener('click', abrirmenu)

    menuDiv.classList.toggle('abrir')
    btnAnimar.classList.toggle('ativo')
}

/* function abrirmenu(){
    const btn=document.getElementById('btn-menu')
    btn.classList.toggle('abre')
} */