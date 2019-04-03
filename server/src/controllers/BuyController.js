const { Buy } = require('../models')
module.exports = {
    // index with serach buy
    async index(req, res) {
        try {
            let buys = null
            const search = req.query.search
            console.log('----------> search key: ' + search)
            if (search) {
                buys = await Buy.findAll({
                    where: {
                        $or: [
                            'booktitle', 'username', 'userlastname'
                        ].map(key => ({
                            [key]: {
                                $like: `%${search}%`,
                            }
                        })),
                    },
                    order: [['createdAt', 'DESC']]
                })
            } else {
                buys = await Buy.findAll({
                    order: [['createdAt', 'DESC']]
                })
            }
            res.send(buys)
        } catch (err) {
            res.status(500).send({
                error: 'an error has occured trying to fetch the buys'
            })
        }
    },
    // create buy
    async create(req, res) {
        // res.send(JSON.stringify(req.body))
        try {
            const buy = await Buy.create(req.body)
            res.send(buy.toJSON())
        } catch (err) {
            res.status(500).send({
                error: 'Create buy incorrect'
            })
        }
    },
    // edit buy, suspend, active
    async put(req, res) {
        try {
            await Buy.update(req.body, {
                where: {
                    id: req.params.buyId
                }
            })
            res.send(req.body)
        } catch (err) {
            req.status(500).send({
                error: 'Update buy incorrect'
            })
        }
    },
    // get buy by user id
    async user(req, res) {
        try {
            console.log('id: ' + req.params.userId)
            const buy = await Buy.findAll({
                where: {
                    userid: req.params.userid
                },
                order: [['createdAt', 'DESC']]
            })
            res.send(buy)
        } catch (err) {
            req.status(500).send({
                error: 'The buy information was incorrect'
            })
        }
    }
}