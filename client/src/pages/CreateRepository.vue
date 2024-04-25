<script setup>
import { ref } from 'vue'
import { postPath } from '@/lib/lowlevel'
function handleFolderSelect(event) {
  const selectedFolder = event.target.files[0] // Assuming only one folder is selected
  this.$refs.folder = selectedFolder
  // You can now handle the selected folder here, for example, by uploading it to a server
}
async function getDir() {
  const dirHandle = await window.showDirectoryPicker()
  return dirHandle
}

const selectedDirectory = ref('');

function selectDir(event) {
  const files = event.target.files;
  if (files.length > 0) {
    const directory = files[0];
    // Assuming you want just the directory name without the path
    const directoryName = directory.webkitRelativePath.split('/')[0];
    selectedDirectory = directoryName;
  }
}

const path = ref('')
</script>

<template>
  <div>
    <h1>Create A New Repository</h1>
    <form>
      <label for="name">Repository Name:</label><br />
      <input type="text" id="name" name="name" /><br />
      <label for="path">Repository Path:</label><br />
      <input v-model="path" id="path" />
      <br />
    </form>
    <button @click="">Create</button>
  </div>
</template>
