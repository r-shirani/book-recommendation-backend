const { body, validationResult } = require("express-validator");

const validateComment = [
    body("bookid")
        .notEmpty().withMessage("bookid is required"),
    body("text")
        .notEmpty().withMessage("text is required"),
    (req, res, next) => {
        const errors = validationResult(req);
        if (!errors.isEmpty()) {
            return res.status(400).json({ errors: errors.array() });
        }
        next();
    }
];

module.exports = { validateComment };
