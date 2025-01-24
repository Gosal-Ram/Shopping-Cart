function changeMainImage(src) {
    const activeItem = document.querySelector(".carousel-item.active img");
    if (activeItem) {
        activeItem.src = src;
    }
}