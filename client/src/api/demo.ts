import api from '@/lib/api'
import { postPath } from '@/lib/funcs'
import * as http from 'http'

export function getRepos() {
  return api.get('/api/repos')
}

export function createRepo(path: string, name: string) {
  const json = postPath(path)
  return api.post(`/api/new/${name}`, json)
  // return http.request({
  //   host: 'localhost',
  //   port:
  // });
}
