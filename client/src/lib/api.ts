import axios from 'axios'

export default axios.create({
  baseURL: import.meta.env.DEV ? 'http://localhost:8082' : undefined,
  withCredentials: true
})
