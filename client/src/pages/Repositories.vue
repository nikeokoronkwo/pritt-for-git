<script setup>
// import { defineAsyncComponent } from 'vue';
// const RepositoriesView = defineAsyncComponent(() => {
//   import('../components/RepositoriesView.vue')
// })
import RepositoriesView from '../components/RepositoriesView.vue'
</script>

<template>
  <div class="px-5 py-5">
    <nav class="navbar">
      <button class="border border-transparent rounded-xl m-0">
        <RouterLink to="/">Home</RouterLink>
      </button>
    </nav>
    <Suspense>
      <RepositoriesView />

      <template #fallback>
        <div>Sorry, the repositories could not be retrieved at this moment</div>
      </template>
    </Suspense>
  </div>
</template>

<style scoped>
.navbar {
  height: 3rem;
  justify-content: center;
  align-items: center;
}
</style>
