require('dotenv').config();

console.log(`<pre>{
    APP_NAME: '${process.env.APP_NAME}',
    MY_VAR: '${process.env.MY_VAR}',
    ANOTHER_VAR: '${process.env.ANOTHER_VAR}',
}</pre>`);
