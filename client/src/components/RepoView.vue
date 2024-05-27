<script setup>
import * as demoApi from '@/api/demo'
import { onMounted } from 'vue'

const props = defineProps({
  repo: String
})

async function getRepoInformation() {
  return await Promise.resolve(demoApi.getRepoInfo(props.repo)).then((e) => {
    return typeof e.data === 'string' ? JSON.parse(e.data) : e.data
  })
}

let repoInfo = await getRepoInformation()

onMounted(() => {
  console.log(repoInfo)
})
</script>

<template>
  <div>
    <div class="menu"></div>
    <section class="upper-display">
      <div></div>
    </section>
    <section class="central-display">
      <div>
        <section class="repo-display">
          <div>
            <div></div>
            <ul></ul>
          </div>
        </section>
        <section class="meta-display">
          <div></div>
        </section>
      </div>
    </section>
    <section class="lower-display">
      <div></div>
    </section>
  </div>
</template>
