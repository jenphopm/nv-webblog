const UserController = require('./controllers/UserController')
const UserAuthenController = require('./controllers/UserAuthenController')
const isAuthenController = require('./controllers/isAuthenController')
const BlogController = require('./controllers/BlogController')
const CommentController = require('./controllers/CommentController')

let multer = require("multer")

module.exports = (app) => {
    // upload section
    let storage = multer.diskStorage({
        destination: function (req, file, callback) {
            callback(null, "./public/uploads");
        },
        filename: function (req, file, callback) {
            // callback(null, file.fieldname + '-' + Date.now());
            console.log(file);
            callback(null, file.originalname);
        }
    })
    let upload = multer({ storage: storage }).array("userPhoto", 10)

    /* RESFUL Api for users management */
    // create user
    app.post('/user',
        UserController.create
    )
    // edit user, suspend, active
    app.put('/user/:userId',
        UserController.put
    )
    // delete user
    app.delete('/user/:userId',
        isAuthenController,
        UserController.remove
    )
    // get user by id
    app.get('/user/:userId',
        UserController.show
    )
    // get all user
    app.get('/users',
        isAuthenController,
        UserController.index
    )
    // login
    app.post('/login',
        UserAuthenController.login
    )
    app.post('/front/login',
        UserAuthenController.clientLogin
    )

    // blog route
    // create blog
    app.post('/blog',
        isAuthenController,
        BlogController.create
    )
    // edit blog, suspend, active
    app.put('/blog/:blogId',
        isAuthenController,
        BlogController.put
    )
    // delete blog
    app.delete('/blog/:blogId',
        isAuthenController,
        BlogController.remove
    )
    // get blog by id
    app.get('/blog/:blogId',
        BlogController.show
    )
    // get all blog
    app.get('/blogs',
        isAuthenController,
        BlogController.index
    )

    // comment route
    // create comment
    app.post('/comment',
        CommentController.create
    )
    // edit comment, suspend, active
    app.put('/comment/:commentId',
        CommentController.put
    )
    // delete comment
    app.delete('/comment/:commentId',
        CommentController.remove
    )
    // get comment by id
    app.get('/comment/:commentId',
        CommentController.show
    )
    // get all comment
    app.get('/comments',
        CommentController.index
    )
    // upload
    app.post("/upload", isAuthenController, function (req, res) {
        upload(req, res, function (err) {
            if (err) {
                return res.end("Error uploading file.");
            }
            res.end("File is uploaded");
        })
    })
    //delete file uploaded function
    app.post('/upload/delete', isAuthenController, async function (req, res) {
        try {
            const fs = require('fs');
            console.log(req.body.filename)
            fs.unlink(process.cwd() + '/public/uploads/' + req.body.filename,
                (err) => {
                    if (err) throw err;
                    res.send("Delete sucessful")
                    // console.log('successfully deleted material file');
                });
        } catch (err) {
            res.status(500).send({
                error: 'An error has occured trying to delete file the material'
            })
        }
    })
    // get comment by blog id
    app.get('/comment/blog/:blogId',
        CommentController.blog
    )
    // get comment by user id
    app.get('/comment/user/:userId',
        CommentController.user
    )
    // users
    // get front
    app.get('/users/front',
        UserController.getFront
    )
    app.get('/blogs/front',
        BlogController.frontIndex
    )
}