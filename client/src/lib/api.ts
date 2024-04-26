import axios from 'axios'

export default axios.create({
  baseURL: import.meta.env.DEV ? 'http://localhost:8080' : undefined,
  withCredentials: true
})
