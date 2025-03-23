const nodemailer = require('nodemailer');

const transporter = nodemailer.createTransport({
    service: 'gmail',
    auth: {
        user: 'bookworm.validation@gmail.com',
        pass: 'lxyh uoaq mgvd ecgd',
    },
});

const sendVerificationCode =async (email, code) => {
    const mailOptions = {
        from: 'bookworm.validation@gmail.com',
        to: email,
        subject: 'کد تأیید حساب کاربری',
        text: `،کاربر گرامی
    
        .از اینکه از سامانه ما استفاده می‌کنید سپاسگزاریم 
    
        ${code}:کد تأیید شما برای ورود به حساب کاربری 
    
        .لطفاً این کد را در فرم ورود وارد کنید 
        .این کد به مدت محدود معتبر است و برای امنیت بیشتر، آن را در اختیار دیگران قرار ندهید 
    
        ،با احترام
        Bookworm تیم پشتیبانی `,
    };
    
     
    await transporter.sendMail(mailOptions, (error, info) => {
        if (error) 
            {console.log(error);}
        else{
            console.log('Email sent: ' + info.response);
        }
    });

};

module.exports = sendVerificationCode;
