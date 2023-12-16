import axios from "axios";
import fs from "fs";
const options = {method: 'GET', url: 'https://api.opendota.com/api/heroes'};

axios.request(options).then(function (response) {
    const heroes = response.data; // Save the heroes from the response
    fs.writeFile('heroes.json', JSON.stringify(heroes), function (err) {
        if (err) throw err;
        console.log('Heroes saved to heroes.json');
    });
}).catch(function (error) {
    console.error(error);
});