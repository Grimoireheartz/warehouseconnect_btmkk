importScripts("https://www.gstatic.com/firebasejs/8.10.0/firebase-app.js");
importScripts("https://www.gstatic.com/firebasejs/8.10.0/firebase-messaging.js");


const firebaseConfig = {
    apiKey: "AIzaSyCfhL-4uEipzox-ehpXUmPsAYDKnY5z2ig",
    authDomain: "warehouseconnect-9df42.firebaseapp.com",
    projectId: "warehouseconnect-9df42",
    storageBucket: "warehouseconnect-9df42.appspot.com",
    messagingSenderId: "632282316706",
    appId: "1:632282316706:web:33f1cc61054ea25f9d7cfb",
    measurementId: "G-479CN87B6R"
};


firebase.initializeApp(firebaseConfig);

const messaging = firebase.messaging();

// Optional:
messaging.onBackgroundMessage((message) => {
    console.log("onBackgroundMessage", message);
});