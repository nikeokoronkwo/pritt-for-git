<script setup>
import * as demoApi from '@/api/demo'
import { onMounted, ref } from 'vue'

let repos = ref([])
async function getRepos() {
  const { data } = await demoApi.getRepos()
  repos = typeof data === 'string' ? JSON.parse(data) : data
}

onMounted(async () => {
  console.log(import.meta.env)
  await getRepos()
})
</script>

<template>
  <div class="px-5 py-5">
    <nav class="navbar">
      <button class="border border-transparent rounded-xl m-0">
        <RouterLink to="/">Home</RouterLink>
      </button>
    </nav>
    <div class="main-menu">
      <h1 class="text-2xl flex justify-center px-5 py-5">Your Repositories</h1>
      <div v-if="repos.length > 0">
        <h1>{{ repos.length }} Repositories</h1>
        <div v-for="repo in repos" :key="repo"></div>
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
  </div>
</template>

<style>
.navbar {
  height: 3rem;
  justify-content: center;
  align-items: center;
}

.main-menu {
}
</style>
