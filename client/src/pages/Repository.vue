<script>
export default {
  name: 'DynamicRoute',
  data() {
    return {
      dynamicParam: null
    }
  },
  created() {
    // Access dynamic parameter from route
    this.dynamicParam = this.$route.params.id
  },
}
</script>

<script setup>
import RepoView from '../components/RepoView.vue'
</script>

<template>
  <nav></nav>
  <Suspense>
    <RepoView :repo=dynamicParam />

    <template #fallback>
        <div>
          Sorry, the repository {{ dynamicParam }} could not be retrieved at this moment
        </div>
      </template>
  </Suspense>
</template>
