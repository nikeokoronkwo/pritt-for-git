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
  }
}
</script>

<template></template>
