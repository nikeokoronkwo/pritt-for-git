import api from '@/lib/api'

export function getRepos() {
  return api.get('/repos')
}
