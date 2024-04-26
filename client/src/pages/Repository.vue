<script lang="ts">
import RepoView from './RepoView.vue'
export default {
    name: "DynamicRoute",
    data() {
        return {
            dynamicParam: null
        };
    },
    created() {
        // Access dynamic parameter from route
        this.dynamicParam = this.$route.params.id;
    },
    components: { RepoView }
}
</script>

<template>
  <nav></nav>
  <RepoView />
</template>
