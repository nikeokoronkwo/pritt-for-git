import axios from 'axios'

export default axios.create({
  baseURL: import.meta.env.PRITT_BASE_URL,
  withCredentials: true
})
