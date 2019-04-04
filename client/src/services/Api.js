import axios from 'axios'
import store from '@/store'

export default () => {
    return axios.create({
        // baseURL: 'http://localhost:8081/',
        baseURL: 'http://ec2-3-1-205-161.ap-southeast-1.compute.amazonaws.com:8081/',
        headers: {
            Authorization: `Bearer ${store.state.token}`
        }
    })
}