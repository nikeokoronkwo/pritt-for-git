import axios from 'axios'

export default axios.create({
  baseURL: import.meta.env.DEV ? (import.meta.env.VITE_PRITT_URL ?? 'http://localhost:8082') : undefined,
  withCredentials: true
})
