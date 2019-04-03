const { Book } = require('../models')

module.exports = {
    // get all book
    async index(req, res) {
        try {
            let books = null
            const search = req.query.search
            // console.log('search key: ' + search)
            if (search) {
                books = await Book.findAll({
                    where: {
                        $or: [
                            'title', 'content', 'category'
                        ].map(key => ({
                            [key]: {
                                $like: `%${search}%`,
                            }
                        })),
                    },
                    order: [['createdAt', 'DESC']]
                })
            } else {
                books = await Book.findAll({
                    order: [['createdAt', 'DESC']]
                })
            }
            res.send(books)
        } catch (err) {
            res.status(500).send({
                error: 'an error has occured trying to fetch the books'
            })
        }
    },
    // create book
    async create(req, res) {
        // res.send(JSON.stringify(req.body))
        try {
            const book = await Book.create(req.body)
            res.send(book.toJSON())
        } catch (err) {
            res.status(500).send({
                error: 'Create book incorrect'
            })
        }
    },
    // edit book, suspend, active
    async put(req, res) {
        try {
            await Book.update(req.body, {
                where: {
                    id: req.params.bookId
                }
            })
            res.send(req.body)
        } catch (err) {
            req.status(500).send({
                error: 'Update book incorrect'
            })
        }
    },
    // delete book
    async remove(req, res) {
        try {
            const book = await Book.findOne({
                where: {
                    id: req.params.bookId
                }
            })
            if (!book) {
                return res.status(403).send({
                    error: 'The book information was incorrect'
                })
            }
            await book.destroy()
            res.send(book)
        } catch (err) {
            req.status(500).send({
                error: 'The book information was incorrect'
            })
        }
    },
    // get book by id
    async show(req, res) {
        try {
            const book = await Book.findById(req.params.bookId)
            res.send(book)
        } catch (err) {
            req.status(500).send({
                error: 'The book information was incorrect'
            })
        }
    },
    async frontIndex(req, res) {
        try {
            let books = null
            const search = req.query.search
            console.log('----------> search key: ' + search)
            if (search) {
                books = await Book.findAll({
                    where: {
                        $or: [
                            'title', 'content', 'category'
                        ].map(key => ({
                            [key]: {
                                $like: `%${search}%`,
                            }
                        })),
                        $and: [
                            {
                                status:
                                {
                                    $eq: "published"
                                }
                            },
                        ]
                    },
                    order: [['createdAt', 'DESC']]
                })
            } else {
                books = await Book.findAll({
                    where: {
                        'status': 'published'
                    },
                    order: [['createdAt', 'DESC']]
                })
            }
            res.send(books)
        } catch (err) {
            res.status(500).send({
                error: 'an error has occured trying to fetch the books'
            })
        }
    },
}