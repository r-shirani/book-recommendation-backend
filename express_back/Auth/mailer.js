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
        html: `
            <div style="background-color: #0f0f0f; padding: 30px; text-align: center; font-family: Arial, sans-serif; color: #fff;">
                <div style="max-width: 400px; margin: auto; background: #1c1c1c; padding: 20px; border-radius: 10px; box-shadow: 0 0 10px rgba(255, 255, 255, 0.1);">
                    <h2 style="color: #fff;">📌 کد تأیید حساب کاربری</h2>
                    <p style="font-size: 16px; color: #bbb;">
                        ،کاربر گرامی 
                    </p>
                    <p style="font-size: 16px; color: #bbb;">
                        خوش آمدید Bookworm به سامانه 
                    </p>
                    <div style="background: #a94442; color: #fff; font-size: 22px; font-weight: bold; padding: 15px; border-radius: 8px; margin: 15px auto; max-width: 300px;">
                        ${code}
                    </div>
                    <p style="font-size: 14px; color: #bbb;">
                        این کد فقط برای مدت محدودی معتبر است و برای امنیت بیشتر آن را در اختیار دیگران قرار ندهید
                    </p>
                    <hr style="border: none; border-top: 1px solid #444; margin: 20px 0;">
                    <p style="font-size: 14px; color: #bbb;">
                        Bookworm با احترام، تیم پشتیبانی 
                    </p>
                    <p style="font-size: 16px; font-weight: bold; color: #fff;">
                        📚 Bookworm Team
                    </p>
                </div>
            </div>
        `,
    };
    
     
    await transporter.sendMail(mailOptions, (error, info) => {
        if (error) 
            {console.log(error);}
        else{
            console.log('Email sent: ' + info.response);
        }
    });

};



const sendVerificationCode_password = async (email, code) => {
    const mailOptions = {
        from: 'bookworm.validation@gmail.com',
        to: email,
        subject: 'کد تأیید برای تغییر رمز عبور',
        html: `
            <div style="background-color: #0f0f0f; padding: 30px; text-align: center; font-family: Arial, sans-serif; color: #fff;">
                <div style="max-width: 400px; margin: auto; background: #1c1c1c; padding: 20px; border-radius: 10px; box-shadow: 0 0 10px rgba(255, 255, 255, 0.1);">
                    <h2 style="color: #fff;">🔒 کد تأیید تغییر رمز عبور</h2>
                    <p style="font-size: 16px; color: #bbb;">
                        کاربر گرامی،
                    </p>
                    <p style="font-size: 16px; color: #bbb;">
                        شما درخواست تغییر رمز عبور حساب کاربری خود را داده‌اید. لطفاً از کد زیر برای ادامه فرایند استفاده کنید:
                    </p>
                    <div style="background: #a94442; color: #fff; font-size: 22px; font-weight: bold; padding: 15px; border-radius: 8px; margin: 15px auto; max-width: 300px;">
                        ${code}
                    </div>
                    <p style="font-size: 14px; color: #bbb;">
                        این کد فقط برای مدت محدودی معتبر است. در صورتی که شما این درخواست را ارسال نکرده‌اید، این ایمیل را نادیده بگیرید.
                    </p>
                    <hr style="border: none; border-top: 1px solid #444; margin: 20px 0;">
                    <p style="font-size: 14px; color: #bbb;">
                        با احترام، تیم پشتیبانی Bookworm
                    </p>
                    <p style="font-size: 16px; font-weight: bold; color: #fff;">
                        📚 Bookworm Team
                    </p>
                </div>
            </div>
        `,
    };

    try {
        const info = await transporter.sendMail(mailOptions);
        console.log('Email sent: ' + info.response);
    } catch (error) {
        console.log(error);
    }
};





module.exports = {
    sendVerificationCode,
    sendVerificationCode_password
};
