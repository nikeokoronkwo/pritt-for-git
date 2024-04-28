<script setup>
import * as demoApi from '@/api/demo'

async function getRepos() {
  return await Promise.resolve(demoApi.getRepos()).then((e) => {
    return typeof e.data === 'string' ? JSON.parse(e.data) : e.data
  })
}

let repos = await getRepos()
</script>

<template>
  <div>
    <h1 class="text-2xl flex justify-center px-5 py-5">Your Repositories</h1>
    <div v-if="repos.length != 0 && repos !== undefined">
      <h1>{{ repos.length }} {{ repos.length === 1 ? 'Repository' : 'Repositories' }}</h1>
      <div v-for="repo in repos" :key="repo">
        <div class="repo-tile border-t-2 border-b-2 border-white rounded-sm">
          <div class="repo-name">
            <p class="text-dark text-balance">{{ repo.name }}</p>
          </div>
          <div class="repo-button">
            <button
              class="px-4 py-1 rounded-full border border-spacing-4 border-white hover:text-white hover:bg-yellow-500 hover:border-transparent focus:outline-none focus:ring-2 focus:ring-yellow-500 focus:ring-offset-2"
            >
              View
            </button>
          </div>
        </div>
      </div>
      <div class="bottom-navbar">
        <nav>
          <button
            class="px-4 py-1 rounded-full border border-spacing-4 border-white hover:text-white hover:bg-yellow-500 hover:border-transparent focus:outline-none focus:ring-2 focus:ring-yellow-500 focus:ring-offset-2"
          >
            <RouterLink to="/create/repo">Create A New Repository</RouterLink>
          </button>
        </nav>
      </div>
    </div>
    <div
      v-else
      class="flex self-center justify-center border border-spacing-2 border-white rounded-xl px-5 py-5 space-y-8 flex-col"
    >
      <p class="flex self-center justify-center">
        You do not have any repositories at the current moment
      </p>
      <button
        class="px-4 py-1 rounded-full border border-spacing-4 border-white hover:text-white hover:bg-yellow-500 hover:border-transparent focus:outline-none focus:ring-2 focus:ring-yellow-500 focus:ring-offset-2"
      >
        <RouterLink to="/create/repo">Create A New Repository</RouterLink>
      </button>
    </div>
  </div>
</template>

<style scoped>
.bottom-navbar {
  bottom: 0;
  align-self: center;
  align-content: center;
  justify-self: center;
  position: fixed;
  display: flex;
  height: 5rem;
}

.repo-tile {
  display: flex;
  min-width: 75vh;
  justify-content: space-between;
  align-items: center;
  padding: 3vh;
}
</style>
