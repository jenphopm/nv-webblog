import Api from '@/services/Api'

export default {
    index(search) {
        return Api().get('buys', {
            params: {
                search: search
            }
        })
    },
    post(book) {
        return Api().post('buy', book)
    },
    put(book) {
        return Api().put('buy/' + book.id, book)
    },
    user(userid) {
        return Api().get('buy/user/' + userid)
    }
}