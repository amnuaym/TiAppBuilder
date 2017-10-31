var apn = require('apn');

// Set up apn และใส่ APNs Auth Key
var apnProvider = new apn.Provider({
     token: {
        key: 'apns.p8', //ระบุตำแหน่งที่วางไฟล์ .p8
        keyId: 'B62297EVJV', //ระบุ Key ID ของไฟล์ .p8
        teamId: 'E7GZZ3ATG5', // ระบุ Team ID ของ Apple Developer Account (ตรวจสอบได้ที่ https://developer.apple.com/account/#/membership/)
    },
    production: false //กำหนดให้เป็น true ถ้าส่ง Notification ไปยัง iOS App ที่ใช้งานจริง (Production)
});

//ระบุหมายเลข Token
var deviceToken = '4264DAC83648BA69D7F82EEB1B27D31417966248C526D4656BCA67DEFDA00F68';

//เตรียม Notification
var notification = new apn.Notification();

// กำหนด Bundle ID ของ iOS app
notification.topic = 'th.ac.dpu.ant.MyPushNotiApp';

// กำหนดระยะเวลา Expire 1 ชั่วโมงจากเวลาปัจจุบัน
notification.expiry = Math.floor(Date.now() / 1000) + 3600;

// กำหนด badge
notification.badge = 99;

// เล่นเสียง ping.aiff เมื่อได้รับ Notification
notification.sound = 'ping.aiff';

// ระบุรายละเอียดข้อความได้ทั้ง Text และ emoji
notification.alert = 'Hello from Unnknown LoL \u270C';

// ส่งข้อมูล payload data ไปกับ Notification เพื่อให้ตัว App สามารถเข้าถึงได้ ผ่าน  didReceiveRemoteNotification
notification.payload = {id: 123};

// ส่ง Notification
apnProvider.send(notification, deviceToken).then(function(result) {
    // แสดงผลการส่งว่ามีปัญหาในการส่งหรือไม๊
    console.log(result);
});
