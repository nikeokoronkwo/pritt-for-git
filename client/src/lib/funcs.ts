export function postPath(p: string) {
  return {
    base: import.meta.env.CLIENT_PATH_FROM_SERVER,
    path: p
  }
}
