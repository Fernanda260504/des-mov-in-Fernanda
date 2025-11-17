const admin = require('firebase-admin');



// Carga del archivo de credenciales del service account

const serviceAccount = require('./serviceAccountKey.json');



// Inicializar el SDK de Firebase Admin

admin.initializeApp({

  credential: admin.credential.cert(serviceAccount),

});



// TODO: pega aquí el token FCM que te dio la app Flutter

const deviceToken ='en-Rm5vWRjmKSNdKaviFYn:APA91bEAxQZKvHkGlqSLRckjZ5ow7LxyGzC5IOuHYjuPSQDiLCxZ0_uTXzY2yrQPl0S0nONDCy2CPVG1TfKIWgkc4nYYyF7Ih2gSWrfLDVCLUJ5hEG4S0uY';



async function sendPush() {

  const message = {

    token: deviceToken,

    notification: {

      title: 'Hola desde Firebase Admin',

      body: 'Este es un mensaje enviado con la API v',

    },

    data: {

      origen: 'node-demo',

      tipo: 'prueba',

    },

  };



  try {

    const response = await admin.messaging().send(message);

    console.log('✅ Mensaje enviado correctamente:', response);

  } catch (error) {

    console.error('❌ Error al enviar mensaje:', error);

  }

}



sendPush();
