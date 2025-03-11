const nodemailer = require('nodemailer');

const transporter = nodemailer.createTransport({
    service: 'gmail',
    auth: {
        user: 'r.shiiranii@gmail.com',//this email must be changed to the site's email
        pass: 'cnab hrjx blkp oplw',
    },
});

const sendVerificationCode =async (email, code) => {
    const mailOptions = {
        from: 'r.shiiranii@gmail.com',
        to: email,
        subject: 'کد تأیید',
        text: `کد تأیید شما جهت ورود به سامانه: ${code}`,
    };

    console.log("hi stupid project");
    
     
    await transporter.sendMail(mailOptions, (error, info) => {
        if (error) 
            {console.log(error);}
        else{
            console.log('Email sent: ' + info.response);
            console.log("hi stupid project2");
        }
    });

};

module.exports = sendVerificationCode;
