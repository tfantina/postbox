import { autofill, config } from '@mapbox/search-js-web'

export default initMap = () => {
    // this token is scoped to postbox.xyz and will not work elsewhere
    // for development purposes swap it with your own 
    config.accessToken = 'pk.eyJ1IjoidGZhbnRpbmEiLCJhIjoiY2x5cHJtMXNoMHV5YjJqb2hkaWljdzF1NCJ9.4U7TaLB5Y-p_Rryr9bb5YA'
    autofill({
        options: {
        }
    })

    mapListener()
}

const mapListener = () => {
    const mapFill = document.getElementById("map-fill");
    const mapFillHidden = document.getElementById("map-fill--hidden");
    mapFillHidden.value = mapFill.value 

    mapFill.addEventListener('change', () => {
        mapFillHidden.value = mapFill.value
    })
}