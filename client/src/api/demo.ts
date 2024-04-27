import api from '@/lib/api'
import { postPath } from '@/lib/funcs'

export function getRepos() {
  return api.get('/api/repos')
}

export function createRepo(path: string, name: string) {
  const json = postPath(path)
  return api.post(`/api/new/${name}`, json)
}
