const https = require('https');

const options = {
  hostname: 'sednex-zvk1.onrender.com',
  path: '/api/sections/embassy/items',
  method: 'GET',
  headers: {
    'Authorization': 'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOiI2OTk5MzhmYjViNWJjMmM1YjEyMzYyY2QiLCJlbWFpbCI6ImFmc2FyQHNlZG5leC5jb20iLCJyb2xlIjoidXNlciIsImlhdCI6MTc3Mjg2MTYzMiwiZXhwIjoxNzczNDY2NDMyfQ.PuRUjybyM9EzP2ICL0X_SXoSx8PwDOlJh0XrSi5fiwU'
  }
};

const req = https.request(options, (res) => {
  let data = '';
  res.on('data', (chunk) => { data += chunk; });
  res.on('end', () => {
    try {
      const json = JSON.parse(data);
      console.log(JSON.stringify(json.items[0], null, 2));
    } catch (e) {
      console.log('Error parsing JSON');
      console.log(data.substring(0, 500));
    }
  });
});

req.on('error', (e) => {
  console.error(e);
});
req.end();
